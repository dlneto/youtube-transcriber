@echo off
setlocal
cd /d "%~dp0"

title Instalador do YouTube Transcriber

echo ============================================
echo      INSTALADOR DO YOUTUBE TRANSCRIBER
echo ============================================
echo.

set "PYTHON="

REM Verifica se o Python 3.13 ja esta disponivel pelo launcher
py -3.13 --version >nul 2>&1
if not errorlevel 1 set "PYTHON=py -3.13"

REM Se nao estiver instalado, tenta instalar usando o winget
if defined PYTHON goto PythonEncontrado

echo Python 3.13 nao encontrado. Verificando o winget...
where winget >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERRO: O winget nao foi encontrado neste computador.
    echo Instale o "Instalador de Aplicativo" pela Microsoft Store
    echo e execute este arquivo novamente.
    goto Erro
)

echo Instalando Python 3.13. Isso pode levar alguns minutos...
winget install --id Python.Python.3.13 --exact --scope user --silent --accept-package-agreements --accept-source-agreements
if errorlevel 1 (
    echo.
    echo O winget nao conseguiu instalar o Python 3.13.
    echo Tente executar este arquivo novamente ou instale o Python 3.13 manualmente.
    goto Erro
)

REM Procura o executavel instalado pelo winget
if exist "%LocalAppData%\Programs\Python\Python313\python.exe" (
    set "PYTHON=%LocalAppData%\Programs\Python\Python313\python.exe"
)

if defined PYTHON goto PythonEncontrado

REM Tenta novamente pelo launcher, caso ele esteja disponivel
py -3.13 --version >nul 2>&1
if not errorlevel 1 set "PYTHON=py -3.13"

if defined PYTHON goto PythonEncontrado

echo.
echo O Python foi instalado, mas nao foi possivel localiza-lo.
echo Feche esta janela, abra o instalador novamente e tente outra vez.
goto Erro

:PythonEncontrado
echo.
echo Python selecionado:
%PYTHON% --version
echo.

REM Recria o ambiente virtual se ele nao estiver usando Python 3.13
if exist ".venv\Scripts\python.exe" (
    ".venv\Scripts\python.exe" -c "import sys; raise SystemExit(0 if sys.version_info[:2] == (3,13) else 1)" >nul 2>&1
    if errorlevel 1 (
        echo Recriando o ambiente virtual para usar Python 3.13...
        rmdir /s /q ".venv"
        if errorlevel 1 (
            echo Nao foi possivel remover o ambiente virtual antigo.
            echo Feche programas que possam estar usando a pasta .venv e tente novamente.
            goto Erro
        )
    )
)

if not exist ".venv\Scripts\python.exe" (
    echo Criando o ambiente virtual...
    %PYTHON% -m venv .venv
    if errorlevel 1 goto Erro
)

echo.
echo Atualizando o pip...
call ".venv\Scripts\python.exe" -m pip install --upgrade pip
if errorlevel 1 goto Erro

echo.
echo Instalando as dependencias do projeto...
call ".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 goto Erro

echo.
echo ============================================
echo Instalacao concluida com sucesso!
echo Agora voce pode executar executar.bat.
echo ============================================
pause
exit /b 0

:Erro
echo.
echo A instalacao nao foi concluida.
pause
exit /b 1

