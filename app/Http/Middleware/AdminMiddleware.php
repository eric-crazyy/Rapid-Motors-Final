<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class AdminMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        // Ellenőrizzük, hogy a felhasználó be van-e jelentkezve
        // és hogy rendelkezik-e admin jogosultsággal
        if (!$request->user() || !$request->user()->is_admin) {
            // Ha a felhasználó nincs bejelentkezve vagy nem admin,
            // JSON választ küldünk vissza 403-as HTTP státusszal
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Ha minden rendben van, engedjük tovább a kérést
        return $next($request);
    }
}