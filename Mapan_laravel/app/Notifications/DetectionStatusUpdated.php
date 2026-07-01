<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use App\Models\Detection;

class DetectionStatusUpdated extends Notification
{
    use Queueable;

    protected $detection;
    protected $pakar;

    /**
     * Create a new notification instance.
     */
    public function __construct(Detection $detection, $pakar = null)
    {
        $this->detection = $detection;
        $this->pakar = $pakar;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['database']; // We only need database since FCM is sent manually via Kreait
    }

    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    public function toArray(object $notifiable): array
    {
        $status = $this->detection->status;
        $title = 'Laporan Anda Diperbarui';
        $body = 'Laporan deteksi tanaman Anda telah ';
        
        $imageUrl = null;
        
        if ($status === 'verified') {
            $body .= 'divalidasi dan dikonfirmasi ' . ($this->pakar ? 'oleh pakar ' . $this->pakar->name : 'oleh pakar') . '.';
        } elseif ($status === 'rejected') {
            $body .= 'ditolak atau dianggap tidak valid ' . ($this->pakar ? 'oleh pakar ' . $this->pakar->name : 'oleh pakar') . '.';
        } else {
            $body .= 'diubah statusnya menjadi: ' . $status;
        }
        
        if ($this->pakar && $this->pakar->avatar_url) {
            $imageUrl = $this->pakar->avatar_url;
        }

        return [
            'detection_id' => $this->detection->id,
            'status' => $status,
            'title' => $title,
            'body' => $body,
            'image_url' => $imageUrl,
            'expert_notes' => $this->detection->expert_notes,
        ];
    }
}
