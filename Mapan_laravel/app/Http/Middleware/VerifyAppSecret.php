<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class VerifyAppSecret
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $secret = config('app.secret_key');
        
        // If secret key is not configured, bypass this check (optional, but good for local dev if not set)
        if (empty($secret)) {
            return $next($request);
        }

        $providedSecret = $request->header('X-App-Secret');

        if ($providedSecret !== $secret) {
            return response()->json([
                'message' => 'Unauthorized Access. Invalid App Secret. Expected: ' . $secret . ' but got: ' . ($providedSecret ?? 'null')
            ], 401);
        }

        return $next($request);
    }
}
