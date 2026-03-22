@echo off
echo ==========================================
echo   WildX Backend - First Time Setup
echo ==========================================
echo.
echo [1/3] Installing packages...
call npm install
echo.
echo [2/3] Setting up database tables and data...
call node setup.js
echo.
echo [3/3] Starting server...
call npm run dev
