<?php

namespace App\Http\Controllers\Api\V1\Admin\System;

use App\Http\Controllers\Controller;
use App\Models\ExpertApplication;
use App\Models\User;
use App\Notifications\ExpertApplicationStatusNotification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ExpertApplicationManagementController extends Controller
{
    /**
     * Get all pending expert applications.
     */
    public function index(Request $request): JsonResponse
    {
        $applications = ExpertApplication::with('user:id,name,email,avatar_url')
            ->where('status', 'pending')
            ->latest()
            ->paginate(15);

        return response()->json([
            'status' => 'success',
            'data' => $applications,
        ]);
    }

    /**
     * Get details of a single expert application.
     */
    public function show(Request $request, ExpertApplication $application): JsonResponse
    {
        $application->load('user:id,name,email,avatar_url');
        
        return response()->json([
            'status' => 'success',
            'data' => $application,
        ]);
    }

    /**
     * Approve an expert application.
     */
    public function approve(Request $request, ExpertApplication $application): JsonResponse
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

        // Update user role to pakar
        $user = $application->user;
        if ($user->role === User::ROLE_USER) {
            $user->role = User::ROLE_PAKAR;
            $user->save();
        }

        // Notify user
        $user->notify(new ExpertApplicationStatusNotification($application));
        \App\Jobs\SendExpertApplicationStatusNotification::dispatch($application, 'approved');

        return response()->json([
            'status' => 'success',
            'message' => 'Pengajuan berhasil disetujui. Peran pengguna telah diperbarui menjadi Pakar.',
        ]);
    }

    /**
     * Reject an expert application.
     */
    public function reject(Request $request, ExpertApplication $application): JsonResponse
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

        // Notify user
        $application->user->notify(new ExpertApplicationStatusNotification($application));
        \App\Jobs\SendExpertApplicationStatusNotification::dispatch($application, 'rejected');

        return response()->json([
            'status' => 'success',
            'message' => 'Pengajuan berhasil ditolak.',
        ]);
    }
}
