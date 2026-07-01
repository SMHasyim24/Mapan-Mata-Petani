<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Detection;
use App\Models\Disease;
use App\Models\Symptom;
use App\Models\Treatment;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Cache;
use Illuminate\Validation\Rule;

class AdminApiController extends Controller
{
    // ===================================================================
    // Diseases CRUD
    // ===================================================================

    public function diseases()
    {
        $diseases = Cache::remember('admin_diseases', 86400, function () {
            return Disease::withCount(['symptoms', 'treatments', 'detections'])->get();
        });

        return response()->json([
            'diseases' => $diseases,
        ]);
    }

    public function storeDisease(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'latin_name' => 'nullable|string|max:255',
            'description' => 'required|string',
            'cause' => 'required|string',
            'symptoms' => 'nullable|array',
            'symptoms.*.id' => 'exists:symptoms,id',
            'symptoms.*.weight' => 'numeric|min:0.1|max:1',
        ]);

        $disease = Disease::create([
            'name' => $validated['name'],
            'slug' => Str::slug($validated['name']),
            'latin_name' => $validated['latin_name'] ?? null,
            'description' => $validated['description'],
            'cause' => $validated['cause'],
        ]);

        if (! empty($validated['symptoms'])) {
            foreach ($validated['symptoms'] as $symptom) {
                $disease->symptoms()->attach($symptom['id'], ['weight' => $symptom['weight'] ?? 1.00]);
            }
        }

        Cache::forget('admin_diseases');
        Cache::forget('public_diseases');

        return response()->json([
            'message' => 'Penyakit berhasil ditambahkan.',
            'disease' => $disease->load('symptoms'),
        ], 201);
    }

    public function updateDisease(Request $request, Disease $disease)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'latin_name' => 'nullable|string|max:255',
            'description' => 'required|string',
            'cause' => 'required|string',
            'symptoms' => 'nullable|array',
            'symptoms.*.id' => 'exists:symptoms,id',
            'symptoms.*.weight' => 'numeric|min:0.1|max:1',
        ]);

        $disease->update([
            'name' => $validated['name'],
            'slug' => Str::slug($validated['name']),
            'latin_name' => $validated['latin_name'] ?? null,
            'description' => $validated['description'],
            'cause' => $validated['cause'],
        ]);

        if (isset($validated['symptoms'])) {
            $syncData = [];
            foreach ($validated['symptoms'] as $symptom) {
                $syncData[$symptom['id']] = ['weight' => $symptom['weight'] ?? 1.00];
            }
            $disease->symptoms()->sync($syncData);
        }

        Cache::forget('admin_diseases');
        Cache::forget('public_diseases');

        return response()->json([
            'message' => 'Penyakit berhasil diperbarui.',
            'disease' => $disease->load('symptoms'),
        ]);
    }

    public function destroyDisease(Disease $disease)
    {
        $disease->delete();

        Cache::forget('admin_diseases');
        Cache::forget('public_diseases');

        return response()->json(['message' => 'Penyakit berhasil dihapus.']);
    }

    // ===================================================================
    // Symptoms CRUD
    // ===================================================================

    public function symptoms()
    {
        $symptoms = Cache::remember('admin_symptoms', 86400, function () {
            return Symptom::withCount('diseases')->orderBy('code')->get();
        });

        return response()->json([
            'symptoms' => $symptoms,
        ]);
    }

    public function storeSymptom(Request $request)
    {
        $validated = $request->validate([
            'code' => 'required|string|max:10|unique:symptoms,code',
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        $symptom = Symptom::create($validated);

        Cache::forget('admin_symptoms');

        return response()->json([
            'message' => 'Gejala berhasil ditambahkan.',
            'symptom' => $symptom,
        ], 201);
    }

    public function updateSymptom(Request $request, Symptom $symptom)
    {
        $validated = $request->validate([
            'code' => 'required|string|max:10|unique:symptoms,code,'.$symptom->id,
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        $symptom->update($validated);

        Cache::forget('admin_symptoms');

        return response()->json([
            'message' => 'Gejala berhasil diperbarui.',
            'symptom' => $symptom,
        ]);
    }

    public function destroySymptom(Symptom $symptom)
    {
        $symptom->delete();

        Cache::forget('admin_symptoms');

        return response()->json(['message' => 'Gejala berhasil dihapus.']);
    }

    // ===================================================================
    // Treatments CRUD
    // ===================================================================

    public function treatments()
    {
        $treatments = Cache::remember('admin_treatments', 86400, function () {
            return Treatment::with('disease:id,name,slug')->orderBy('disease_id')->get();
        });

        return response()->json([
            'treatments' => $treatments,
        ]);
    }

    public function storeTreatment(Request $request)
    {
        $validated = $request->validate([
            'disease_id' => 'required|exists:diseases,id',
            'type' => 'required|in:prevention,chemical,biological,cultural',
            'description' => 'required|string',
            'dosage' => 'nullable|string|max:50',
            'dosage_unit' => 'nullable|required_with:dosage|string|max:50',
            'priority' => 'integer|min:0',
        ]);

        $treatment = Treatment::create($validated);

        Cache::forget('admin_treatments');
        Cache::forget('admin_diseases');
        Cache::forget('public_diseases');

        return response()->json([
            'message' => 'Penanganan berhasil ditambahkan.',
            'treatment' => $treatment->load('disease'),
        ], 201);
    }

    public function updateTreatment(Request $request, Treatment $treatment)
    {
        $validated = $request->validate([
            'disease_id' => 'required|exists:diseases,id',
            'type' => 'required|in:prevention,chemical,biological,cultural',
            'description' => 'required|string',
            'dosage' => 'nullable|string|max:50',
            'dosage_unit' => 'nullable|required_with:dosage|string|max:50',
            'priority' => 'integer|min:0',
        ]);

        $treatment->update($validated);

        Cache::forget('admin_treatments');
        Cache::forget('admin_diseases');
        Cache::forget('public_diseases');

        return response()->json([
            'message' => 'Penanganan berhasil diperbarui.',
            'treatment' => $treatment->load('disease'),
        ]);
    }

    public function destroyTreatment(Treatment $treatment)
    {
        $treatment->delete();

        Cache::forget('admin_treatments');
        Cache::forget('admin_diseases');
        Cache::forget('public_diseases');

        return response()->json(['message' => 'Penanganan berhasil dihapus.']);
    }

    // ===================================================================
    // All Detections (admin view)
    // ===================================================================

    public function detections(Request $request)
    {
        $query = Detection::with(['user:id,name,email,avatar_url', 'disease.treatments']);

        if ($request->filled('method')) {
            $query->where('method', $request->input('method'));
        }

        if ($request->filled('city')) {
            $query->where('city', $request->input('city'));
        }

        // New Filters for Trending Details
        if ($request->filled('disease_id')) {
            $query->where('disease_id', $request->input('disease_id'));
        }

        if ($request->filled('time_range')) {
            $range = $request->input('time_range'); // 'minggu', 'bulan', 'tahun'
            if ($range === 'minggu') {
                $query->where('created_at', '>=', now()->startOfWeek());
            } elseif ($range === 'bulan') {
                $query->where('created_at', '>=', now()->startOfMonth());
            } elseif ($range === 'tahun') {
                $query->where('created_at', '>=', now()->startOfYear());
            }
        }

        // Filter berdasarkan peran
        if (Auth::user()->role === 'super_admin' || Auth::user()->role === 'admin') {
            // Super Admin & Admin hanya melihat laporan yang sudah diputuskan oleh Pakar
            $query->whereIn('status', ['verified', 'rejected']);
        } else {
            // Pakar melihat deteksi yang dikirim sebagai Laporan
            $query->where('status', '!=', 'diprediksi_ai');
        }

        return response()->json($query->latest()->paginate(50)); // Increased pagination for detailed view
    }

    public function updateDetection(Request $request, Detection $detection)
    {
        $validated = $request->validate([
            'disease_id' => 'nullable|exists:diseases,id',
            'status' => 'required|in:diprediksi_ai,pending,diproses_pakar,verified,rejected',
            'expert_notes' => 'nullable|string',
        ]);

        $detection->update([
            'disease_id' => $validated['disease_id'] ?? $detection->disease_id,
            'status' => $validated['status'],
            'expert_notes' => $validated['expert_notes'] ?? null,
        ]);

        // ===================================================================
        // DATABASE NOTIFICATION & FIREBASE CLOUD MESSAGING (FCM)
        // ===================================================================
        // Dispatch job ke antrean agar respons API tidak menunggu proses notifikasi selesai
        \App\Jobs\SendDetectionStatusNotification::dispatch($detection, $validated['status']);

        return response()->json([
            'message' => 'Status deteksi berhasil diperbarui.',
            'detection' => $detection->fresh(['disease']),
        ]);
    }

    // ===================================================================
    // User Management (super_admin only)
    // ===================================================================

    public function users()
    {
        return response()->json([
            'users' => User::withCount('detections')->latest()->paginate(15),
            'roles' => User::ROLES,
        ]);
    }

    public function updateUser(Request $request, User $user)
    {
        if ($user->id === Auth::id()) {
            return response()->json(['message' => 'Tidak dapat mengubah role sendiri.'], 403);
        }

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => ['required', 'email', Rule::unique('users')->ignore($user->id)],
            'role' => ['required', Rule::in(User::ROLES)],
        ]);

        $user->update([
            'name' => $validated['name'],
            'email' => $validated['email'],
        ]);
        $user->role = $validated['role'];
        $user->save();

        return response()->json([
            'message' => "User {$user->name} berhasil diperbarui.",
            'user' => $user->fresh(),
        ]);
    }

    public function destroyUser(User $user)
    {
        if ($user->id === Auth::id()) {
            return response()->json(['message' => 'Tidak dapat menghapus akun sendiri.'], 403);
        }

        if ($user->isSuperAdmin()) {
            return response()->json(['message' => 'Tidak dapat menghapus Super Admin.'], 403);
        }

        $user->delete();

        return response()->json(['message' => 'User berhasil dihapus.']);
    }
}
