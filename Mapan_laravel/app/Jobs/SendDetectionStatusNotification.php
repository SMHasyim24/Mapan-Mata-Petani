<?php

namespace App\Jobs;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;

class SendDetectionStatusNotification implements ShouldQueue
{
    use Queueable;

    protected $detection;
    protected $status;
    protected $pakar;

    /**
     * Create a new job instance.
     */
    public function __construct(\App\Models\Detection $detection, string $status, $pakar = null)
    {
        $this->detection = $detection;
        $this->status = $status;
        $this->pakar = $pakar;
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        $this->detection->load('user');
        
        if ($this->detection->user) {
            $this->detection->user->notify(new \App\Notifications\DetectionStatusUpdated($this->detection, $this->pakar));
        }

        if ($this->detection->user && $this->detection->user->fcm_token) {
            try {
                $factory = (new \Kreait\Firebase\Factory)
                    ->withServiceAccount(base_path(env('FIREBASE_CREDENTIALS', 'firebase_credentials.json')));
                
                $messaging = $factory->createMessaging();

                $title = 'Laporan Anda Diperbarui';
                $body = 'Laporan deteksi tanaman Anda telah ';
                
                if ($this->status === 'verified') {
                    $body .= 'divalidasi dan dikonfirmasi oleh pakar.';
                } elseif ($this->status === 'rejected') {
                    $body .= 'ditolak atau dianggap tidak valid oleh pakar.';
                } elseif ($this->status === 'diproses_pakar') {
                    $body .= 'diterima dan sedang dianalisis oleh pakar.';
                } else {
                    $body .= 'diubah statusnya menjadi: ' . $this->status;
                }

                $message = \Kreait\Firebase\Messaging\CloudMessage::fromArray([
                    'token' => $this->detection->user->fcm_token,
                    'notification' => [
                        'title' => $title,
                        'body' => $body,
                    ],
                    'android' => [
                        'priority' => 'HIGH',
                        'notification' => [
                            'channel_id' => 'mapan_channel_v2',
                            'notification_priority' => 'PRIORITY_MAX',
                        ],
                    ],
                    'data' => [
                        'detection_id' => (string) $this->detection->id,
                        'status' => $this->status,
                        'click_action' => 'FLUTTER_NOTIFICATION_CLICK', // For handling taps in Flutter
                    ],
                ]);

                $messaging->send($message);
            } catch (\Exception $e) {
                \Illuminate\Support\Facades\Log::error('FCM Notification Job Error: ' . $e->getMessage());
            }
        }
    }
}
