<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    // Bejelentkezés
    public function login(Request $request)
    {
        // 1. Adatok ellenőrzése (email és jelszó kötelező)
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required'
        ]);

        // Ha hibás adat, visszaküldjük a hibákat
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // 2. Felhasználó megkeresése email alapján
        $user = User::where('email', $request->email)->first();

        // 3. Ha nincs ilyen user VAGY rossz a jelszó → hiba
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Hibás email vagy jelszó'], 401);
        }

        // 4. Csak admin léphet be
        if (!$user->is_admin) {
            return response()->json(['message' => 'Nincs jogosultságod'], 403);
        }

        // 5. Token létrehozása (Sanctum)
        $token = $user->createToken('auth_token')->plainTextToken;

        // 6. Token és user visszaküldése
        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user
        ]);
    }

    // Kijelentkezés (aktuális token törlése)
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json(['message' => 'Sikeres kijelentkezés']);
    }

    // Bejelentkezett felhasználó adatainak lekérdezése
    public function me(Request $request)
    {
        return response()->json($request->user());
    }
}