@echo off
setlocal
cd /d "%~dp0"

echo ============================================
echo       INSTALADOR DO YOUTUBE TRANSCRIBER
echo ============================================
echo.

where py >nul 2>&1
if not errorlevel 1 (
    echo Criando ambiente virtual com o Python...
    py -3 -m venv .venv
) else (
    where python >nul 2>&1
    if errorlevel 1 (
        echo ERRO: Python nao foi encontrado.
        echo Instale o Python e marque a opcao "Add Python to PATH".
        goto erro
    )
    echo Criando ambiente virtual com o Python...
    python -m venv .venv
)

if errorlevel 1 (
    echo ERRO: nao foi possivel criar o ambiente virtual.
    goto erro
)

echo.
echo Atualizando o pip...
".venv\Scripts\python.exe" -m pip install --upgrade pip
if errorlevel 1 goto erro

echo.
echo Instalando as dependencias do projeto...
if not exist "requirements.txt" (
    echo ERRO: requirements.txt nao foi encontrado nesta pasta.
    goto erro
)
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 goto erro

if not exist ".env" (
    echo.
    echo Criando arquivo .env de exemplo...
    > ".env" echo GROQ_API_KEY=COLE_SUA_CHAVE_GROQ_AQUI
)

echo.
where ffmpeg >nul 2>&1
if errorlevel 1 (
    echo AVISO: FFmpeg nao foi encontrado no PATH.
    echo O transcriber precisa do FFmpeg para cortar o audio.
    echo Instale o FFmpeg e abra uma nova janela do Prompt de Comando.
) else (
    echo FFmpeg encontrado.
)

echo.
echo ============================================
echo Instalacao das dependencias concluida!
echo ============================================
echo.
echo Antes de executar o programa:
echo 1. Edite o arquivo .env e coloque sua chave GROQ_API_KEY.
echo 2. Confira se o FFmpeg esta instalado.
echo 3. Execute o transcriber usando o Python da pasta .venv.
echo.
pause
exit /b 0

:erro
echo.
echo A instalacao nao foi concluida. Verifique a mensagem acima.
pause
exit /b 1
