# 🎉 ¡API de Predicción de Depresión Estudiantil Lista!

## ✅ Estado del Proyecto

Su API está **completamente funcional** y ejecutándose en:
- **URL Principal**: http://localhost:8000
- **Documentación Interactiva**: http://localhost:8000/docs
- **API Health**: http://localhost:8000/health

### 📊 Información del Modelo
- **Tipo**: Regresión Logística con selección RFE
- **Precisión**: 82.15% en datos de prueba
- **Características**: 8 variables más importantes seleccionadas
- **Estado**: ✅ Modelo entrenado y cargado correctamente

## 🚀 Cómo Usar la API

### 1. Documentación Interactiva
Visite http://localhost:8000/docs para:
- Ver todos los endpoints disponibles
- Probar la API directamente desde el navegador
- Ver ejemplos de entrada y salida
- Documentación automática completa

### 2. Endpoints Principales

#### GET `/health` - Verificar Estado
```bash
curl http://localhost:8000/health
```

#### POST `/predict` - Hacer Predicción
```bash
curl -X POST "http://localhost:8000/predict" \
  -H "Content-Type: application/json" \
  -d '{
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
  }'
```

### 3. Cliente de Prueba
Ejecute el cliente interactivo:
```bash
python test_api.py
```

## 📁 Archivos Creados

### Archivos Principales
- `api.py` - Servidor principal de la API
- `models_api.py` - Modelos de datos Pydantic
- `train_model.py` - Script de entrenamiento del modelo
- `test_api.py` - Cliente de prueba interactivo
- `start.bat` - Script de inicio automático

### Archivos de Configuración
- `requirements.txt` - Dependencias del proyecto
- `README.md` - Documentación completa
- `models/` - Carpeta con modelo entrenado

## 🎯 Características del Modelo

El modelo utiliza estas **8 características más importantes**:
1. **Academic Pressure** - Presión académica (1-5)
2. **Financial Stress** - Estrés financiero (1-5)
3. **Profession 'Digital Marketer'** - Si es marketer digital
4. **Profession Student** - Si es estudiante de tiempo completo
5. **Profession Teacher** - Si es profesor
6. **Dietary Habits Moderate** - Hábitos alimenticios moderados
7. **Dietary Habits Unhealthy** - Hábitos alimenticios poco saludables
8. **Have you ever had suicidal thoughts? Yes** - Pensamientos suicidas

## 🔄 Flujo de Trabajo

1. **Los datos se validan** automáticamente usando Pydantic
2. **Se escalan las características numéricas** usando StandardScaler
3. **El modelo hace la predicción** con Regresión Logística
4. **Se interpreta el resultado** con niveles de riesgo
5. **Se retorna una respuesta completa** con probabilidades y recomendaciones

## 📊 Interpretación de Resultados

### Niveles de Riesgo
- **Alto** (≥80%): Buscar ayuda profesional inmediatamente
- **Moderado-Alto** (60-79%): Consultar con profesional de salud mental
- **Moderado** (40-59%): Monitorear bienestar emocional
- **Bajo-Moderado** (20-39%): Cuidar bienestar emocional
- **Bajo** (≤19%): Mantener hábitos saludables

## 🛠️ Comandos Útiles

### Iniciar la API
```bash
python api.py
```

### Entrenar el modelo nuevamente
```bash
python train_model.py
```

### Probar la API
```bash
python test_api.py
```

### Inicio automático (Windows)
```bash
start.bat
```

## ⚠️ Consideraciones Importantes

1. **No es diagnóstico médico**: Solo para fines educativos y de investigación
2. **Buscar ayuda profesional**: Siempre consulte con profesionales de salud mental
3. **Privacidad**: Los datos no se almacenan en el servidor
4. **Precisión**: El modelo tiene 82.15% de precisión, no es infalible

## 🎉 ¡Su API está Lista!

La API está completamente funcional y lista para usar. Puede:
- ✅ Hacer predicciones en tiempo real
- ✅ Integrarla en aplicaciones web o móviles
- ✅ Usar la documentación interactiva
- ✅ Probarla con el cliente incluido
- ✅ Desplegarla en la nube si lo desea

### 📞 Próximos Pasos Sugeridos
1. Explore la documentación en http://localhost:8000/docs
2. Pruebe diferentes combinaciones de datos
3. Integre la API en su aplicación frontend
4. Considere el despliegue en la nube para acceso remoto

---
**¡Felicidades! Su modelo ahora es una API profesional lista para producción! 🚀**
