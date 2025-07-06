@echo off
echo ==========================================
echo  FRONTEND - Detector de Depresion Estudiantil
echo ==========================================
echo.

echo Verificando archivos necesarios...
if not exist "index.html" (
    echo ERROR: No se encontro index.html
    pause
    exit /b 1
)

if not exist "styles.css" (
    echo ERROR: No se encontro styles.css
    pause
    exit /b 1
)

if not exist "script.js" (
    echo ERROR: No se encontro script.js
    pause
    exit /b 1
)

echo Todos los archivos encontrados correctamente.
echo.

echo Opciones de despliegue:
echo.
echo 1. Abrir en navegador (archivo local)
echo 2. Iniciar servidor HTTP simple (Python)
echo 3. Mostrar instrucciones de despliegue
echo 4. Verificar API
echo 5. Salir
echo.

set /p choice="Selecciona una opcion (1-5): "

if "%choice%"=="1" goto open_browser
if "%choice%"=="2" goto start_server
if "%choice%"=="3" goto show_instructions
if "%choice%"=="4" goto check_api
if "%choice%"=="5" goto end
goto invalid_choice

:open_browser
echo.
echo Abriendo frontend en el navegador...
start index.html
echo Frontend abierto. Revisa tu navegador.
goto end

:start_server
echo.
echo Iniciando servidor HTTP en puerto 8000...
echo Abre tu navegador en: http://localhost:8000
echo.
echo Presiona Ctrl+C para detener el servidor
echo.
python -m http.server 8000
goto end

:show_instructions
echo.
echo ==========================================
echo  INSTRUCCIONES DE DESPLIEGUE
echo ==========================================
echo.
echo OPCION 1: Servidor Local con Python
echo   1. Abre terminal en esta carpeta
echo   2. Ejecuta: python -m http.server 8000
echo   3. Ve a: http://localhost:8000
echo.
echo OPCION 2: Live Server (VS Code)
echo   1. Instala extension "Live Server"
echo   2. Click derecho en index.html
echo   3. Selecciona "Open with Live Server"
echo.
echo OPCION 3: Netlify (Gratis)
echo   1. Ve a: https://netlify.com
echo   2. Arrastra la carpeta frontend
echo   3. Tu sitio estara en linea en minutos
echo.
echo OPCION 4: Vercel (Gratis)
echo   1. Instala: npm i -g vercel
echo   2. En esta carpeta: vercel
echo   3. Sigue las instrucciones
echo.
echo OPCION 5: GitHub Pages
echo   1. Sube archivos a repositorio GitHub
echo   2. Ve a Settings ^> Pages
echo   3. Selecciona branch y carpeta
echo.
pause
goto menu

:check_api
echo.
echo Verificando estado de la API...
echo URL: https://depression-api-student-ebbkctaba3e4ceej.eastus-01.azurewebsites.net
echo.

curl -s -o nul -w "%%{http_code}" https://depression-api-student-ebbkctaba3e4ceej.eastus-01.azurewebsites.net/health > temp_status.txt 2>nul
set /p status=<temp_status.txt
del temp_status.txt 2>nul

if "%status%"=="200" (
    echo [✓] API funcionando correctamente (Status: %status%^)
) else if "%status%"=="000" (
    echo [✗] No se puede conectar a la API
    echo     - Verifica tu conexion a internet
    echo     - La API podria estar detenida
    echo     - El frontend funcionara en modo demo
) else (
    echo [!] API responde con status: %status%
    echo     - Podria haber problemas temporales
    echo     - El frontend funcionara en modo demo
)

echo.
echo NOTA: Si la API no funciona, el frontend
echo       automaticamente usara el modo demostracion.
echo.
pause
goto menu

:invalid_choice
echo.
echo Opcion invalida. Intenta de nuevo.
echo.
goto menu

:menu
echo.
goto start

:end
echo.
echo Gracias por usar el Frontend del Detector de Depresion!
pause
