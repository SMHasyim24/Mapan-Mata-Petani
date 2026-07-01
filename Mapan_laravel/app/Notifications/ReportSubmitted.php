<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use App\Models\Detection;

class ReportSubmitted extends Notification
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
        return [
            'detection_id' => $this->detection->id,
            'status' => $this->detection->status,
            'title' => 'Laporan Berhasil Dikirim',
            'body' => 'Laporan Anda mengenai "' . ($this->detection->disease->name ?? 'Penyakit tidak diketahui') . '" telah berhasil dikirim ke Pakar dan sedang menunggu tinjauan.',
            'image_url' => count($this->detection->images ?? []) > 0 ? $this->detection->images[0] : null,
        ];
    }
}
