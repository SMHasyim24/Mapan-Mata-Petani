<?php

namespace App\Http\Controllers\Api\V1\User;

use App\Http\Controllers\Controller;
use App\Models\AdminApplication;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AdminApplicationController extends Controller
{
    /**
     * Get the current user's admin application status.
     */
    public function index(Request $request): JsonResponse
    {
        $application = $request->user()->adminApplications()->latest()->first();

        return response()->json([
            'status' => 'success',
            'data' => $application,
        ]);
    }

    /**
     * Submit a new admin application.
     */
    public function store(Request $request): JsonResponse
    {
        $user = $request->user();

        // Check if user already has a pending application
        $pendingApplication = $user->adminApplications()->where('status', 'pending')->first();
        if ($pendingApplication) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda sudah memiliki pengajuan yang sedang menunggu persetujuan.',
            ], 422);
        }

        // Check if user is already an admin or higher
        if ($user->isAdmin() || $user->isSuperAdmin()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda sudah memiliki akses admin atau lebih tinggi.',
            ], 422);
        }

        $validated = $request->validate([
            'agency_name' => 'required|string|max:255',
            'document' => 'required|file|mimes:pdf,jpg,jpeg,png|max:5120', // Max 5MB
            'notes' => 'nullable|string|max:1000',
        ]);

        $documentPath = $request->file('document')->store('admin-documents', 'public');

        $application = $user->adminApplications()->create([
            'agency_name' => $validated['agency_name'],
            'document_path' => $documentPath,
            'notes' => $validated['notes'] ?? null,
            'status' => 'pending',
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Pengajuan berhasil dikirim. Silakan tunggu peninjauan dari Super Admin.',
            'data' => $application,
        ], 201);
    }
}
