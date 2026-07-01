<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;

class AuthController extends Controller
{
    /**
     * POST /api/v1/login
     */
    public function login(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        if (! Auth::attempt($validated)) {
            return response()->json([
                'message' => 'Email atau password salah.',
            ], 401);
        }

        $user = Auth::user();
        $token = $user->createToken('api-token')->plainTextToken;

        return response()->json([
            'message' => 'Login berhasil.',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
                'pending_role' => $user->pending_role,
                'avatar_url' => $user->avatar_url,
                'agency_name' => $user->agency_name,
            ],
            'token' => $token,
        ]);
    }

    /**
     * POST /api/v1/login/google
     */
    public function loginGoogle(Request $request)
    {
        $request->validate([
            'id_token' => 'required|string',
        ]);

        $idToken = $request->id_token;
        $action = $request->input('action', 'login'); // 'login' or 'register'

        $client = new \GuzzleHttp\Client(['verify' => false]);
        try {
            $response = $client->get('https://oauth2.googleapis.com/tokeninfo?id_token=' . $idToken);
            $payload = json_decode($response->getBody()->getContents(), true);

            if (!isset($payload['email'])) {
                return response()->json(['message' => 'Token Google tidak valid atau tidak memiliki email.'], 401);
            }

            $email = $payload['email'];
            $name = $payload['name'] ?? explode('@', $email)[0];
            $avatarUrl = $payload['picture'] ?? null;
            $googleId = $payload['sub'] ?? 'google_user';

            $user = User::where('email', $email)->first();
            $isNewUser = false;

            if ($action === 'login') {
                if (!$user) {
                    return response()->json(['message' => 'Akun Google ini belum terdaftar. Silakan daftar terlebih dahulu.'], 401);
                }
            } else if ($action === 'register') {
                if ($user) {
                    return response()->json(['message' => 'Email Google ini sudah terdaftar. Silakan masuk (login).'], 409);
                }
                $isNewUser = true;
                $user = User::create([
                    'name' => $name,
                    'email' => $email,
                    // Menggunakan ID Google sebagai dasar password agar tidak acak (sesuai permintaan),
                    // namun tetap mustahil ditebak oleh orang biasa.
                    'password' => Hash::make('GoogleAuth_' . $googleId),
                    'role' => User::ROLE_USER,
                    'avatar_url' => $avatarUrl,
                ]);
            } else {
                return response()->json(['message' => 'Invalid action parameter.'], 400);
            }

            $token = $user->createToken('api-token')->plainTextToken;

            return response()->json([
                'message' => 'Login Google berhasil.',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $user->role,
                    'pending_role' => $user->pending_role,
                    'avatar_url' => $user->avatar_url,
                    'agency_name' => $user->agency_name,
                ],
                'token' => $token,
                'is_new_user' => $isNewUser,
            ]);

        } catch (\Exception $e) {
            \Log::error('Google login error: ' . $e->getMessage());
            return response()->json([
                'message' => 'Gagal memverifikasi token Google: ' . $e->getMessage()
            ], 401);
        }
    }

    /**
     * POST /api/v1/forgot-password
     */
    public function forgotPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
        ]);

        $email = $request->email;
        // Generate a 6 digit OTP token
        $token = str_pad(random_int(100000, 999999), 6, '0', STR_PAD_LEFT);

        // Save token to password_reset_tokens table
        \Illuminate\Support\Facades\DB::table('password_reset_tokens')->updateOrInsert(
            ['email' => $email],
            [
                'token' => $token,
                'created_at' => now(),
            ]
        );

        // Send email (will be written to storage/logs/laravel.log because MAIL_MAILER=log)
        \Illuminate\Support\Facades\Mail::raw("Kode OTP Reset Password Anda adalah: {$token}\n\nMasukkan kode ini di aplikasi untuk mengubah password Anda.", function ($message) use ($email) {
            $message->to($email)->subject('Kode Reset Password - ' . config('app.name'));
        });

        return response()->json([
            'message' => 'Kode OTP untuk reset password telah dikirim ke email Anda.',
        ]);
    }

    /**
     * POST /api/v1/verify-otp
     */
    public function verifyOtp(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
            'token' => 'required|string',
        ]);

        $reset = \Illuminate\Support\Facades\DB::table('password_reset_tokens')->where('email', $request->email)->first();

        if (!$reset || $reset->token !== $request->token) {
            return response()->json([
                'message' => 'Kode OTP tidak valid atau salah.',
            ], 400);
        }

        if (\Carbon\Carbon::parse($reset->created_at)->addMinutes(15)->isPast()) {
            return response()->json([
                'message' => 'Kode OTP sudah kedaluwarsa. Silakan minta kode baru.',
            ], 400);
        }

        return response()->json([
            'message' => 'Kode OTP valid.',
        ]);
    }

    /**
     * POST /api/v1/reset-password
     */
    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
            'token' => 'required|string',
            'password' => 'required|string|min:8|confirmed',
        ]);

        $reset = \Illuminate\Support\Facades\DB::table('password_reset_tokens')->where('email', $request->email)->first();

        if (!$reset || $reset->token !== $request->token) {
            return response()->json([
                'message' => 'Kode OTP tidak valid atau salah.',
            ], 400);
        }

        // Check if token is older than 15 minutes
        if (\Carbon\Carbon::parse($reset->created_at)->addMinutes(15)->isPast()) {
            \Illuminate\Support\Facades\DB::table('password_reset_tokens')->where('email', $request->email)->delete();
            return response()->json([
                'message' => 'Kode OTP sudah kedaluwarsa. Silakan minta kode baru.',
            ], 400);
        }

        $user = User::where('email', $request->email)->first();
        $user->password = Hash::make($request->password);
        $user->save();

        \Illuminate\Support\Facades\DB::table('password_reset_tokens')->where('email', $request->email)->delete();

        return response()->json([
            'message' => 'Password berhasil diubah. Silakan login menggunakan password baru.',
        ]);
    }

    /**
     * POST /api/v1/register
     */
    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => ['required', 'string', 'min:8'],
            'role' => 'nullable|string|in:user,pakar',
        ], [
            'email.unique' => 'Akun sudah terdaftar, silakan login.',
        ]);

        $requestedRole = $validated['role'] ?? User::ROLE_USER;
        $actualRole = User::ROLE_USER;
        $pendingRole = ($requestedRole === User::ROLE_PAKAR) ? User::ROLE_PAKAR : null;

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'role' => $actualRole,
            'pending_role' => $pendingRole,
        ]);

        $token = $user->createToken('api-token')->plainTextToken;

        return response()->json([
            'message' => 'Registrasi berhasil.',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
                'pending_role' => $user->pending_role,
                'avatar_url' => $user->avatar_url,
                'agency_name' => $user->agency_name,
            ],
            'token' => $token,
        ], 201);
    }

    /**
     * POST /api/v1/logout
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logout berhasil.',
        ]);
    }

    /**
     * GET /api/v1/user
     */
    public function user(Request $request)
    {
        return response()->json([
            'user' => $request->user()->loadCount('detections'),
        ]);
    }

    /**
     * PUT /api/v1/user/profile
     */
    public function updateProfile(Request $request)
    {
        $user = $request->user();
        
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $user->id,
        ]);

        $user->update($validated);

        return response()->json([
            'message' => 'Profil berhasil diperbarui.',
            'user' => $user,
        ]);
    }

    /**
     * PUT /api/v1/user/password
     */
    public function updatePassword(Request $request)
    {
        $validated = $request->validate([
            'current_password' => ['required', 'current_password'],
            'password' => ['required', 'string', 'min:8', 'confirmed'],
        ]);

        $request->user()->update([
            'password' => Hash::make($validated['password']),
        ]);

        return response()->json([
            'message' => 'Kata sandi berhasil diperbarui.',
        ]);
    }

    /**
     * PUT /api/v1/user/role
     */
    public function updateRole(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'role' => 'required|string|in:user,pakar',
        ]);

        if ($validated['role'] === User::ROLE_PAKAR) {
            $user->update([
                'role' => User::ROLE_USER,
                'pending_role' => User::ROLE_PAKAR,
            ]);
            $message = 'Pengajuan peran pakar berhasil disimpan dan menunggu tinjauan.';
        } else {
            $user->update([
                'role' => User::ROLE_USER,
                'pending_role' => null,
            ]);
            $message = 'Peran berhasil diperbarui.';
        }

        return response()->json([
            'message' => $message,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
                'pending_role' => $user->pending_role,
                'avatar_url' => $user->avatar_url,
                'agency_name' => $user->agency_name,
            ],
        ]);
    }

    /**
     * POST /api/v1/user/photo
     */
    public function uploadPhoto(Request $request)
    {
        $request->validate([
            'photo' => 'required|image|max:2048', // max 2MB
        ]);

        $user = $request->user();

        // Delete old photo if exists
        if ($user->avatar_url && \Storage::disk('public')->exists(str_replace('/storage/', '', $user->avatar_url))) {
            \Storage::disk('public')->delete(str_replace('/storage/', '', $user->avatar_url));
        }

        $path = $request->file('photo')->store('avatars', 'public');
        $user->update(['avatar_url' => '/storage/' . $path]);

        return response()->json([
            'message' => 'Foto profil berhasil diunggah.',
            'user' => $user,
        ]);
    }

    /**
     * DELETE /api/v1/user/photo
     */
    public function deletePhoto(Request $request)
    {
        $user = $request->user();

        if ($user->avatar_url && \Storage::disk('public')->exists(str_replace('/storage/', '', $user->avatar_url))) {
            \Storage::disk('public')->delete(str_replace('/storage/', '', $user->avatar_url));
        }

        $user->update(['avatar_url' => null]);

        return response()->json([
            'message' => 'Foto profil berhasil dihapus.',
            'user' => $user,
        ]);
    }

    /**
     * DELETE /api/v1/user
     */
    public function destroy(Request $request)
    {
        $user = $request->user();
        
        // Delete photo
        if ($user->avatar_url && \Storage::disk('public')->exists(str_replace('/storage/', '', $user->avatar_url))) {
            \Storage::disk('public')->delete(str_replace('/storage/', '', $user->avatar_url));
        }

        // Delete detections (and their photos)
        foreach ($user->detections as $detection) {
            if ($detection->image_path && \Storage::disk('public')->exists($detection->image_path)) {
                \Storage::disk('public')->delete($detection->image_path);
            }
        }
        $user->detections()->delete();

        // Delete tokens
        $user->tokens()->delete();

        // Delete user
        $user->delete();

        return response()->json([
            'message' => 'Akun berhasil dihapus permanen.',
        ]);
    }

    /**
     * POST /api/v1/fcm-token
     */
    public function updateFcmToken(Request $request)
    {
        $request->validate([
            'fcm_token' => 'nullable|string',
        ]);

        $user = $request->user();
        $user->fcm_token = $request->fcm_token;
        $user->save();

        return response()->json([
            'message' => 'FCM Token berhasil diperbarui.',
        ]);
    }
}
