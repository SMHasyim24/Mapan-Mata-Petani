<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Detection;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Exports\MapReportExport;
use Maatwebsite\Excel\Facades\Excel;
use Barryvdh\DomPDF\Facade\Pdf;

class MapReportController extends Controller
{
    /**
     * Get grouped map statistics by city.
     */
    public function statistics(Request $request)
    {
        $city = $request->query('city');
        $diseaseId = $request->query('disease_id');
        $startDate = $request->query('start_date');
        $endDate = $request->query('end_date');
        
        // Get all detections that have a city
        $query = Detection::with('disease:id,name')
            ->whereNotNull('city')
            ->select('city', 'province', 'disease_id', DB::raw('COUNT(*) as count'));
            
        if ($city) {
            $query->where('city', $city);
        }
        if ($diseaseId && $diseaseId !== 'all') {
            $query->where('disease_id', $diseaseId);
        }
        if ($startDate) {
            $query->where('created_at', '>=', $startDate . ' 00:00:00');
        }
        if ($endDate) {
            $query->where('created_at', '<=', $endDate . ' 23:59:59');
        }
            
        $grouped = $query->groupBy('city', 'province', 'disease_id')->get();

        $stats = [];
        foreach ($grouped as $row) {
            $key = $row->city . '|' . $row->province;
            if (!isset($stats[$key])) {
                $stats[$key] = [
                    'city' => $row->city,
                    'province' => $row->province,
                    'total_reports' => 0,
                    'diseases' => [],
                ];
            }
            
            $stats[$key]['total_reports'] += $row->count;
            
            $diseaseName = $row->disease ? $row->disease->name : 'Penyakit Tidak Diketahui';
            $stats[$key]['diseases'][] = [
                'name' => $diseaseName,
                'count' => $row->count,
            ];
        }

        // Sort diseases by count for each city
        $finalStats = [];
        foreach ($stats as $key => $stat) {
            usort($stat['diseases'], function($a, $b) {
                return $b['count'] <=> $a['count'];
            });
            
            // Get average lat/lng for this city to place the marker
            $avgCoords = Detection::where('city', $stat['city'])
                ->select(DB::raw('AVG(latitude) as lat, AVG(longitude) as lng'))
                ->first();
                
            $stat['coordinate'] = [
                'lat' => $avgCoords->lat ?? -0.789275,
                'lng' => $avgCoords->lng ?? 113.921327,
            ];
            
            $stat['top_disease'] = $stat['diseases'][0]['name'] ?? 'Tidak ada';
            $stat['top_disease_count'] = $stat['diseases'][0]['count'] ?? 0;
            
            $finalStats[] = $stat;
        }

        return response()->json(['data' => $finalStats]);
    }

    /**
     * Export raw data and statistics to PDF or Excel.
     */
    public function export(Request $request)
    {
        $format = $request->query('format', 'pdf');
        $city = $request->query('city');
        $diseaseId = $request->query('disease_id');
        $startDate = $request->query('start_date');
        $endDate = $request->query('end_date');
        
        $statsResponse = $this->statistics($request)->getData(true);
        $statistics = $statsResponse['data'] ?? [];

        $filename = 'Laporan_Peta_Sebaran_Wabah' . ($city ? '_' . str_replace(' ', '_', $city) : '');

        if ($format === 'excel') {
            return Excel::download(new MapReportExport($statistics), $filename . '.xlsx');
        }

        // Fetch raw detections for the second table in PDF
        $query = Detection::with('disease:id,name')->orderBy('created_at', 'desc');
        
        if ($city) {
            $query->where('city', $city);
        }
        if ($diseaseId && $diseaseId !== 'all') {
            $query->where('disease_id', $diseaseId);
        }
        if ($startDate) {
            $query->where('created_at', '>=', $startDate . ' 00:00:00');
        }
        if ($endDate) {
            $query->where('created_at', '<=', $endDate . ' 23:59:59');
        }
        
        $detections = $query->get();

        $pdf = Pdf::loadView('reports.map_report', [
            'statistics' => $statistics,
            'detections' => $detections,
            'date' => now()->format('d F Y H:i'),
            'city' => $city,
        ])->setPaper('a4', 'landscape');

        return $pdf->download($filename . '.pdf');
    }
}
