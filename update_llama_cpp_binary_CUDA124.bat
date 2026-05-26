@echo off
setlocal enabledelayedexpansion
cd /d %~dp0

echo ========================================
echo   Llama.cpp Auto Updater (CUDA 12.4)
echo ========================================

:: --- 1. Get latest tag from GitHub API ---
echo [1/5] Fetching latest release version from GitHub...
set "API_URL=https://api.github.com/repos/ggml-org/llama.cpp/releases/latest"
for /f "tokens=*" %%a in ('powershell -command "(Invoke-RestMethod -Uri '%API_URL%').tag_name"') do set "LATEST_TAG=%%a"

if "%LATEST_TAG%"=="" (
    echo [ERROR] Could not fetch the latest version tag.
    pause
    exit /b
)
echo Latest version found: %LATEST_TAG%

:: --- 2. Construct Download URL ---
:: File pattern: llama-TAG-bin-win-cuda-12.4-x64.zip
set "FILENAME=llama-%LATEST_TAG%-bin-win-cuda-12.4-x64.zip"
set "DL_URL=https://github.com/ggml-org/llama.cpp/releases/download/%LATEST_TAG%/%FILENAME%"

echo [2/5] Downloading %FILENAME%...
curl.exe -L -o llama_update.zip "%DL_URL%"
if not exist llama_update.zip (
    echo [ERROR] Download failed.
    pause
    exit /b
)

:: --- 3. Stop Running Server ---
echo [3/5] Stopping llama-server.exe if running...
taskkill /F /IM llama-server.exe >nul 2>&1

:: --- 4. Extract and Overwrite ---
echo [4/5] Extracting and updating files...
powershell -command "Expand-Archive -Path llama_update.zip -DestinationPath llama.cpp -Force"

:: --- 5. Cleanup ---
echo [5/5] Cleaning up temporary files...
del llama_update.zip

echo.
echo ========================================
echo   Update Successful! (Version: %LATEST_TAG%)
echo ========================================
echo Please restart your services using LAUNCH_PROMPT_GENERATOR.bat
echo.
pause
