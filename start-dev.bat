@echo off

php -r "try { new PDO('mysql:host=127.0.0.1;port=3333;dbname=rapid_motors', 'root', 'pass'); echo 'EXISTS'; } catch(Exception $e) { echo 'NOTFOUND'; }" > %TEMP%\dbcheck.txt 2>nul
find "EXISTS" %TEMP%\dbcheck.txt >nul 2>&1

if %ERRORLEVEL% equ 0 (
    echo Database "rapid_motors" found. Skipping migration check...
    goto START
)

echo Checking database migration...
php artisan migrate
if %ERRORLEVEL% neq 0 (
    echo Migration failed or was cancelled. Stopping...
    exit /b 1
)

:START
echo Starting Laravel backend...
start "Laravel Backend" cmd /k "php artisan migrate:fresh --seed && php artisan serve"

echo Starting Frontend...
start "Frontend" cmd /k "npm run dev"

echo Done.
