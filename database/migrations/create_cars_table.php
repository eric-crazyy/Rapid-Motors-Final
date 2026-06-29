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
        // Létrehozza a 'cars' táblát
        Schema::create('cars', function (Blueprint $table) {
            // Auto-increment elsődleges kulcs
            $table->id();

            // Autó neve
            $table->string('name');

            // Gyártó neve
            $table->string('manufacturer');

            // Gyártási év
            $table->integer('year');

            // Kategória: 'oldtimer', 'luxury', vagy 'supercar'
            $table->enum('category', ['oldtimer', 'luxury', 'supercar']);

            // Ár, 16 számjegy összesen, 2 tizedes
            $table->decimal('price', 16, 2);

            // Teljesítmény lóerőben
            $table->integer('horsepower');

            // Motor típusa (pl. V8, I4)
            $table->string('engine');

            // Végsebesség, 5 számjegy, 1 tizedes
            $table->decimal('top_speed', 5, 1);

            // Gyorsulás 0–100 km/h, 4 számjegy, 2 tizedes
            $table->decimal('acceleration', 4, 2);

            // Részletes leírás
            $table->text('description');

            // Kiemelt autó-e, alapértelmezett false
            $table->boolean('is_featured')->default(false);

            // Létrehozás és frissítés időbélyegzői (created_at, updated_at)
            $table->timestamps();
        });
    }

    /**
     * Fut a migráció visszavonásakor
     */
    public function down(): void
    {
        // Tábla törlése, ha létezik
        Schema::dropIfExists('cars');
    }
};
