<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use App\Models\ExpertApplication;

class ExpertApplicationStatusNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public $application;

    /**
     * Create a new notification instance.
     */
    public function __construct(ExpertApplication $application)
    {
        $this->application = $application;
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
        $statusText = $this->application->status === 'approved' ? 'disetujui' : 'ditolak';
        $type = $this->application->status === 'approved' ? 'success' : 'error';
        $title = $this->application->status === 'approved' ? 'Pengajuan Pakar Disetujui' : 'Pengajuan Pakar Ditolak';
        
        $message = "Pengajuan Anda sebagai pakar telah {$statusText}.";
        if ($this->application->status === 'approved') {
            $message .= " Selamat datang! Anda sekarang dapat mengakses dashboard pakar.";
        } else {
            $message .= " Silakan periksa kembali persyaratan dan berkas Anda.";
        }

        return [
            'type' => $type,
            'title' => $title,
            'message' => $message,
            'action_url' => $this->application->status === 'approved' ? '/pakar/dashboard' : '/user/expert-application',
            'application_id' => $this->application->id,
        ];
    }
}
