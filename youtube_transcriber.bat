```bat
@echo off
chcp 65001 >nul
title YAH Transcriber
color 0A

cd /d "C:\Users\Paola\youtube-transcriber"

echo ============================================
echo              YAH TRANSCRIBER
echo ============================================
echo.

if not exist ".venv\Scripts\python.exe" (
    echo ERRO: Ambiente Python nao encontrado.
    echo Verifique a pasta .venv.
    echo.
    pause
    exit /b 1
)

if not exist "transcriber.py" (
    echo ERRO: Arquivo transcriber.py nao encontrado.
    echo.
    pause
    exit /b 1
)

echo Iniciando o programa...
echo.

".venv\Scripts\python.exe" "transcriber.py"

if errorlevel 1 (
    echo.
    echo ERRO: O programa terminou com falha.
) else (
    echo.
    echo Programa encerrado.
)

echo.
pause
```