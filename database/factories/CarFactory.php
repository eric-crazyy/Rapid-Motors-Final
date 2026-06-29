<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class CarFactory extends Factory
{
    public function definition(): array
    {
       return [
            'name'         => $this->faker->word(), // Modellnév
            'manufacturer' => $this->faker->company(), // Gyártó cég
            'year'         => $this->faker->year(), // Gyártási év
            'category'     => $this->faker->randomElement(['oldtimer', 'luxury', 'supercar']), // Fix kategóriák
            'price'        => $this->faker->numberBetween(10000, 1000000), // Ár (egész szám)
            'horsepower'   => $this->faker->numberBetween(100, 1000), // Lóerő
            'engine'       => $this->faker->word() . ' V8', // Motor típus
            'top_speed'    => $this->faker->numberBetween(150, 400), // Végsebesség
            'acceleration' => $this->faker->randomFloat(1, 2, 10), // 0-100 gyorsulás
            'description'  => $this->faker->sentence(), // Rövid leírás
            'is_featured'  => $this->faker->boolean(), // Kiemelt-e (true/false)
        ];
    }
}
