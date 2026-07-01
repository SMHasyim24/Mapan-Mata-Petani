<?php

namespace App\Http\Controllers\Api\V1\User;

use App\Http\Controllers\Controller;
use App\Models\ExpertApplication;
use App\Models\User;
use App\Notifications\NewExpertApplicationNotification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ExpertApplicationController extends Controller
{
    /**
     * Get the current user's expert application status.
     */
    public function index(Request $request): JsonResponse
    {
        $application = $request->user()->expertApplications()->latest()->first();

        return response()->json([
            'status' => 'success',
            'data' => $application,
        ]);
    }

    /**
     * Submit a new expert application.
     */
    public function store(Request $request): JsonResponse
    {
        $user = $request->user();

        // Check if user already has a pending application
        $pendingApplication = $user->expertApplications()->where('status', 'pending')->first();
        if ($pendingApplication) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda sudah memiliki pengajuan yang sedang menunggu persetujuan.',
            ], 422);
        }

        // Check if user is already an expert or higher
        if ($user->isAtLeastAdmin()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda sudah memiliki akses pakar atau lebih tinggi.',
            ], 422);
        }

        $validated = $request->validate([
            'document' => 'required|file|mimes:pdf,jpg,jpeg,png|max:5120', // Max 5MB
            'notes' => 'nullable|string|max:1000',
        ]);

        $documentPath = $request->file('document')->store('expert-documents', 'public');

        $application = $user->expertApplications()->create([
            'document_path' => $documentPath,
            'notes' => $validated['notes'] ?? null,
            'status' => 'pending',
        ]);

        // Notify super_admins
        $superAdmins = User::where('role', User::ROLE_SUPER_ADMIN)->get();
        foreach ($superAdmins as $admin) {
            /** @var User $admin */
            $admin->notify(new NewExpertApplicationNotification($application));
        }

        // Notify the user themselves
        $user->notify(new \App\Notifications\ExpertApplicationSubmittedNotification());

        return response()->json([
            'status' => 'success',
            'message' => 'Pengajuan berhasil dikirim. Silakan tunggu peninjauan dari Super Admin.',
            'data' => $application,
        ], 201);
    }
}
