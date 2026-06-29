<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Car extends Model
{
    use HasFactory;

    // Mezők
    protected $fillable = [
        'name',
        'manufacturer',
        'year',
        'category',
        'price',
        'horsepower',
        'engine',
        'top_speed',
        'acceleration',
        'description',
        'is_featured',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'top_speed' => 'decimal:1',
        'acceleration' => 'decimal:2',
        'is_featured' => 'boolean',
    ];
}
