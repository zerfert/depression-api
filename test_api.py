import requests
import json

# URL base de la API
BASE_URL = "http://localhost:8000"

def test_health():
    """
    Prueba el endpoint de salud
    """
    print("🔍 Probando endpoint de salud...")
    response = requests.get(f"{BASE_URL}/health")
    print(f"Status: {response.status_code}")
    print(f"Respuesta: {response.json()}")
    print("-" * 50)

def test_prediction():
    """
    Prueba el endpoint de predicción con datos de ejemplo
    """
    print("🧠 Probando predicción con datos de ejemplo...")
    
    # Datos de ejemplo de un estudiante con riesgo moderado
    student_data = {
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
    
    response = requests.post(
        f"{BASE_URL}/predict",
        json=student_data,
        headers={"Content-Type": "application/json"}
    )
    
    print(f"Status: {response.status_code}")
    if response.status_code == 200:
        result = response.json()
        print(f"Predicción: {result['prediction']} ({'Depresión' if result['prediction'] == 1 else 'No Depresión'})")
        print(f"Probabilidad: {result['probability']:.4f}")
        print(f"Confianza: {result['confidence_percentage']:.2f}%")
        print(f"Nivel de riesgo: {result['risk_level']}")
        print(f"Mensaje: {result['message']}")
    else:
        print(f"Error: {response.text}")
    print("-" * 50)

def test_model_info():
    """
    Prueba el endpoint de información del modelo
    """
    print("ℹ️ Obteniendo información del modelo...")
    response = requests.get(f"{BASE_URL}/model-info")
    print(f"Status: {response.status_code}")
    if response.status_code == 200:
        info = response.json()
        print(f"Características seleccionadas: {len(info['selected_features'])}")
        print(f"Precisión en entrenamiento: {info['train_accuracy']:.4f}")
        print(f"Precisión en prueba: {info['test_accuracy']:.4f}")
        print(f"Características del modelo: {info['selected_features']}")
    else:
        print(f"Error: {response.text}")
    print("-" * 50)

def interactive_prediction():
    """
    Permite al usuario ingresar datos manualmente para hacer una predicción
    """
    print("🎯 Predicción Interactiva")
    print("Ingrese los datos del estudiante:")
    
    try:
        student_data = {
            "age": int(input("Edad (18-100): ")),
            "gender_male": int(input("Género masculino (1=Sí, 0=No): ")),
            "academic_pressure": float(input("Presión académica (1-5): ")),
            "work_pressure": float(input("Presión laboral (0-5): ")),
            "cgpa": float(input("CGPA/Promedio (0-10): ")),
            "study_satisfaction": float(input("Satisfacción con estudios (1-5): ")),
            "job_satisfaction": float(input("Satisfacción laboral (0-5): ")),
            "work_study_hours": float(input("Horas de estudio/trabajo por día (0-24): ")),
            "financial_stress": float(input("Estrés financiero (1-5): ")),
            "profession_student": int(input("¿Es estudiante de tiempo completo? (1=Sí, 0=No): ")),
            "profession_engineer": int(input("¿Es ingeniero? (1=Sí, 0=No): ")),
            "profession_teacher": int(input("¿Es profesor? (1=Sí, 0=No): ")),
            "profession_doctor": int(input("¿Es médico? (1=Sí, 0=No): ")),
            "profession_digital_marketer": int(input("¿Es marketer digital? (1=Sí, 0=No): ")),
            "degree_be": int(input("¿Tiene título BE? (1=Sí, 0=No): ")),
            "degree_bsc": int(input("¿Tiene título BSc? (1=Sí, 0=No): ")),
            "degree_mbbs": int(input("¿Tiene título MBBS? (1=Sí, 0=No): ")),
            "suicidal_thoughts": int(input("¿Ha tenido pensamientos suicidas? (1=Sí, 0=No): ")),
            "family_history_mental_illness": int(input("¿Antecedentes familiares de enfermedad mental? (1=Sí, 0=No): ")),
            "sleep_5_6_hours": int(input("¿Duerme 5-6 horas? (1=Sí, 0=No): ")),
            "sleep_7_8_hours": int(input("¿Duerme 7-8 horas? (1=Sí, 0=No): ")),
            "sleep_less_5_hours": int(input("¿Duerme menos de 5 horas? (1=Sí, 0=No): ")),
            "dietary_habits_unhealthy": int(input("¿Hábitos alimenticios poco saludables? (1=Sí, 0=No): ")),
            "dietary_habits_moderate": int(input("¿Hábitos alimenticios moderados? (1=Sí, 0=No): "))
        }
        
        response = requests.post(
            f"{BASE_URL}/predict",
            json=student_data,
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            result = response.json()
            print("\n" + "="*60)
            print("📊 RESULTADO DE LA PREDICCIÓN")
            print("="*60)
            print(f"Predicción: {result['prediction']} ({'⚠️ DEPRESIÓN' if result['prediction'] == 1 else '✅ NO DEPRESIÓN'})")
            print(f"Probabilidad: {result['probability']:.4f}")
            print(f"Confianza: {result['confidence_percentage']:.2f}%")
            print(f"Nivel de riesgo: {result['risk_level']}")
            print(f"Mensaje: {result['message']}")
            print("="*60)
        else:
            print(f"Error: {response.text}")
            
    except ValueError:
        print("Error: Por favor ingrese valores numéricos válidos.")
    except requests.exceptions.ConnectionError:
        print("Error: No se puede conectar a la API. ¿Está ejecutándose en localhost:8000?")

def main():
    """
    Función principal para ejecutar las pruebas
    """
    print("🚀 Cliente de Prueba para API de Predicción de Depresión")
    print("="*60)
    
    while True:
        print("\nOpciones disponibles:")
        print("1. Probar endpoint de salud")
        print("2. Probar predicción con datos de ejemplo")
        print("3. Obtener información del modelo")
        print("4. Predicción interactiva")
        print("5. Salir")
        
        choice = input("\nSeleccione una opción (1-5): ")
        
        try:
            if choice == "1":
                test_health()
            elif choice == "2":
                test_prediction()
            elif choice == "3":
                test_model_info()
            elif choice == "4":
                interactive_prediction()
            elif choice == "5":
                print("¡Hasta luego! 👋")
                break
            else:
                print("Opción no válida. Por favor seleccione 1-5.")
        except requests.exceptions.ConnectionError:
            print("❌ Error: No se puede conectar a la API.")
            print("Asegúrese de que la API esté ejecutándose en http://localhost:8000")
        except Exception as e:
            print(f"❌ Error inesperado: {e}")

if __name__ == "__main__":
    main()
