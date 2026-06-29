<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Car;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CarController extends Controller
{
    // Összes autó lekérdezése (szűréssel, kereséssel, rendezéssel)
    public function index(Request $request)
    {
        $query = Car::query();

        // 1. Kategória szűrés (pl. ?category=supercar)
        if ($request->has('category')) {
            $query->where('category', $request->category);
        }

        // 2. Keresés név / gyártó / leírás alapján
        if ($request->has('search')) {
            $search = $request->search;

            $query->where(function($q) use ($search) {
                $q->where('name', 'like', "%$search%")
                  ->orWhere('manufacturer', 'like', "%$search%")
                  ->orWhere('description', 'like', "%$search%");
            });
        }

        // 3. Csak kiemelt autók (?featured=true)
        if ($request->has('featured')) {
            $query->where('is_featured', true);
        }

        // 4. Rendezés (alap: created_at desc)
        $allowedSortFields = ['created_at', 'price', 'year', 'horsepower', 'name', 'manufacturer'];
        $sortBy = in_array($request->get('sort_by'), $allowedSortFields) ? $request->get('sort_by') : 'created_at';
        $sortOrder = in_array($request->get('sort_order'), ['asc', 'desc']) ? $request->get('sort_order') : 'desc';
        $query->orderBy($sortBy, $sortOrder);

        return response()->json($query->get());
    }

    // Egy konkrét autó lekérdezése ID alapján
    public function show($id)
    {
        $car = Car::findOrFail($id);
        return response()->json($car);
    }

    // Új autó létrehozása
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'          => 'required|string|max:255',
            'manufacturer'  => 'required|string|max:255',
            'year'          => 'required|integer|min:1900|max:2100',
            'category'      => 'required|in:oldtimer,luxury,supercar',
            'price'         => 'required|numeric|min:0',
            'horsepower'    => 'required|integer|min:0',
            'engine'        => 'required|string|max:255',
            'top_speed'     => 'required|numeric|min:0',
            'acceleration'  => 'required|numeric|min:0',
            'description'   => 'required|string',
            'is_featured'   => 'boolean',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $car = Car::create($validator->validated());

        return response()->json($car, 201);
    }

    // Autó módosítása
    public function update(Request $request, $id)
    {
        $car = Car::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'name'          => 'string|max:255',
            'manufacturer'  => 'string|max:255',
            'year'          => 'integer|min:1900|max:2100',
            'category'      => 'in:oldtimer,luxury,supercar',
            'price'         => 'numeric|min:0',
            'horsepower'    => 'integer|min:0',
            'engine'        => 'string|max:255',
            'top_speed'     => 'numeric|min:0',
            'acceleration'  => 'numeric|min:0',
            'description'   => 'string',
            'is_featured'   => 'boolean',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $car->update($validator->validated());

        return response()->json($car);
    }

    // Autó törlése
    public function destroy($id)
    {
        $car = Car::findOrFail($id);
        $car->delete();

        return response()->json(['message' => 'Autó sikeresen törölve']);
    }
}
