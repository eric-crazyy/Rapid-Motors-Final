<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Fut a migráció alkalmazásakor
     */
    public function up(): void
    {
        // 'users' tábla létrehozása
        Schema::create('users', function (Blueprint $table) {
            $table->id(); // Auto-increment elsődleges kulcs
            $table->string('name'); // Felhasználó neve
            $table->string('email')->unique(); // Egyedi email cím
            $table->timestamp('email_verified_at')->nullable(); // Email ellenőrzés időpontja
            $table->string('password'); // Jelszó (hash-elve)
            $table->boolean('is_admin')->default(false); // Admin jogosultság, alapértelmezett false
            $table->rememberToken(); // 'remember me' token a belépéshez
            $table->timestamps(); // created_at és updated_at
        });

        // 'password_reset_tokens' tábla létrehozása
        Schema::create('password_reset_tokens', function (Blueprint $table) {
            $table->string('email')->primary(); // Email a kulcs, amihez a token tartozik
            $table->string('token'); // Token a jelszó visszaállításhoz
            $table->timestamp('created_at')->nullable(); // Mikor lett létrehozva a token
        });

        // 'sessions' tábla létrehozása a felhasználói session-ök tárolására
        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary(); // Session azonosító
            $table->foreignId('user_id')->nullable()->index(); // Kapcsolat a felhasználóhoz
            $table->string('ip_address', 45)->nullable(); // IP cím
            $table->text('user_agent')->nullable(); // Böngésző/user agent információ
            $table->longText('payload'); // Session adatok JSON vagy serializált formában
            $table->integer('last_activity')->index(); // Utolsó aktivitás időbélyege, indexelve a gyors lekérdezéshez
        });
    }

    /**
     * Fut a migráció visszavonásakor
     */
    public function down(): void
    {
        Schema::dropIfExists('users'); // Felhasználók törlése
        Schema::dropIfExists('password_reset_tokens'); // Jelszó reset tokenek törlése
        Schema::dropIfExists('sessions'); // Sessionök törlése
    }
};