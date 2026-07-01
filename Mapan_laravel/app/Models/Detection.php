<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Detection extends Model
{
    use HasFactory;

    protected $fillable = [
        'disease_id',
        'severity',
        'method',
        'image_path',
        'images',
        'label',
        'confidence',
        'temperature',
        'scanned_at',
        'scan_duration_ms',
        'latitude',
        'longitude',
        'city',
        'province',
        'connection_status',
        'status',
        'expert_notes',
        'predictions',
        'selected_symptoms',
        'notes',
    ];

    protected function casts(): array
    {
        return [
            'predictions' => 'array',
            'selected_symptoms' => 'array',
            'images' => 'array',
            'scanned_at' => 'datetime',
            'confidence' => 'decimal:2',
            'temperature' => 'decimal:1',
            'latitude' => 'decimal:7',
            'longitude' => 'decimal:7',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function disease(): BelongsTo
    {
        return $this->belongsTo(Disease::class);
    }
}
