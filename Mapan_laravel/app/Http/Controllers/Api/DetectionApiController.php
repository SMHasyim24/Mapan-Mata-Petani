<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Detection;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Symfony\Component\Process\Process;

class DetectionApiController extends Controller
{
    /**
     * GET /public/api/v1/detections
     * Public endpoint - returns all detections (no auth required)
     */
    public function index(Request $request)
    {
        $request->validate([
            'method' => 'nullable|in:image,expert_system',
            'per_page' => 'nullable|integer|min:1|max:50',
        ]);

        $query = Detection::with(['disease.treatments', 'user']);

        if ($request->filled('method')) {
            $query->where('method', $request->input('method'));
        }

        // Public feed hanya menampilkan deteksi yang sudah dikonfirmasi pakar (verified)
        $query->where('status', 'verified');

        $detections = $query->latest()->paginate($request->input('per_page', 15));

        return response()->json($detections);
    }

    /**
     * GET /private/api/v1/detections
     * Returns detection history for the authenticated user
     */
    public function history(Request $request)
    {
        $request->validate([
            'method' => 'nullable|in:image,expert_system',
            'per_page' => 'nullable|integer|min:1|max:50',
        ]);

        $query = Detection::where('user_id', Auth::id())
            ->where('is_hidden_from_user', false)
            ->with(['disease.treatments', 'user']);

        if ($request->filled('method')) {
            $query->where('method', $request->input('method'));
        }

        $detections = $query->latest()->paginate($request->input('per_page', 15));

        return response()->json($detections);
    }

    /**
     * POST /api/v1/detections
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'image' => 'nullable|image|max:10240',
            'images' => 'nullable|array|max:5',
            'images.*' => 'image|max:10240',
            'disease_id' => 'nullable|exists:diseases,id',
            'method' => 'required|in:image,expert_system',
            'label' => 'nullable|string',
            'confidence' => 'nullable|numeric|min:0|max:100',
            'scanned_at' => 'nullable|date',
            'temperature' => 'nullable|numeric',
            'scan_duration_ms' => 'nullable|integer|min:0',
            'latitude' => 'nullable|numeric|min:-90|max:90',
            'longitude' => 'nullable|numeric|min:-180|max:180',
            'city' => 'nullable|string|max:100',
            'province' => 'nullable|string|max:100',
            'connection_status' => 'nullable|string|in:online,offline',
            'predictions' => 'nullable|json',
            'selected_symptoms' => 'nullable|json',
            'notes' => 'nullable|string|max:1000',
            'is_report' => 'nullable|boolean',
        ]);

        $isReport = filter_var($validated['is_report'] ?? false, FILTER_VALIDATE_BOOLEAN);

        // Normalize confidence if it was sent as a decimal (0.0 - 1.0)
        $conf = $validated['confidence'] ?? null;
        if ($conf !== null && $conf <= 1.0 && $conf > 0) {
            $conf = $conf * 100;
            $validated['confidence'] = $conf;
        }

        // Edge Case Handling: Image Validation
        if ($validated['method'] === 'image' && isset($conf) && $conf < 40.0) {
            return response()->json([
                'message' => 'Gambar tidak dikenali atau objek tidak valid (Akurasi terlalu rendah).'
            ], 422);
        }

        $imagePath = null;
        $imagePaths = [];
        $label = $validated['label'] ?? 'Unknown';
        $folder = 'detections/'.Str::slug($label);

        // Handle single image (backward compatibility)
        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')->store($folder, 'public');
            $imagePaths[] = $imagePath;
        }

        // Handle multiple images
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $file) {
                $path = $file->store($folder, 'public');
                $imagePaths[] = $path;
                if ($imagePath === null) {
                    $imagePath = $path; // Set the first image as the main image_path
                }
            }
        }


        // Automatic reverse geocoding if city is missing but coordinates exist
        $city = $validated['city'] ?? null;
        $province = $validated['province'] ?? null;
        
        if (empty($city) && isset($validated['latitude']) && isset($validated['longitude'])) {
            try {
                $apiKey = config('services.openweathermap.key');
                if ($apiKey) {
                    $response = Http::timeout(5)->get('https://api.openweathermap.org/data/2.5/weather', [
                        'lat' => $validated['latitude'],
                        'lon' => $validated['longitude'],
                        'appid' => $apiKey,
                        'lang' => 'id'
                    ]);
                    if ($response->successful()) {
                        $data = $response->json();
                        $city = $data['name'] ?? null;
                        // OpenWeatherMap free doesn't easily give province, so we leave it null or set a generic one
                        $province = $province ?? 'Indonesia';
                    }
                }
            } catch (\Exception $e) {
                \Log::warning('Reverse geocoding failed: ' . $e->getMessage());
            }
        }

        $detection = new Detection([
            'disease_id' => $validated['disease_id'] ?? null,
            'ai_disease_id' => $validated['disease_id'] ?? null,
            'method' => $validated['method'],
            'image_path' => $imagePath,
            'images' => empty($imagePaths) ? null : $imagePaths,
            'label' => $validated['label'] ?? null,
            'confidence' => $validated['confidence'] ?? null,
            'temperature' => $validated['temperature'] ?? null,
            'scanned_at' => $validated['scanned_at'] ?? now(),
            'scan_duration_ms' => $validated['scan_duration_ms'] ?? null,
            'latitude' => $validated['latitude'] ?? null,
            'longitude' => $validated['longitude'] ?? null,
            'city' => $city,
            'province' => $province,
            'connection_status' => $validated['connection_status'] ?? 'online',
            'status' => $isReport ? 'pending' : 'diprediksi_ai',
            'predictions' => isset($validated['predictions']) ? json_decode($validated['predictions'], true) : null,
            'selected_symptoms' => isset($validated['selected_symptoms']) ? json_decode($validated['selected_symptoms'], true) : null,
            'notes' => $validated['notes'] ?? null,
        ]);
        $detection->user_id = Auth::id();
        $detection->save();

        if ($isReport) {
            // Notify the Petani (User) via Database
            $user = Auth::user();
            if ($user) {
                $user->notify(new \App\Notifications\ReportSubmitted($detection));
            }

            // Notify all Pakars via Database
            $pakars = \App\Models\User::where('role', 'pakar')->get();
            foreach ($pakars as $pakar) {
                $pakar->notify(new \App\Notifications\NewReportForPakar($detection));
            }

            try {
                $messaging = app('firebase.messaging');
                
                $messages = [];
                foreach ($pakars as $pakar) {
                    if ($pakar->fcm_token) {
                        $messages[] = \Kreait\Firebase\Messaging\CloudMessage::fromArray([
                            'token' => $pakar->fcm_token,
                            'notification' => [
                                'title' => 'Laporan Baru Masuk',
                                'body' => 'Laporan dari ' . ($user ? $user->name : 'Petani') . ': ' . ($validated['label'] ?? 'Penyakit tidak diketahui'),
                            ],
                            'data' => [
                                'detection_id' => (string) $detection->id,
                                'type' => 'new_report'
                            ]
                        ]);
                    }
                }
                
                if (!empty($messages)) {
                    $messaging->sendAll($messages);
                }
            } catch (\Exception $e) {
                \Log::error('FCM Send Error (Pakar): ' . $e->getMessage());
            }
        }

        return response()->json([
            'message' => 'Hasil deteksi berhasil disimpan.',
            'detection' => $detection->load('disease'),
        ], 201);
    }

    /**
     * GET /public/api/v1/detections/{detection}
     * Public endpoint - returns single detection detail (no auth required)
     */
    public function show(Detection $detection)
    {
        return response()->json([
            'data' => $detection->load(['disease.treatments', 'disease.symptoms', 'user']),
        ]);
    }

    /**
     * DELETE /api/v1/detections/{detection}
     */
    public function destroy(Detection $detection)
    {
        if ($detection->user_id !== Auth::id()) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        if ($detection->is_report) {
            $detection->is_hidden_from_user = true;
            $detection->save();
        } else {
            if ($detection->image_path) {
                Storage::disk('public')->delete($detection->image_path);
            }
            if ($detection->images) {
                foreach ($detection->images as $img) {
                    Storage::disk('public')->delete($img);
                }
            }
            $detection->delete();
        }

        return response()->json([
            'message' => 'Deteksi berhasil dihapus.',
        ]);
    }

    /**
     * POST /private/api/v1/detections/predict
     * Run ML inference on uploaded image
     */
    public function predict(Request $request)
    {
        $request->validate([
            'image' => 'required|image|mimes:jpeg,png,jpg,webp|max:10240',
        ]);

        $tempPath = null;
        $fullPath = null;

        try {
            $image = $request->file('image');
            $tempPath = $image->store('temp', 'public');
            $fullPath = storage_path('app/public/'.$tempPath);

            $pythonPath = base_path('venv/bin/python');
            $scriptPath = base_path('scripts/predict.py');

            $process = new Process([$pythonPath, $scriptPath, $fullPath]);
            $process->setTimeout(30);
            $process->run();

            if (! $process->isSuccessful()) {
                return response()->json([
                    'message' => 'Prediction failed: '.$process->getErrorOutput(),
                ], 500);
            }

            $output = $process->getOutput();

            if (! $output) {
                return response()->json([
                    'message' => 'Prediction failed.',
                ], 500);
            }

            $result = json_decode($output, true);

            if (isset($result['error'])) {
                return response()->json([
                    'message' => $result['error'],
                ], 500);
            }

            return response()->json([
                'label' => $result['top_label'],
                'confidence' => $result['top_confidence'],
                'predictions' => $result['predictions'],
            ]);
        } finally {
            if ($fullPath && file_exists($fullPath)) {
                @unlink($fullPath);
            }
            if ($tempPath) {
                Storage::disk('public')->delete($tempPath);
            }
        }
    }

    public function review(Request $request, Detection $detection)
    {
        // Only Pakar can review
        if (Auth::user()->role !== 'pakar' && Auth::user()->role !== 'super_admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Concurrency check: Ensure only the pakar who claimed it can review it
        if ($detection->pakar_id !== null && $detection->pakar_id !== Auth::id() && Auth::user()->role !== 'super_admin') {
            return response()->json(['message' => 'Laporan ini sudah diambil oleh pakar lain.'], 403);
        }

        $validated = $request->validate([
            'status' => 'required|in:verified,rejected',
            'expert_notes' => 'required|string|max:2000',
            'disease_id' => 'required_if:status,verified|exists:diseases,id',
            'severity' => 'required|string|in:Sehat,Ringan,Waspada,Berbahaya',
            'confidence' => 'nullable|numeric|min:0|max:100',
        ]);

        $detection->status = $validated['status'];
        if (isset($validated['expert_notes'])) {
            $detection->expert_notes = $validated['expert_notes'];
        }
        if (isset($validated['disease_id']) && $validated['status'] === 'verified') {
            $detection->disease_id = $validated['disease_id'];
        }
        if (isset($validated['severity'])) {
            $detection->severity = $validated['severity'];
        }
        if (isset($validated['confidence']) && $validated['status'] === 'verified') {
            $detection->confidence = $validated['confidence'];
        }

        $detection->save();

        // Dispatch job to notify the user (Petani)
        \App\Jobs\SendDetectionStatusNotification::dispatch($detection, $validated['status'], Auth::user());

        // Notify the Pakar themselves that they successfully reviewed it
        Auth::user()->notify(new \App\Notifications\ReportReviewedByPakar($detection));

        return response()->json([
            'message' => 'Detection reviewed successfully',
            'detection' => $detection,
        ]);
    }

    /**
     * POST /private/api/v1/detections/{detection}/claim
     * Claim a detection report so other pakars cannot review it.
     */
    public function claim(Detection $detection)
    {
        if (Auth::user()->role !== 'pakar' && Auth::user()->role !== 'super_admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        if ($detection->status !== 'pending') {
            if ($detection->status === 'diproses_pakar') {
                if ($detection->pakar_id === Auth::id()) {
                    return response()->json(['message' => 'Anda sudah mengambil laporan ini.', 'detection' => $detection]);
                }
                return response()->json(['message' => 'Maaf, laporan ini sudah ditangani oleh pakar lain.'], 400);
            }
            return response()->json(['message' => 'Laporan ini sudah diproses dan tidak bisa diambil.'], 400);
        }

        $detection->status = 'diproses_pakar'; // We use diproses_pakar as in_review state
        $detection->pakar_id = Auth::id();
        $detection->save();

        return response()->json([
            'message' => 'Berhasil mengambil laporan.',
            'detection' => $detection,
        ]);
    }

    /**
     * POST /private/api/v1/detections/{detection}/unclaim
     */
    public function unclaim(Detection $detection)
    {
        if (Auth::user()->role !== 'pakar' && Auth::user()->role !== 'super_admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        if ($detection->pakar_id !== Auth::id() && Auth::user()->role !== 'super_admin') {
            return response()->json(['message' => 'Anda tidak berhak melepaskan laporan ini.'], 403);
        }

        $detection->status = 'pending';
        $detection->pakar_id = null;
        $detection->save();

        return response()->json([
            'message' => 'Laporan dikembalikan ke antrean.',
            'detection' => $detection,
        ]);
    }
}
