@echo off
setlocal
cd /d %~dp0

echo ========================================
echo   Llama.cpp Installer (CPU / Unified)
echo ========================================

echo [1/3] Fetching version info...
powershell -NoProfile -Command "$r = Invoke-RestMethod -Uri 'https://api.github.com/repos/ggml-org/llama.cpp/releases/latest'; $r.tag_name" > tag.txt
set /p LATEST_TAG=<tag.txt
del tag.txt

if "%LATEST_TAG%"=="" (
    echo [ERROR] Could not fetch version info.
    pause
    exit /b
)
echo Latest Version: %LATEST_TAG%

:: Unified CPU naming: win-cpu-x64.zip
set "FILENAME=llama-%LATEST_TAG%-bin-win-cpu-x64.zip"
set "BASE_URL=https://github.com/ggml-org/llama.cpp/releases/download/%LATEST_TAG%"

echo [2/3] Downloading %FILENAME%...
curl.exe -L -o llama_install_cpu.zip "%BASE_URL%/%FILENAME%"

if not exist llama_install_cpu.zip (
    echo [ERROR] Download failed. The file naming may have changed on GitHub.
    pause
    exit /b
)

echo [3/3] Extracting...
if not exist llama.cpp mkdir llama.cpp
powershell -NoProfile -Command "Expand-Archive -Path llama_install_cpu.zip -DestinationPath llama.cpp -Force"
del llama_install_cpu.zip

echo.
echo ========================================
echo   Installation Successful! (CPU Version)
echo ========================================
pause
