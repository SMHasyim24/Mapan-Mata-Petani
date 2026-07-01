<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Detection;
use Illuminate\Http\Request;

class MapController extends Controller
{
    /**
     * GET /api/v1/admin/map/detections
     * Fetch detection data for the map, filtered by the last 30 days.
     */
    public function detections(Request $request)
    {
        $query = Detection::with(['disease:id,name', 'user:id,name'])
            ->whereNotNull('latitude')
            ->whereNotNull('longitude');

        // Apply filters if present
        if ($request->has('disease_id') && $request->disease_id != 'all') {
            $query->where('disease_id', $request->disease_id);
        }

        if ($request->has('start_date')) {
            $query->where('created_at', '>=', $request->start_date . ' 00:00:00');
        }

        if ($request->has('end_date')) {
            $query->where('created_at', '<=', $request->end_date . ' 23:59:59');
        }

        if (!$request->has('start_date') && !$request->has('end_date')) {
            // Default: last 30 days if no explicit date filter
            $query->where('created_at', '>=', now()->subDays(30));
        }

        $detections = $query->get(['id', 'disease_id', 'user_id', 'latitude', 'longitude', 'created_at', 'confidence', 'image_path', 'city', 'severity']);

        $mapData = $detections->map(function ($detection) {
            $diseaseName = $detection->disease ? $detection->disease->name : 'Unknown';
            
            // Use severity from database, default to Belum Dikonfirmasi if not set
            $severity = $detection->severity ?? 'Belum Dikonfirmasi';

            return [
                'id' => $detection->id,
                'disease_name' => $diseaseName,
                'latitude' => (float) $detection->latitude,
                'longitude' => (float) $detection->longitude,
                'confidence' => $detection->confidence,
                'date' => $detection->created_at->format('Y-m-d H:i:s'),
                'image_url' => $detection->image_path ? url('storage/' . ltrim($detection->image_path, '/')) : null,
                'user_name' => $detection->user ? $detection->user->name : 'Anonim',
                'severity' => $severity,
                'city' => $detection->city,
            ];
        });

        return response()->json([
            'status' => 'success',
            'data' => $mapData,
        ]);
    }
}
