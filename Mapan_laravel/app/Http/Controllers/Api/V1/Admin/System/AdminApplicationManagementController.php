<?php

namespace App\Http\Controllers\Api\V1\Admin\System;

use App\Http\Controllers\Controller;
use App\Models\AdminApplication;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AdminApplicationManagementController extends Controller
{
    /**
     * Get all pending admin applications.
     */
    public function index(Request $request): JsonResponse
    {
        $applications = AdminApplication::with('user:id,name,email,avatar_url')
            ->where('status', 'pending')
            ->latest()
            ->paginate(15);

        return response()->json([
            'status' => 'success',
            'data' => $applications,
        ]);
    }

    /**
     * Get details of a single admin application.
     */
    public function show(Request $request, AdminApplication $application): JsonResponse
    {
        $application->load('user:id,name,email,avatar_url');
        
        return response()->json([
            'status' => 'success',
            'data' => $application,
        ]);
    }

    /**
     * Approve an admin application.
     */
    public function approve(Request $request, AdminApplication $application): JsonResponse
    {
        if ($application->status !== 'pending') {
            return response()->json([
                'status' => 'error',
                'message' => 'Hanya pengajuan dengan status pending yang dapat disetujui.',
            ], 422);
        }

        $application->update([
            'status' => 'approved',
            'reviewed_by' => $request->user()->id,
            'reviewed_at' => now(),
        ]);

        // Update user role to admin and set agency_name
        $user = $application->user;
        if ($user->role === User::ROLE_USER) {
            $user->role = User::ROLE_ADMIN;
            $user->agency_name = $application->agency_name;
            $user->save();
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Pengajuan berhasil disetujui. Peran pengguna telah diperbarui menjadi Admin.',
        ]);
    }

    /**
     * Reject an admin application.
     */
    public function reject(Request $request, AdminApplication $application): JsonResponse
    {
        if ($application->status !== 'pending') {
            return response()->json([
                'status' => 'error',
                'message' => 'Hanya pengajuan dengan status pending yang dapat ditolak.',
            ], 422);
        }

        $application->update([
            'status' => 'rejected',
            'reviewed_by' => $request->user()->id,
            'reviewed_at' => now(),
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Pengajuan berhasil ditolak.',
        ]);
    }
}
