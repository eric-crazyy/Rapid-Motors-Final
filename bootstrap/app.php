<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php', // Webes útvonalak fájlja
        api: __DIR__.'/../routes/api.php', // API útvonalak fájlja
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        // Middleware-ek konfigurálása
        $middleware->alias([
            'admin' => \App\Http\Middleware\AdminMiddleware::class, // "admin" alias a saját admin middleware-hez
        ]);
        $middleware->statefulApi(); // Állapotkezelő (session) engedélyezése az API számára
    })
    ->withExceptions(function (Exceptions $exceptions) {

    })->create();
