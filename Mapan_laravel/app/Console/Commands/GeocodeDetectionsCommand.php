<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Detection;
use App\Services\GeocodingService;

class GeocodeDetectionsCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:geocode-detections';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Backfill city and province for existing detections using reverse geocoding';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $detections = Detection::whereNotNull('latitude')
            ->whereNotNull('longitude')
            ->whereNull('city')
            ->get();

        $count = $detections->count();
        $this->info("Found {$count} detections without city data.");

        $bar = $this->output->createProgressBar($count);
        $bar->start();

        foreach ($detections as $detection) {
            $location = GeocodingService::reverseGeocode((float)$detection->latitude, (float)$detection->longitude);
            if ($location) {
                $detection->city = $location['city'];
                $detection->province = $location['province'];
                $detection->save();
            }
            // Sleep for 1 second to respect Nominatim's 1 request/sec limit
            sleep(1);
            $bar->advance();
        }

        $bar->finish();
        $this->newLine();
        $this->info('Geocoding complete!');
    }
}
