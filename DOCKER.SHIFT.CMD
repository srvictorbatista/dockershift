@echo off & @chcp 65001 >nul & COLOR 0A & setlocal enabledelayedexpansion&echo.
:: =========================================================================================
:: DOCKER.SHIFT.CMD - Script de Realocação de Imagens Docker
:: Descrição:
::   Este script automatiza o processo de migração da imagem WSL usada pelo Docker Desktop
::   para outra unidade/disco (ex: de C: para D:), criando uma junção NTFS no local original.
::   Isto é especialmente útil se você dispõe de pouco espaço em sua unicade C:/  
::
:: === CONFIGURAÇÕES ===
set "SOURCE_DIR=%USERPROFILE%\AppData\Local\Docker\wsl"
set "TARGET_DIR=D:\DockerData\DockerDesktopWSL"
set "TARGET_PARENT=D:\DockerData"
::
:: Etapas realizadas:
::   1. Encerra o processo do Docker Desktop.
::   2. Define a distribuição "docker-desktop" como padrão do WSL (opcional, se você utiliza outras imagens WSL).
::   3. Cria o diretório de destino, se necessário.
::   4. Move o conteúdo da pasta "wsl" original para o novo local usando robocopy.
::   5. Cria uma junção NTFS no caminho original apontando para o novo destino.
::
:: Observações:
::   - Este projeto se destina a versões do Windows 10 ou superiores.
::   - Requer execução com privilégios de administrador.
::   - A distribuição "docker-desktop" é gerenciada internamente pelo Docker Desktop.
:: 
:: Autor: Sr. Victor Batista - https://t.me/LevyMac
:: =========================================================================================



echo.		 [1/5] Encerrando Docker Desktop e WSL...
taskkill /F /IM "Docker Desktop.exe" >nul 2>&1
taskkill /F /IM "vmmem.exe" >nul 2>&1
taskkill /F /IM "vmcompute.exe" >nul 2>&1
net stop com.docker.service >nul 2>&1
wsl --shutdown
timeout /t 5 >nul

echo.		 [2/5] Definindo 'docker-desktop' como distribuição padrão do WSL...
wsl --set-default docker-desktop
if %ERRORLEVEL% NEQ 0 (
    echo ERRO ao definir a distribuição padrão do WSL.
    PAUSE & exit /b 1
)

echo.		 [3/5] Criando diretório de destino (se necessário)...
mkdir "%TARGET_PARENT%" >nul 2>&1

echo [4/5] Movendo os dados da pasta WSL inteira...
robocopy "%SOURCE_DIR%" "%TARGET_DIR%" /E /COPYALL /MOVE
if %ERRORLEVEL% GEQ 8 (
    echo ERRO ao mover arquivos com robocopy.
    PAUSE & exit /b 1
)

echo.		 [5/5] Criando junção NTFS do diretório 'wsl'...
rmdir "%SOURCE_DIR%" >nul 2>&1
if exist "%SOURCE_DIR%" (
    echo Diretório ainda em uso. Renomeando...
    ren "%SOURCE_DIR%" "wsl_backup_%RANDOM%" >nul 2>&1
)

mklink /J "%SOURCE_DIR%" "%TARGET_DIR%"
if %ERRORLEVEL% NEQ 0 (
    echo ERRO ao criar a junção.
    PAUSE & exit /b 1
)

CLS&echo.&echo.&echo.
echo.		 MAPEAMENTO CONCLUÍDO COM SUCESSO!
echo.
echo.		 Fonte original:  %SOURCE_DIR%
echo.		 Novo destino:    %TARGET_DIR%
echo.		 Distribuição padrão definida: docker-desktop

PAUSE >nul
