<?php

namespace App\Jobs;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use App\Models\ExpertApplication;

class SendExpertApplicationStatusNotification implements ShouldQueue
{
    use Queueable;

    protected $application;
    protected $status;

    /**
     * Create a new job instance.
     */
    public function __construct(ExpertApplication $application, string $status)
    {
        $this->application = $application;
        $this->status = $status;
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        $this->application->load('user');
        
        $user = $this->application->user;

        if ($user && $user->fcm_token) {
            try {
                $factory = (new \Kreait\Firebase\Factory)
                    ->withServiceAccount(base_path(env('FIREBASE_CREDENTIALS', 'firebase_credentials.json')));
                
                $messaging = $factory->createMessaging();

                $title = $this->status === 'approved' ? 'Pengajuan Pakar Disetujui' : 'Pengajuan Pakar Ditolak';
                $body = "Pengajuan Anda sebagai pakar telah ";
                
                if ($this->status === 'approved') {
                    $body .= 'disetujui. Anda sekarang dapat mengakses dashboard pakar.';
                } else {
                    $body .= 'ditolak. Silakan periksa kembali persyaratan Anda.';
                }

                $message = \Kreait\Firebase\Messaging\CloudMessage::fromArray([
                    'token' => $user->fcm_token,
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
                        'application_id' => (string) $this->application->id,
                        'status' => $this->status,
                        'click_action' => 'FLUTTER_NOTIFICATION_CLICK',
                    ],
                ]);

                $messaging->send($message);
            } catch (\Exception $e) {
                \Illuminate\Support\Facades\Log::error('FCM Expert App Notification Job Error: ' . $e->getMessage());
            }
        }
    }
}
