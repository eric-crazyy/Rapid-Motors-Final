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
set /p comp_choice="Would you like to run 'composer install' now? (yes/no): "
if /I "%comp_choice%"=="yes" (
    echo.
    echo Running composer install...
    call composer install
) else (
    echo Skipping composer install. App might fail to start.
)
echo.

:CHECK_FRONTEND
:: 2. FRONTEND DEPENDENCY CHECK
if not exist "node_modules" goto MISSING_NODE
goto CHECK_APP_KEY

:MISSING_NODE
echo ============================================================
echo [WARNING] Frontend dependencies (node_modules folder) are missing!
echo ============================================================
set /p npm_choice="Would you like to run 'npm install' now? (yes/no): "
if /I "%npm_choice%"=="yes" (
    echo.
    echo Running npm install...
    call npm install
) else (
    echo Skipping npm install. App might fail to start.
)
echo.

:CHECK_APP_KEY
:: 3. APP KEY GENERATION CHECK
findstr /C:"APP_KEY=base64:" .env >nul
if %ERRORLEVEL% neq 0 (
    echo ============================================================
    echo [INFO] Application encryption key is missing. Generating key...
    echo ============================================================
    php artisan key:generate
    echo.
)

:CHECK_DATABASE
:: 4. DATABASE CHECK (PHP PDO - matching default commented env settings)
echo Checking database connection...
php -r "try { new PDO('mysql:host=127.0.0.1;port=3306;dbname=laravel', 'root', ''); echo 'EXISTS'; } catch(Exception $e) { echo 'NOTFOUND'; }" > %TEMP%\dbcheck.txt 2>nul
find "EXISTS" %TEMP%\dbcheck.txt >nul 2>&1

if %ERRORLEVEL% equ 0 (
    echo Database "laravel" found.
    goto START_SERVERS
)

echo Database "laravel" not found. Initializing migration...
php artisan migrate
if %ERRORLEVEL% neq 0 (
    echo Migration failed or was cancelled. Stopping...
    exit /b 1
)

:START_SERVERS
echo ============================================================
echo Starting development servers...
echo ============================================================
echo.

:: Launch Backend (Ctrl+Click on the link in the terminal to open)
start "Rapid Motors - Backend (Laravel)" cmd /k "php artisan migrate:fresh --seed && php artisan serve --port=8000"

:: Launch Frontend
start "Rapid Motors - Frontend (Vue/Vite)" cmd /k "npm run dev"

exit