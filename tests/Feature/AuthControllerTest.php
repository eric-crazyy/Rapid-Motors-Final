<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class AuthControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_admin_can_login_with_correct_credentials()
    {
        // 1. Admin felhasználó létrehozása
        $password = 'secret123';
        $admin = User::factory()->create([
            'email' => 'admin@test.com',
            'password' => Hash::make($password),
            'is_admin' => true,
        ]);

        // 2. Bejelentkezési kísérlet
        $response = $this->postJson('/api/login', [
            'email' => 'admin@test.com',
            'password' => $password,
        ]);

        // 3. Ellenőrzés: kaptunk tokent?
        $response->assertStatus(200)
                 ->assertJsonStructure(['access_token', 'token_type', 'user']);
    }

    public function test_non_admin_cannot_login()
    {
        $password = 'secret123';
        $user = User::factory()->create([
            'email' => 'user@test.com',
            'password' => Hash::make($password),
            'is_admin' => false, // Nem admin!
        ]);

        $response = $this->postJson('/api/login', [
            'email' => 'user@test.com',
            'password' => $password,
        ]);

        // 403 Forbidden hiba elvárása
        $response->assertStatus(403)
                 ->assertJson(['message' => 'Nincs jogosultságod']);
    }

    public function test_user_can_logout()
    {
        $user = User::factory()->create(['is_admin' => true]);
        
        // 1. Generálunk egy valódi Sanctum tokent
        $token = $user->createToken('test_token')->plainTextToken;

        // 2. A kérést a tokennel küldjük el a fejlécben
        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
                        ->postJson('/api/logout');

        $response->assertStatus(200)
                ->assertJson(['message' => 'Sikeres kijelentkezés']);
                
        // Ellenőrizzük, hogy a token valóban törlődött-e az adatbázisból
        $this->assertCount(0, $user->tokens);
    }
}
