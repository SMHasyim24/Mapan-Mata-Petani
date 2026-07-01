<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;
use App\Models\Detection;

class NewReportForPakar extends Notification
{
    use Queueable;

    protected $detection;

    /**
     * Create a new notification instance.
     */
    public function __construct(Detection $detection)
    {
        $this->detection = $detection;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['database'];
    }

    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    public function toArray(object $notifiable): array
    {
        $diseaseName = $this->detection->label;
        if (!$diseaseName && $this->detection->disease) {
            $diseaseName = $this->detection->disease->name;
        }
        $diseaseName = $diseaseName ?: 'Penyakit tidak diketahui';
        
        $userName = $this->detection->user ? $this->detection->user->name : 'Petani';

        return [
            'detection_id' => $this->detection->id,
            'status' => $this->detection->status,
            'title' => 'Laporan Baru Masuk',
            'body' => 'Laporan dari ' . $userName . ': ' . $diseaseName . '. Menunggu tinjauan Anda.',
            'image_url' => $this->detection->user ? $this->detection->user->avatar_url : null,
        ];
    }
}
