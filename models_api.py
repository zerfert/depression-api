from pydantic import BaseModel, Field
from typing import Optional

class StudentData(BaseModel):
    """
    Modelo de datos para recibir información de un estudiante
    """
    # Datos demográficos
    age: int = Field(..., ge=18, le=100, description="Edad del estudiante")
    gender_male: int = Field(..., ge=0, le=1, description="1 si es masculino, 0 si es femenino")
    
    # Datos académicos y laborales
    academic_pressure: float = Field(..., ge=1, le=5, description="Nivel de presión académica (1-5)")
    work_pressure: float = Field(0, ge=0, le=5, description="Nivel de presión laboral (0-5)")
    cgpa: float = Field(..., ge=0, le=10, description="Promedio de calificaciones")
    study_satisfaction: float = Field(..., ge=1, le=5, description="Satisfacción con estudios (1-5)")
    job_satisfaction: float = Field(0, ge=0, le=5, description="Satisfacción laboral (0-5)")
    work_study_hours: float = Field(..., ge=0, le=24, description="Horas de estudio/trabajo por día")
    
    # Datos financieros y de bienestar
    financial_stress: float = Field(..., ge=1, le=5, description="Nivel de estrés financiero (1-5)")
    
    # Profesión (solo una puede ser 1, el resto deben ser 0)
    profession_student: int = Field(0, ge=0, le=1, description="1 si es estudiante de tiempo completo")
    profession_engineer: int = Field(0, ge=0, le=1, description="1 si es ingeniero")
    profession_teacher: int = Field(0, ge=0, le=1, description="1 si es profesor")
    profession_doctor: int = Field(0, ge=0, le=1, description="1 si es médico")
    profession_digital_marketer: int = Field(0, ge=0, le=1, description="1 si es marketer digital")
    
    # Título académico (solo uno puede ser 1, el resto deben ser 0)
    degree_be: int = Field(0, ge=0, le=1, description="1 si tiene título BE")
    degree_bsc: int = Field(0, ge=0, le=1, description="1 si tiene título BSc")
    degree_mbbs: int = Field(0, ge=0, le=1, description="1 si tiene título MBBS")
    
    # Salud mental y antecedentes
    suicidal_thoughts: int = Field(..., ge=0, le=1, description="1 si ha tenido pensamientos suicidas")
    family_history_mental_illness: int = Field(..., ge=0, le=1, description="1 si tiene antecedentes familiares")
    
    # Hábitos de sueño (solo uno puede ser 1, el resto deben ser 0)
    sleep_5_6_hours: int = Field(0, ge=0, le=1, description="1 si duerme 5-6 horas")
    sleep_7_8_hours: int = Field(0, ge=0, le=1, description="1 si duerme 7-8 horas")
    sleep_less_5_hours: int = Field(0, ge=0, le=1, description="1 si duerme menos de 5 horas")
    
    # Hábitos alimenticios (solo uno puede ser 1, el resto deben ser 0)
    dietary_habits_unhealthy: int = Field(0, ge=0, le=1, description="1 si tiene hábitos alimenticios poco saludables")
    dietary_habits_moderate: int = Field(0, ge=0, le=1, description="1 si tiene hábitos alimenticios moderados")

class PredictionResponse(BaseModel):
    """
    Modelo de respuesta para las predicciones
    """
    prediction: int = Field(..., description="Predicción: 0 = No depresión, 1 = Depresión")
    probability: float = Field(..., description="Probabilidad de depresión (0-1)")
    confidence_percentage: float = Field(..., description="Porcentaje de confianza de la predicción")
    risk_level: str = Field(..., description="Nivel de riesgo: Bajo, Moderado, Alto")
    message: str = Field(..., description="Mensaje interpretativo del resultado")

class HealthStatus(BaseModel):
    """
    Modelo para verificar el estado de la API
    """
    status: str
    model_loaded: bool
    version: str = "1.0.0"
    message: str
