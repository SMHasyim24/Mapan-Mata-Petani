<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('detections', function (Blueprint $table) {
            if (!Schema::hasColumn('detections', 'pakar_id')) {
                $table->foreignId('pakar_id')->nullable()->constrained('users')->nullOnDelete();
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('detections', function (Blueprint $table) {
            if (Schema::hasColumn('detections', 'pakar_id')) {
                $table->dropForeign(['pakar_id']);
                $table->dropColumn('pakar_id');
            }
        });
    }
};
