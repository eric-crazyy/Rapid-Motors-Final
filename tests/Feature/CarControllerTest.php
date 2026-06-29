<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use App\Models\Car;
use App\Models\User;
use Tests\TestCase;

class CarControllerTest extends TestCase
{
    // Minden teszt után visszaállítja az adatbázist, hogy ne befolyásolják egymást
    use RefreshDatabase;

    // Segédmetódus: admin felhasználót hoz létre, hogy ne ismételjük minden tesztben
    private function createAdmin(): User
    {
        /** @var User $admin */
        $admin = User::factory()->create(['is_admin' => true]);
        return $admin;
    }

    public function test_it_can_list_all_cars()
    {
        // 3 autót gyártunk, majd megnézzük, hogy az API mind visszaadja-e
        Car::factory()->count(3)->create();

        $response = $this->getJson('/api/cars');

        $response->assertStatus(200)
                 ->assertJsonCount(3);
    }

    public function test_it_can_filter_cars_by_category()
    {
        // Két különböző kategóriájú autó – csak a supercar-t kérjük le
        Car::factory()->create(['category' => 'supercar']);
        Car::factory()->create(['category' => 'oldtimer']);

        $response = $this->getJson('/api/cars?category=supercar');

        // Pontosan 1 találatot várunk, és az tényleg supercar legyen
        $response->assertStatus(200)
                 ->assertJsonCount(1)
                 ->assertJsonPath('0.category', 'supercar');
    }

    public function test_it_can_create_a_car()
    {
        $admin = $this->createAdmin();

        // Teljes adatsor – minden kötelező és opcionális mező meg van adva
        $data = [
            'name'         => 'F40',
            'manufacturer' => 'Ferrari',
            'year'         => 1987,
            'category'     => 'supercar',
            'price'        => 1500000,
            'horsepower'   => 478,
            'engine'       => 'V8 Twin-Turbo',
            'top_speed'    => 324,
            'acceleration' => 4.1,
            'description'  => 'A legend.',
            'is_featured'  => true,
        ];

        $response = $this->actingAs($admin)->postJson('/api/cars', $data);

        // Sikeres létrehozás: 201-es státusz + adatbázisban is szerepel
        $response->assertStatus(201)
                 ->assertJsonFragment(['name' => 'F40']);

        $this->assertDatabaseHas('cars', ['name' => 'F40']);
    }

    public function test_it_fails_validation_when_creating_a_car()
    {
        $admin = $this->createAdmin();

        // Szándékosan üres adat – a validációnak el kell utasítania
        $response = $this->actingAs($admin)->postJson('/api/cars', []);

        // 422-t és a hiányzó mezők hibáit várjuk a válaszban
        $response->assertStatus(422)
                 ->assertJsonStructure(['errors' => ['name', 'manufacturer', 'category']]);
    }

    public function test_it_can_show_a_specific_car()
    {
        $car = Car::factory()->create(['name' => 'Test Car']);

        $response = $this->getJson("/api/cars/{$car->id}");

        // Az API-nak a pontos nevet kell visszaadnia
        $response->assertStatus(200)
                 ->assertJsonPath('name', 'Test Car');
    }

    public function test_it_can_update_a_car()
    {
        $admin = $this->createAdmin();
        $car = Car::factory()->create(['name' => 'Old Name']);

        // Csak a nevet frissítjük, a többi mező változatlan marad
        $response = $this->actingAs($admin)->putJson("/api/cars/{$car->id}", [
            'name' => 'New Name',
        ]);

        $response->assertStatus(200);
        // Adatbázisban is az új névnek kell szerepelnie
        $this->assertDatabaseHas('cars', ['id' => $car->id, 'name' => 'New Name']);
    }

    public function test_it_can_delete_a_car()
    {
        $admin = $this->createAdmin();
        $car = Car::factory()->create();

        $response = $this->actingAs($admin)->deleteJson("/api/cars/{$car->id}");

        $response->assertStatus(200);
        // Törlés után az autónak már nem szabad szerepelnie az adatbázisban
        $this->assertDatabaseMissing('cars', ['id' => $car->id]);
    }
}
