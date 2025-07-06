@echo off
echo ========================================
echo   API de Prediccion de Depresion Estudiantil
echo ========================================
echo.

echo [1/4] Verificando archivos necesarios...
if not exist "student_depression_dataset_processed.csv" (
    echo ❌ Error: No se encuentra el archivo student_depression_dataset_processed.csv
    echo Por favor, asegurese de que el archivo este en el directorio actual.
    pause
    exit /b 1
)
echo ✅ Archivos encontrados.

echo.
echo [2/4] Instalando dependencias...
pip install -r requirements.txt
if errorlevel 1 (
    echo ❌ Error al instalar dependencias.
    pause
    exit /b 1
)
echo ✅ Dependencias instaladas.

echo.
echo [3/4] Entrenando modelo...
python train_model.py
if errorlevel 1 (
    echo ❌ Error al entrenar el modelo.
    pause
    exit /b 1
)
echo ✅ Modelo entrenado y guardado.

echo.
echo [4/4] Iniciando API...
echo.
echo 🚀 La API se iniciara en: http://localhost:8000
echo 📖 Documentacion disponible en: http://localhost:8000/docs
echo 🛠️ Para probar la API, ejecute: python test_api.py
echo.
echo Presiona Ctrl+C para detener la API
echo.

python api.py
