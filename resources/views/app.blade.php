<!DOCTYPE html>
<html lang="hu">
<head>
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Rapid Motors</title>

    @vite('resources/js/app.js') 
    <!-- Laravel Vite helper, ami betölti a Vue alkalmazás fő JavaScript bundle-jét -->
    <!-- Ez indítja el a "Single Page Application"-t, és itt kerül a Vue router és az összes komponens betöltésre -->
</head>
<body>
    <div id="app"></div> 
    <!-- A Vue root elem: ide fog “befésülődni” az összes Vue komponens -->
    <!-- Például a router view: <router-view></router-view> is ide kerül -->
</body>
</html>