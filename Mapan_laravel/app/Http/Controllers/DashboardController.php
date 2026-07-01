<?php

namespace App\Http\Controllers;

use App\Models\Detection;
use App\Models\Disease;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class DashboardController extends Controller
{
    public function index()
    {
        $user = Auth::user();

        // Total detections by user
        $totalDetections = Detection::where('user_id', $user->id)->count();

        // Detections this month
        $detectionsThisMonth = Detection::where('user_id', $user->id)
            ->whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)
            ->count();

        // Average confidence
        $averageConfidence = Detection::where('user_id', $user->id)
            ->whereNotNull('confidence')
            ->avg('confidence');

        // Disease distribution (for chart)
        $diseaseDistribution = Detection::where('user_id', $user->id)
            ->whereNotNull('disease_id')
            ->select('disease_id', DB::raw('count(*) as count'))
            ->groupBy('disease_id')
            ->with('disease:id,name')
            ->get()
            ->map(fn ($item) => [
                'name' => $item->disease?->name ?? 'Unknown',
                'count' => $item->count,
            ]);

        // Most detected disease
        $mostDetectedDisease = $diseaseDistribution->sortByDesc('count')->first();

        // Recent detections
        $recentDetections = Detection::where('user_id', $user->id)
            ->with('disease:id,name,slug')
            ->latest()
            ->take(5)
            ->get();

        // Insight Data: Most frequent disease in the last 30 days
        $insightDiseaseId = Detection::where('user_id', $user->id)
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

        return Inertia::render('dashboard', [
            'stats' => [
                'totalDetections' => $totalDetections,
                'detectionsThisMonth' => $detectionsThisMonth,
                'averageConfidence' => $averageConfidence ? round($averageConfidence, 1) : 0,
                'mostDetectedDisease' => $mostDetectedDisease['name'] ?? '-',
            ],
            'diseaseDistribution' => $diseaseDistribution->values(),
            'recentDetections' => $recentDetections,
            'insight' => $insight,
        ]);
    }
}
