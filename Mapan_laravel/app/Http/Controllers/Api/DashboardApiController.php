<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Detection;
use App\Models\Disease;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class DashboardApiController extends Controller
{
    /**
     * GET /api/v1/dashboard/stats
     */
    public function stats()
    {
        $user = Auth::user();
        
        // Base query depending on role
        $baseQuery = Detection::query();
        if ($user->role === 'pakar' || $user->role === 'super_admin' || $user->role === 'admin') {
            // Pakar/Admin sees all reports
            $baseQuery->where('status', '!=', 'diprediksi_ai');
        } else {
            // Petani sees only their own scans/reports
            $baseQuery->where('user_id', $user->id);
        }

        $totalDetections = (clone $baseQuery)->count();

        $detectionsThisMonth = (clone $baseQuery)
            ->where('created_at', '>=', now()->subDays(7))
            ->count();

        $averageConfidence = (clone $baseQuery)
            ->whereNotNull('confidence')
            ->avg('confidence');

        $diseaseDistribution = (clone $baseQuery)
            ->whereNotNull('disease_id')
            ->select('disease_id', DB::raw('count(*) as count'))
            ->groupBy('disease_id')
            ->with('disease:id,name')
            ->get()
            ->map(fn ($item) => [
                'name' => $item->disease?->name ?? 'Unknown',
                'count' => $item->count,
            ]);

        $recentDetections = (clone $baseQuery)
            ->with('disease:id,name,slug')
            ->latest()
            ->take(10)
            ->get();

        // Insight Data: Most frequent disease in the last 30 days
        $insightDiseaseId = (clone $baseQuery)
            ->whereNotNull('disease_id')
            ->where('created_at', '>=', now()->subDays(30))
            ->select('disease_id', DB::raw('count(*) as count'))
            ->groupBy('disease_id')
            ->orderByDesc('count')
            ->first();

        $insight = ['has_insight' => false];

        if ($insightDiseaseId) {
            $disease = Disease::with(['treatments' => function ($query) {
                $query->orderBy('priority')->limit(1);
            }])->find($insightDiseaseId->disease_id);

            if ($disease) {
                $treatmentText = $disease->treatments->first()?->description;
                if ($treatmentText && strlen($treatmentText) > 150) {
                    $treatmentText = substr($treatmentText, 0, 147) . '...';
                }

                $insight = [
                    'has_insight' => true,
                    'disease_name' => $disease->name,
                    'count' => $insightDiseaseId->count,
                    'recommendation' => $treatmentText ?? 'Konsultasikan dengan pakar untuk penanganan lebih lanjut.',
                ];
            }
        }

        // Calculate Trending Diseases (Last 30 Days)
        $total30Days = (clone $baseQuery)
            ->whereNotNull('disease_id')
            ->where('created_at', '>=', now()->subDays(30))
            ->count();

        $trendingDiseasesQuery = (clone $baseQuery)
            ->whereNotNull('disease_id')
            ->where('created_at', '>=', now()->subDays(30))
            ->select('disease_id', DB::raw('count(*) as count'))
            ->groupBy('disease_id')
            ->orderByDesc('count')
            ->take(10)
            ->get();

        $trendingDiseases = [];
        foreach ($trendingDiseasesQuery as $trend) {
            $diseaseModel = Disease::find($trend->disease_id);
            // Cari gambar dari recent detection untuk penyakit ini
            $latestReport = (clone $baseQuery)
                ->where('disease_id', $trend->disease_id)
                ->whereNotNull('image_path')
                ->latest()
                ->first();

            if ($diseaseModel) {
                $percentage = $total30Days > 0 ? ($trend->count / $total30Days) * 100 : 0;
                $trendingDiseases[] = [
                    'disease_id' => $diseaseModel->id,
                    'title' => $diseaseModel->name,
                    'count' => $trend->count,
                    'percentage' => round($percentage),
                    'image' => $latestReport ? asset('storage/' . $latestReport->image_path) : null,
                ];
            }
        }

        $totalExpertApplications = 0;
        if ($user->role === 'super_admin' || $user->role === 'pakar' || $user->role === 'admin') {
            $totalExpertApplications = \App\Models\ExpertApplication::where('status', 'pending')->count();
        }

        return response()->json([
            'stats' => [
                'total_detections' => $total30Days > 0 ? $total30Days : $totalDetections, // Return 30 days total for trend UI or keep original
                'total_all_time' => $totalDetections,
                'detections_this_month' => $detectionsThisMonth,
                'average_confidence' => $averageConfidence ? round($averageConfidence, 1) : 0,
                'total_expert_applications' => $totalExpertApplications,
            ],
            'disease_distribution' => $diseaseDistribution->values(),
            'recent_detections' => $recentDetections,
            'insight' => $insight,
            'trending_diseases' => $trendingDiseases,
        ]);
    }
}
