<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\User>
 */
class UserFactory extends Factory
{
    /**
     * Statikus változó a jelszó tárolására, így minden generált felhasználónál ugyanazt a hash-elt jelszót használjuk
     */
    protected static ?string $password;

    /**
     * 
     * Itt adjuk meg, hogy egy új User példány milyen alapértelmezett adatokkal jöjjön létre
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            // Véletlenszerű név generálása
            'name' => fake()->name(),

            // Véletlenszerű, de egyedi email cím generálása
            'email' => fake()->unique()->safeEmail(),

            // Az email cím alapértelmezés szerint igazolt (verifikált)
            'email_verified_at' => now(),

            // Jelszó hash-elése (ha még nincs statikus password beállítva, itt hozzuk létre)
            'password' => static::$password ??= Hash::make('password'),

            // Véletlenszerű remember_token generálása
            'remember_token' => Str::random(10),
        ];
    }

    /**
     * Állapot beállítása az "unverified" (nem ellenőrzött) emailhez
     * Ezt a metódust hívhatjuk, ha tesztadatban nem akarjuk az emailt igazoltnak jelölni
     */
    public function unverified(): static
    {
        // Az állapotot úgy állítjuk be, hogy az email_verified_at értéke null legyen
        return $this->state(fn (array $attributes) => [
            'email_verified_at' => null,
        ]);
    }
}