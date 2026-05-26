@echo off
setlocal
cd /d %~dp0

echo ========================================
echo   Llama.cpp Installer (CUDA + Auto-DLL)
echo ========================================

set "CUDA_VERSION=12.4"

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

set "MAIN_ZIP=llama-%LATEST_TAG%-bin-win-cuda-%CUDA_VERSION%-x64.zip"
set "DLL_ZIP=cudart-llama-bin-win-cuda-%CUDA_VERSION%-x64.zip"
set "BASE_URL=https://github.com/ggml-org/llama.cpp/releases/download/%LATEST_TAG%"

echo [2/3] Downloading files...
:: Main Binary
curl.exe -L -o llama_main.zip "%BASE_URL%/%MAIN_ZIP%"
:: CUDA DLLs
curl.exe -L -o llama_dlls.zip "%BASE_URL%/%DLL_ZIP%"

echo [3/3] Extracting files...
if not exist llama.cpp mkdir llama.cpp

:: Extract Main
if exist llama_main.zip (
    powershell -NoProfile -Command "Expand-Archive -Path llama_main.zip -DestinationPath llama.cpp -Force"
    del llama_main.zip
)

:: Extract DLLs (Only if download was successful)
if exist llama_dlls.zip (
    powershell -NoProfile -Command "if ((Get-Item llama_dlls.zip).Length -gt 1000) { Expand-Archive -Path llama_dlls.zip -DestinationPath llama.cpp -Force }"
    del llama_dlls.zip
)

echo.
echo ========================================
echo   Installation Successful!
echo ========================================
pause
