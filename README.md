# 🧠 API de Predicción de Depresión Estudiantil

Esta API utiliza machine learning para predecir la probabilidad de depresión en estudiantes basándose en diversos factores académicos, personales y de bienestar.

## 📋 Características

- **Modelo**: Regresión Logística con selección de características RFE
- **API**: FastAPI con documentación automática
- **Datos**: Basado en dataset de depresión estudiantil
- **Predicciones**: Probabilidad y nivel de riesgo
- **Interfaz**: Documentación interactiva con Swagger UI

## 🚀 Instalación y Configuración

### 1. Instalar Dependencias

```bash
pip install -r requirements.txt
```

### 2. Entrenar el Modelo

Antes de usar la API, debe entrenar y guardar el modelo:

```bash
python train_model.py
```

Este script:
- Carga y procesa los datos del archivo `student_depression_dataset_processed.csv`
- Selecciona las 8 características más importantes
- Entrena un modelo de Regresión Logística
- Guarda el modelo, escalador y metadatos en la carpeta `models/`

### 3. Ejecutar la API

```bash
python api.py
```

O usando uvicorn directamente:

```bash
uvicorn api:app --host 0.0.0.0 --port 8000 --reload
```

La API estará disponible en: `http://localhost:8000`

## 📖 Documentación

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Página Principal**: http://localhost:8000

## 🛠️ Endpoints

### GET `/health`
Verifica el estado de la API y si el modelo está cargado.

**Respuesta:**
```json
{
  "status": "healthy",
  "model_loaded": true,
  "version": "1.0.0",
  "message": "API funcionando correctamente..."
}
```

### POST `/predict`
Realiza una predicción de depresión basada en los datos del estudiante.

**Entrada:**
```json
{
  "age": 22,
  "gender_male": 1,
  "academic_pressure": 4.0,
  "work_pressure": 2.0,
  "cgpa": 7.5,
  "study_satisfaction": 2.0,
  "job_satisfaction": 3.0,
  "work_study_hours": 8.0,
  "financial_stress": 4.0,
  "profession_student": 1,
  "profession_engineer": 0,
  "profession_teacher": 0,
  "profession_doctor": 0,
  "profession_digital_marketer": 0,
  "degree_be": 1,
  "degree_bsc": 0,
  "degree_mbbs": 0,
  "suicidal_thoughts": 0,
  "family_history_mental_illness": 1,
  "sleep_5_6_hours": 1,
  "sleep_7_8_hours": 0,
  "sleep_less_5_hours": 0,
  "dietary_habits_unhealthy": 1,
  "dietary_habits_moderate": 0
}
```

**Respuesta:**
```json
{
  "prediction": 1,
  "probability": 0.7234,
  "confidence_percentage": 72.34,
  "risk_level": "Moderado-Alto",
  "message": "El modelo indica un riesgo MODERADO-ALTO..."
}
```

### GET `/model-info`
Obtiene información sobre el modelo entrenado.

## 🧪 Pruebas

### Ejecutar Cliente de Prueba

```bash
python test_api.py
```

Este script incluye:
- Pruebas automatizadas de todos los endpoints
- Predicción interactiva
- Validación del estado del modelo

### Pruebas con cURL

```bash
# Verificar salud
curl -X GET "http://localhost:8000/health"

# Hacer predicción
curl -X POST "http://localhost:8000/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "age": 22,
    "gender_male": 1,
    "academic_pressure": 4.0,
    "cgpa": 7.5,
    "financial_stress": 4.0,
    "suicidal_thoughts": 0,
    "family_history_mental_illness": 1,
    "sleep_5_6_hours": 1,
    "dietary_habits_unhealthy": 1
  }'
```

## 📊 Parámetros del Modelo

### Campos Requeridos

| Campo | Descripción | Rango |
|-------|-------------|-------|
| `age` | Edad del estudiante | 18-100 |
| `gender_male` | Género masculino | 0-1 |
| `academic_pressure` | Presión académica | 1-5 |
| `cgpa` | Promedio de calificaciones | 0-10 |
| `study_satisfaction` | Satisfacción con estudios | 1-5 |
| `work_study_hours` | Horas de estudio/trabajo | 0-24 |
| `financial_stress` | Estrés financiero | 1-5 |
| `suicidal_thoughts` | Pensamientos suicidas | 0-1 |
| `family_history_mental_illness` | Antecedentes familiares | 0-1 |

### Campos de Categoría (solo uno puede ser 1)

**Profesión:**
- `profession_student`, `profession_engineer`, `profession_teacher`, `profession_doctor`, `profession_digital_marketer`

**Título:**
- `degree_be`, `degree_bsc`, `degree_mbbs`

**Sueño:**
- `sleep_5_6_hours`, `sleep_7_8_hours`, `sleep_less_5_hours`

**Alimentación:**
- `dietary_habits_unhealthy`, `dietary_habits_moderate`

## 🔍 Interpretación de Resultados

### Niveles de Riesgo

- **Bajo**: Probabilidad ≤ 0.2 (sin depresión)
- **Bajo-Moderado**: 0.2 < Probabilidad ≤ 0.4 (sin depresión)
- **Moderado**: 0.4 < Probabilidad < 0.6
- **Moderado-Alto**: 0.6 ≤ Probabilidad < 0.8 (con depresión)
- **Alto**: Probabilidad ≥ 0.8 (con depresión)

### Recomendaciones

- **Riesgo Alto**: Buscar ayuda profesional inmediatamente
- **Riesgo Moderado-Alto**: Consultar con profesional de salud mental
- **Riesgo Moderado**: Monitorear bienestar emocional
- **Riesgo Bajo**: Mantener hábitos saludables

## ⚠️ Consideraciones Importantes

1. **No es un diagnóstico médico**: Esta API es solo para fines educativos y de investigación
2. **Consulte profesionales**: Siempre busque ayuda médica profesional para problemas de salud mental
3. **Privacidad**: Los datos no se almacenan en el servidor
4. **Precisión**: El modelo tiene una precisión aproximada del 85% en el conjunto de prueba

## 📁 Estructura del Proyecto

```
Final/
├── api.py                                    # API principal
├── models_api.py                            # Modelos de datos Pydantic
├── train_model.py                           # Script de entrenamiento
├── test_api.py                             # Cliente de prueba
├── requirements.txt                         # Dependencias
├── README.md                               # Este archivo
├── Proyecto Final Analisis.ipynb          # Notebook original
├── student_depression_dataset.csv          # Dataset original
├── student_depression_dataset_processed.csv # Dataset procesado
└── models/                                 # Carpeta de modelos (generada)
    ├── depression_model.pkl                # Modelo entrenado
    ├── scaler.pkl                         # Escalador
    └── model_metadata.pkl                 # Metadatos
```

## 🚀 Despliegue

### Docker (Opcional)

Crear `Dockerfile`:

```dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

RUN python train_model.py

EXPOSE 8000
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Cloud Deployment

La API puede desplegarse en:
- **Heroku**: Con buildpack de Python
- **AWS EC2**: Con configuración básica
- **Google Cloud Run**: Con contenedor Docker
- **Azure Container Instances**: Con Docker

## 🤝 Contribuciones

1. Fork el proyecto
2. Crea una rama para tu feature
3. Haz commit de tus cambios
4. Push a la rama
5. Abre un Pull Request

## 📝 Licencia

Este proyecto es para fines educativos y de investigación.

## 🆘 Soporte

Si necesitas ayuda:
1. Revisa la documentación en `/docs`
2. Ejecuta `python test_api.py` para diagnósticos
3. Verifica que el modelo esté entrenado con `python train_model.py`

---

**⚠️ Aviso Legal**: Esta herramienta es solo para fines educativos. No sustituye el diagnóstico médico profesional. Si tienes problemas de salud mental, busca ayuda profesional inmediatamente.
