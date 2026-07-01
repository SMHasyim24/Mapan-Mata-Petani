<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Laravel\Socialite\Facades\Socialite;

class GoogleApiController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'token' => 'required|string', // Token dari Flutter GoogleSignIn
        ]);

        try {
            // Verifikasi token dengan Google (menggunakan driver google di Socialite stateless)
            $googleUser = Socialite::driver('google')->stateless()->userFromToken($request->token);
            
            $user = User::where('email', $googleUser->getEmail())->first();
            
            if ($user) {
                if (! $user->google_id) {
                    $user->update([
                        'google_id' => $googleUser->getId(),
                        'avatar' => $googleUser->getAvatar(),
                    ]);
                }
            } else {
                $user = User::create([
                    'name' => $googleUser->getName(),
                    'email' => $googleUser->getEmail(),
                    'google_id' => $googleUser->getId(),
                    'avatar' => $googleUser->getAvatar(),
                    'password' => Hash::make(Str::random(16)),
                    'is_active' => true,
                ]);
                $user->role = 'user';
                $user->save();
            }

            // Buat Sanctum token untuk API
            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'success' => true,
                'access_token' => $token,
                'token_type' => 'Bearer',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $user->role,
                    'avatar' => $user->avatar,
                ]
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Token Google tidak valid atau kedaluwarsa.',
                'error' => $e->getMessage()
            ], 401);
        }
    }
}
