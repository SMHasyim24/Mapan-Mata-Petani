<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class GeocodingService
{
    /**
     * Reverse geocode coordinates to get city and province using OpenStreetMap Nominatim.
     * 
     * @param float $latitude
     * @param float $longitude
     * @return array|null Returns ['city' => '...', 'province' => '...'] or null on failure
     */
    public static function reverseGeocode($latitude, $longitude)
    {
        if (empty($latitude) || empty($longitude)) {
            return null;
        }

        try {
            $response = Http::withHeaders([
                'User-Agent' => 'MapanApp/1.0 (contact: admin@mapan.test)',
            ])->get('https://nominatim.openstreetmap.org/reverse', [
                'lat' => $latitude,
                'lon' => $longitude,
                'format' => 'jsonv2',
                'zoom' => 10, // Zoom level 10 is City level
            ]);

            if ($response->successful()) {
                $data = $response->json();
                
                if (isset($data['address'])) {
                    $address = $data['address'];
                    
                    // City could be mapped to city, town, municipality, or county
                    $city = $address['city'] 
                        ?? $address['town'] 
                        ?? $address['municipality'] 
                        ?? $address['county'] 
                        ?? $address['region'] 
                        ?? 'Tidak Diketahui';
                        
                    $province = $address['state'] 
                        ?? $address['province'] 
                        ?? 'Tidak Diketahui';

                    return [
                        'city' => $city,
                        'province' => $province,
                    ];
                }
            }
            
            Log::warning("Nominatim reverse geocoding failed: HTTP {$response->status()}", [
                'response' => $response->body()
            ]);
        } catch (\Exception $e) {
            Log::error('Exception in GeocodingService: ' . $e->getMessage());
        }

        return null;
    }
}
