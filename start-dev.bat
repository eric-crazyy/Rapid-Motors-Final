@echo off
title Rapid Motors - Dev Environment Startup
cls

:: 1. BACKEND DEPENDENCY CHECK
if not exist "vendor" goto MISSING_VENDOR
goto CHECK_FRONTEND

:MISSING_VENDOR
echo ============================================================
echo [WARNING] Laravel backend dependencies (vendor folder) are missing!
echo ============================================================

:LOOP_VENDOR
set "comp_choice="
set /p comp_choice="Would you like to run 'composer install' now? (yes/no): "
if /I "%comp_choice%"=="yes" goto RUN_COMPOSER
if /I "%comp_choice%"=="no" (
    echo Exiting program...
    timeout /t 2 >nul
    exit
)
echo Invalid input! Please type 'yes' or 'no'.
echo.
goto LOOP_VENDOR

:RUN_COMPOSER
echo.
echo Running composer install... Please wait...
:: --no-scripts prevents Laravel from freezing at autoload generation before DB/Key exists
cmd /c composer install --no-scripts
echo.
goto CHECK_FRONTEND


:CHECK_FRONTEND
:: 2. FRONTEND DEPENDENCY CHECK
if not exist "node_modules" goto MISSING_NODE
goto CHECK_APP_KEY

:MISSING_NODE
echo ============================================================
echo [WARNING] Frontend dependencies (node_modules folder) are missing!
echo ============================================================

:LOOP_NODE
set "npm_choice="
set /p npm_choice="Would you like to run 'npm install' now? (yes/no): "
if /I "%npm_choice%"=="yes" goto RUN_NPM
if /I "%npm_choice%"=="no" (
    echo Exiting program...
    timeout /t 2 >nul
    exit
)
echo Invalid input! Please type 'yes' or 'no'.
echo.
goto LOOP_NODE

:RUN_NPM
echo.
echo Running npm install... Please wait...
cmd /c npm install
echo.
goto CHECK_APP_KEY


:CHECK_APP_KEY
:: 3. APP KEY GENERATION CHECK
findstr /C:"APP_KEY=base64:" .env >nul
if %ERRORLEVEL% neq 0 (
    echo ============================================================
    echo [INFO] Application encryption key is missing. Generating key...
    echo ============================================================
    cmd /c php artisan key:generate
    echo.
)
goto CHECK_DATABASE


:CHECK_DATABASE
:: 4. DATABASE CONNECTION & AUTO-CREATION
echo Checking database connection...
php -r "try { $p = new PDO('mysql:host=127.0.0.1;port=3306', 'root', ''); $p->exec('CREATE DATABASE IF NOT EXISTS laravel'); echo 'OK'; } catch(Exception $e) { echo 'ERROR'; }" > %TEMP%\dbcheck.txt 2>nul
find "OK" %TEMP%\dbcheck.txt >nul 2>&1

if %ERRORLEVEL% neq 0 (
    echo.
    echo ============================================================
    echo [ERROR] Could not connect to MySQL! 
    echo Please make sure XAMPP / MySQL is running on port 3306.
    echo ============================================================
    echo.
    pause
    exit /b 1
)

echo Database is ready.
echo.
goto START_SERVERS


:START_SERVERS
echo ============================================================
echo Starting development servers...
echo ============================================================
echo.

:: Launch Backend
start "Rapid Motors - Backend (Laravel)" cmd /k "php artisan migrate:fresh --seed && php artisan serve --port=8000"

:: Launch Frontend
start "Rapid Motors - Frontend (Vue/Vite)" cmd /k "npm run dev"

exit