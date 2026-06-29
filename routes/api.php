<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CarController;
use App\Http\Controllers\AuthController;

/* Publikus route-ok */
Route::get('/cars', [CarController::class, 'index']); /* Összes autó lekérdezése */
Route::get('/cars/{id}', [CarController::class, 'show']); /* Egy autó lekérdezése ID alapján */

/* Bejelentkezés */
Route::post('/login', [AuthController::class, 'login']); /* Token generálás */

/* Védett route-ok (bejelentkezés szükséges) */
Route::middleware('auth:sanctum')->group(function () {

    Route::post('/logout', [AuthController::class, 'logout']); /* Kijelentkezés */
    Route::get('/me', [AuthController::class, 'me']); /* Saját adatok lekérdezése */

    /* Csak admin által elérhető route-ok */
    Route::middleware('admin')->group(function () {

        Route::post('/cars', [CarController::class, 'store']); /* Új autó létrehozása */
        Route::put('/cars/{id}', [CarController::class, 'update']); /* Autó módosítása */
        Route::delete('/cars/{id}', [CarController::class, 'destroy']); /* Autó törlése */

    });
});