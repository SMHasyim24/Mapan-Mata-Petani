<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Symfony\Component\HttpFoundation\Response;

class IdempotencyMiddleware
{
    public function handle(Request $request, Closure $next): Response
    {
        // 1. Hanya proses method yang mengubah data
        if (!in_array($request->method(), ['POST', 'PUT', 'PATCH', 'DELETE'])) {
            return $next($request);
        }

        // 2. Bypass jika header Idempotency-Key tidak dikirim
        $key = $request->header('Idempotency-Key');
        if (!$key) {
            return $next($request);
        }

        $cacheKey = "idempotency:{$key}";
        $lockKey = "idempotency_lock:{$key}";

        // 3. Gunakan Atomic Lock untuk menangani race condition
        $lock = Cache::lock($lockKey, 10); // lock max 10 detik

        try {
            // Tunggu hingga lock dilepas jika request lain sedang berproses (max 10 detik)
            $lock->block(10);

            // Cek jika respons sudah ada di cache
            if (Cache::has($cacheKey)) {
                $cachedResponseData = Cache::get($cacheKey);
                $content = $cachedResponseData['content'];
                
                // Buat objek response (JSON jika array, normal jika string/HTML)
                $response = is_array($content)
                    ? response()->json($content, $cachedResponseData['status'])
                    : response($content, $cachedResponseData['status']);

                // Kembalikan header asli jika ada
                if (isset($cachedResponseData['headers']) && is_array($cachedResponseData['headers'])) {
                    foreach ($cachedResponseData['headers'] as $headerName => $headerValues) {
                        if (is_array($headerValues)) {
                            foreach ($headerValues as $value) {
                                $response->headers->set($headerName, $value);
                            }
                        } else {
                            $response->headers->set($headerName, $headerValues);
                        }
                    }
                }
                
                // 4. Tambahkan header penanda cache
                $response->headers->set('X-Cache-Idempotent', 'true');
                return $response;
            }

            // Jalankan request utama
            $response = $next($request);

            // Simpan respons sukses ke cache untuk 24 jam
            if ($response->isSuccessful()) {
                $rawContent = $response->getContent();
                $content = json_decode($rawContent, true);
                
                // Jika bukan json, simpan sebagai string mentah
                if (json_last_error() !== JSON_ERROR_NONE) {
                    $content = $rawContent;
                }

                Cache::put($cacheKey, [
                    'content' => $content,
                    'status' => $response->getStatusCode(),
                    'headers' => $response->headers->all(),
                ], now()->addDay());
            }

            return $response;

        } finally {
            // Selalu lepas lock setelah selesai
            optional($lock)->release();
        }
    }
}
