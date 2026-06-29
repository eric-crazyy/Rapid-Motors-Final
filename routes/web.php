<?php

use Illuminate\Support\Facades\Route;

// Ez a route minden GET kérést elkap, függetlenül attól, mi van az URL-ben
Route::get('/{any}', function () {
    // és visszaadja az 'app' nevű Blade nézetet a views mappából
    return view('app');
})->where('any', '.*'); // a where('any', '.*') rész azt jelenti, hogy bármilyen karakterlánc jöhet az {any} helyére