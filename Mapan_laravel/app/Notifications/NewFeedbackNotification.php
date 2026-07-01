<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;
use App\Models\Feedback;

class NewFeedbackNotification extends Notification
{
    use Queueable;

    public $feedback;

    /**
     * Create a new notification instance.
     */
    public function __construct(Feedback $feedback)
    {
        $this->feedback = $feedback;
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
            'type' => 'info',
            'title' => 'Laporan Bug & Masukan Baru',
            'message' => "Terdapat laporan " . $this->feedback->type . " baru dari pengguna.",
            'action_url' => '/admin/feedbacks',
            'feedback_id' => $this->feedback->id,
        ];
    }
}
