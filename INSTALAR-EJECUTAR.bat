@echo off
chcp 65001 >nul
title OCJ - Sistema de Gestion del Oratorio Centro Juvenil SCJ

echo ============================================
echo   OCJ - SISTEMA DE GESTION DEL ORATORIO
echo   Centro Juvenil Sagrado Corazon de Jesus
echo ============================================
echo.

REM Verificar si Docker esta instalado
where docker >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker no esta instalado o no esta en el PATH.
    echo Por favor instala Docker Desktop desde: https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)

REM Verificar si Node.js esta instalado (opcional, para desarrollo sin Docker)
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [AVISO] Node.js no esta instalado. Se usara solo Docker.
    echo Si quieres desarrollar localmente, instala Node.js desde: https://nodejs.org/
    echo.
)

echo [1/3] Verificando archivos de entorno...
if not exist "backend\.env" (
    echo Creando backend\.env desde .env.example...
    copy "backend\.env.example" "backend\.env" >nul
)
if not exist "frontend\.env" (
    echo VITE_API_URL=http://localhost:3001 > frontend\.env
)
echo     OK - Archivos de entorno listos
echo.

echo [2/3] Levantando servicios con Docker Compose...
echo Esto puede tardar unos minutos la primera vez...
docker-compose up --build -d
if %errorlevel% neq 0 (
    echo [ERROR] No se pudo levantar Docker Compose.
    echo Asegurate de que Docker Desktop este en ejecucion.
    echo.
    pause
    exit /b 1
)
echo     OK - Servicios levantados
echo.

echo [3/3] Verificando que los servicios esten listos...
timeout /t 10 >nul
docker-compose ps
echo.

echo ============================================
echo   ¡SISTEMA LISTO!
echo ============================================
echo.
echo  ACCESO AL SISTEMA:
echo    - Frontend:      http://localhost
echo    - API (Swagger): http://localhost:3001/api/docs
echo    - Base de datos: localhost:5432
echo.
echo  CREDENCIALES DE BASE DE DATOS:
echo    - Usuario: ocj_admin
echo    - Password: ocj_password_2026
echo    - Base de datos: ocj_db
echo.
echo  PASOS PRIMERA VEZ:
echo    1. Abre http://localhost en tu navegador
echo    2. Crea un usuario desde la API (Swagger) en POST /auth/register
echo       con rol "Secretaria"
echo    3. Inicia sesion con ese usuario
echo    4. Ya puedes subir documentos, registrar asistencia, etc.
echo.
echo  PARA DETENER: docker-compose down
echo  PARA VER LOGS: docker-compose logs -f
echo.
pause