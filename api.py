from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse
import pandas as pd
import numpy as np
import joblib
import os
from models_api import StudentData, PredictionResponse, HealthStatus

# Crear la aplicación FastAPI
app = FastAPI(
    title="API de Predicción de Depresión Estudiantil",
    description="API para predecir la probabilidad de depresión en estudiantes usando machine learning",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Variables globales para el modelo
model = None
scaler = None
model_metadata = None

def load_model():
    """
    Carga el modelo entrenado y sus metadatos
    """
    global model, scaler, model_metadata
    
    try:
        if not os.path.exists('models/depression_model.pkl'):
            raise FileNotFoundError("Modelo no encontrado. Ejecute train_model.py primero.")
        
        model = joblib.load('models/depression_model.pkl')
        scaler = joblib.load('models/scaler.pkl')
        model_metadata = joblib.load('models/model_metadata.pkl')
        
        print("Modelo cargado exitosamente!")
        print(f"Características seleccionadas: {model_metadata['selected_features']}")
        
    except Exception as e:
        print(f"Error al cargar el modelo: {e}")
        raise e

def prepare_input_data(student_data: StudentData) -> pd.DataFrame:
    """
    Convierte los datos del estudiante al formato esperado por el modelo
    """
    # Mapear los datos de entrada a las características del modelo
    feature_mapping = {
        'Age': student_data.age,
        'Academic Pressure': student_data.academic_pressure,
        'Work Pressure': student_data.work_pressure,
        'CGPA': student_data.cgpa,
        'Study Satisfaction': student_data.study_satisfaction,
        'Job Satisfaction': student_data.job_satisfaction,
        'Work/Study Hours': student_data.work_study_hours,
        'Financial Stress': student_data.financial_stress,
        'Gender_Male': student_data.gender_male,
        'Profession_Student': student_data.profession_student,
        'Profession_Engineer': student_data.profession_engineer,
        'Profession_Teacher': student_data.profession_teacher,
        'Profession_Doctor': student_data.profession_doctor,
        "Profession_'Digital Marketer'": student_data.profession_digital_marketer,
        'Degree_BE': student_data.degree_be,
        'Degree_BSc': student_data.degree_bsc,
        'Degree_MBBS': student_data.degree_mbbs,
        'Have you ever had suicidal thoughts ?_Yes': student_data.suicidal_thoughts,
        'Family History of Mental Illness_Yes': student_data.family_history_mental_illness,
        "Sleep Duration_'5-6 hours'": student_data.sleep_5_6_hours,
        "Sleep Duration_'7-8 hours'": student_data.sleep_7_8_hours,
        "Sleep Duration_'<5 hours'": student_data.sleep_less_5_hours,
        'Dietary Habits_Unhealthy': student_data.dietary_habits_unhealthy,
        'Dietary Habits_Moderate': student_data.dietary_habits_moderate,
    }
    
    # Crear DataFrame con solo las características seleccionadas por el modelo
    selected_data = {}
    for feature in model_metadata['selected_features']:
        if feature in feature_mapping:
            selected_data[feature] = [feature_mapping[feature]]
        else:
            # Si la característica no está en el mapeo, asumir valor 0
            selected_data[feature] = [0]
    
    input_df = pd.DataFrame(selected_data)
    
    # Escalar características numéricas
    input_df_scaled = input_df.copy()
    numeric_features = model_metadata['numeric_features']
    
    if numeric_features:
        numeric_features_in_input = [col for col in numeric_features if col in input_df_scaled.columns]
        if numeric_features_in_input:
            input_df_scaled[numeric_features_in_input] = scaler.transform(input_df_scaled[numeric_features_in_input])
    
    return input_df_scaled

def interpret_prediction(prediction: int, probability: float) -> tuple:
    """
    Interpreta la predicción y devuelve el nivel de riesgo y mensaje
    """
    if prediction == 1:
        if probability >= 0.8:
            risk_level = "Alto"
            message = "El modelo indica un ALTO riesgo de depresión. Se recomienda buscar ayuda profesional inmediatamente."
        elif probability >= 0.6:
            risk_level = "Moderado-Alto"
            message = "El modelo indica un riesgo MODERADO-ALTO de depresión. Se recomienda consultar con un profesional de la salud mental."
        else:
            risk_level = "Moderado"
            message = "El modelo indica un riesgo MODERADO de depresión. Se sugiere monitorear el bienestar emocional."
    else:
        if probability <= 0.2:
            risk_level = "Bajo"
            message = "El modelo indica un riesgo BAJO de depresión. Mantener hábitos saludables."
        elif probability <= 0.4:
            risk_level = "Bajo-Moderado"
            message = "El modelo indica un riesgo BAJO-MODERADO de depresión. Cuidar el bienestar emocional."
        else:
            risk_level = "Moderado"
            message = "El modelo indica un riesgo MODERADO de depresión. Se recomienda estar atento a los síntomas."
    
    return risk_level, message

# Cargar el modelo al iniciar la aplicación
@app.on_event("startup")
async def startup_event():
    """
    Evento que se ejecuta al iniciar la aplicación
    """
    try:
        load_model()
    except Exception as e:
        print(f"Error al cargar el modelo en el startup: {e}")

@app.get("/", response_class=HTMLResponse)
async def root():
    """
    Página principal con información de la API
    """
    html_content = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>API de Predicción de Depresión Estudiantil</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
            .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
            h1 { color: #2c3e50; text-align: center; }
            h2 { color: #34495e; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
            .endpoint { background: #ecf0f1; padding: 15px; margin: 10px 0; border-radius: 5px; }
            .method { color: white; padding: 5px 10px; border-radius: 3px; font-weight: bold; }
            .get { background-color: #27ae60; }
            .post { background-color: #e74c3c; }
            code { background: #f8f9fa; padding: 2px 6px; border-radius: 3px; font-family: 'Courier New', monospace; }
            .warning { background: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 5px; margin: 20px 0; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🧠 API de Predicción de Depresión Estudiantil</h1>
            
            <div class="warning">
                <strong>⚠️ Aviso Importante:</strong> Esta API es solo para fines educativos y de investigación. 
                No sustituye el diagnóstico médico profesional.
            </div>
            
            <h2>📚 Endpoints Disponibles</h2>
            
            <div class="endpoint">
                <span class="method get">GET</span> <code>/health</code>
                <p>Verifica el estado de la API y si el modelo está cargado correctamente.</p>
            </div>
            
            <div class="endpoint">
                <span class="method post">POST</span> <code>/predict</code>
                <p>Realiza una predicción de depresión basada en los datos del estudiante.</p>
            </div>
            
            <div class="endpoint">
                <span class="method get">GET</span> <code>/docs</code>
                <p>Documentación interactiva de la API (Swagger UI).</p>
            </div>
            
            <div class="endpoint">
                <span class="method get">GET</span> <code>/redoc</code>
                <p>Documentación alternativa de la API (ReDoc).</p>
            </div>
            
            <h2>🔬 Acerca del Modelo</h2>
            <p>Este modelo utiliza <strong>Regresión Logística</strong> con selección de características mediante <strong>RFE (Recursive Feature Elimination)</strong> para predecir la probabilidad de depresión en estudiantes.</p>
            
            <p>El modelo considera factores como:</p>
            <ul>
                <li>Datos demográficos (edad, género)</li>
                <li>Presión académica y laboral</li>
                <li>Satisfacción con estudios y trabajo</li>
                <li>Estrés financiero</li>
                <li>Antecedentes de salud mental</li>
                <li>Hábitos de sueño y alimentación</li>
            </ul>
            
            <h2>🚀 Cómo usar la API</h2>
            <p>1. Visita <a href="/docs" target="_blank">/docs</a> para la documentación interactiva</p>
            <p>2. Usa el endpoint <code>/predict</code> enviando los datos del estudiante en formato JSON</p>
            <p>3. Recibe la predicción con probabilidad y nivel de riesgo</p>
            
            <h2>💡 Ejemplo de Uso</h2>
            <p>Puedes probar la API directamente desde <a href="/docs" target="_blank">/docs</a> o usar herramientas como curl, Postman, o cualquier cliente HTTP.</p>
        </div>
    </body>
    </html>
    """
    return HTMLResponse(content=html_content, status_code=200)

@app.get("/health", response_model=HealthStatus)
async def health_check():
    """
    Endpoint para verificar el estado de la API
    """
    model_loaded = model is not None and scaler is not None and model_metadata is not None
    
    if model_loaded:
        return HealthStatus(
            status="healthy",
            model_loaded=True,
            message="API funcionando correctamente. Modelo cargado y listo para predicciones."
        )
    else:
        return HealthStatus(
            status="unhealthy",
            model_loaded=False,
            message="Modelo no cargado. Ejecute train_model.py para entrenar y guardar el modelo."
        )

@app.post("/predict", response_model=PredictionResponse)
async def predict_depression(student_data: StudentData):
    """
    Endpoint principal para realizar predicciones de depresión
    """
    # Verificar que el modelo esté cargado
    if model is None or scaler is None or model_metadata is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Modelo no disponible. Contacte al administrador del sistema."
        )
    
    try:
        # Preparar los datos de entrada
        input_data = prepare_input_data(student_data)
        
        # Realizar predicción
        prediction = model.predict(input_data)[0]
        prediction_proba = model.predict_proba(input_data)[0]
        probability_depression = prediction_proba[1]
        
        # Interpretar resultados
        risk_level, message = interpret_prediction(prediction, probability_depression)
        
        return PredictionResponse(
            prediction=int(prediction),
            probability=float(probability_depression),
            confidence_percentage=float(probability_depression * 100),
            risk_level=risk_level,
            message=message
        )
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error al procesar la predicción: {str(e)}"
        )

@app.get("/model-info")
async def get_model_info():
    """
    Endpoint para obtener información del modelo
    """
    if model_metadata is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Modelo no disponible."
        )
    
    return {
        "selected_features": model_metadata['selected_features'],
        "numeric_features": model_metadata['numeric_features'],
        "train_accuracy": model_metadata['train_accuracy'],
        "test_accuracy": model_metadata['test_accuracy'],
        "total_features_in_dataset": len(model_metadata['feature_names']),
        "selected_features_count": len(model_metadata['selected_features'])
    }

if __name__ == "__main__":
    import uvicorn
    print("🚀 Iniciando API de Predicción de Depresión Estudiantil...")
    print("📖 Documentación disponible en: http://localhost:8000/docs")
    print("🏠 Página principal: http://localhost:8000")
    uvicorn.run(app, host="0.0.0.0", port=8000)
