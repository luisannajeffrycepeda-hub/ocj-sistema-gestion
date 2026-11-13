@echo off
chcp 65001 >nul
echo Deteniendo servicios de OCJ...
docker-compose down
echo.
echo Servicios detenidos correctamente.
pause