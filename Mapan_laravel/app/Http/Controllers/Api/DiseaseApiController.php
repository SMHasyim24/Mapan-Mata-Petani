<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Disease;
use Illuminate\Support\Facades\Cache;

class DiseaseApiController extends Controller
{
    /**
     * GET /api/v1/diseases
     * Get all diseases with symptoms and treatments
     */
    public function index()
    {
        $diseases = Cache::remember('public_diseases', 86400, function () {
            return Disease::with(['symptoms', 'treatments'])->get()->toArray();
        });

        return response()->json([
            'diseases' => $diseases,
        ]);
    }

    /**
     * GET /api/v1/diseases/{slug}
     * Get disease by slug with symptoms and treatments
     */
    public function show(Disease $disease)
    {
        $disease->load(['symptoms', 'treatments']);

        return response()->json([
            'disease' => $disease,
        ]);
    }
}
