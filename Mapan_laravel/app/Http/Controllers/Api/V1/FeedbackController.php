<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Feedback;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class FeedbackController extends Controller
{
    public function index(Request $request)
    {
        $user = Auth::user();
        if ($user->role === 'super_admin') {
            $feedbacks = Feedback::with(['user:id,name,email,avatar_url', 'responder:id,name,role'])
                ->latest()
                ->get();
        } else {
            $feedbacks = Feedback::with(['responder:id,name,role'])
                ->where('user_id', $user->id)
                ->latest()
                ->get();
        }
        
        return response()->json(['data' => $feedbacks]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'type' => 'required|in:bug,feature,general',
            'content' => 'required|string',
            'image' => 'nullable|image|max:10240',
        ]);

        $feedback = new Feedback();
        $feedback->user_id = Auth::id();
        $feedback->type = $validated['type'];
        $feedback->content = $validated['content'];
        $feedback->status = 'open';

        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('feedbacks', 'public');
            $feedback->image_path = '/storage/' . ltrim($path, '/');
        }

        $feedback->save();

        $superAdmins = \App\Models\User::where('role', 'super_admin')->get();
        \Illuminate\Support\Facades\Notification::send($superAdmins, new \App\Notifications\NewFeedbackNotification($feedback));

        return response()->json([
            'message' => 'Laporan berhasil dikirim.',
            'data' => $feedback
        ], 201);
    }

    public function reply(Request $request, Feedback $feedback)
    {
        $user = Auth::user();
        if ($user->role !== 'super_admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $validated = $request->validate([
            'admin_response' => 'required|string',
        ]);

        $feedback->admin_response = $validated['admin_response'];
        $feedback->responder_id = $user->id;
        $feedback->status = 'resolved';
        $feedback->save();

        return response()->json([
            'message' => 'Balasan berhasil dikirim.',
            'data' => $feedback->load('responder:id,name,role')
        ]);
    }
}
