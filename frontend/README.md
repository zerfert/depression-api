# Detector de Depresión Estudiantil - Frontend

[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-deployed-brightgreen)](https://tu-usuario.github.io/depression-detector-frontend)
[![HTML5](https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white)](https://developer.mozilla.org/en-US/docs/Web/HTML)
[![CSS3](https://img.shields.io/badge/CSS3-1572B6?logo=css3&logoColor=white)](https://developer.mozilla.org/en-US/docs/Web/CSS)
[![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black)](https://developer.mozilla.org/en-US/docs/Web/JavaScript)

## 🧠 Descripción

Frontend web moderno para el sistema de detección de depresión estudiantil basado en machine learning. Proporciona una interfaz intuitiva para evaluar el riesgo de depresión en estudiantes universitarios.

## 🌐 Demo en Vivo

**[Ver Demo](https://tu-usuario.github.io/depression-detector-frontend)**

> **Nota**: Si la API está inactiva, el frontend funcionará en modo demostración con algoritmo de evaluación local.

## Características

### 🎨 Diseño Moderno
- Interfaz responsiva que funciona en desktop, tablet y móvil
- Diseño Material Design con gradientes y animaciones suaves
- Iconos de Font Awesome para mejor experiencia visual
- Tema oscuro/claro adaptable al sistema

### 📋 Formulario Completo
- **Información Personal**: Edad, género
- **Información Académica**: Presión académica, CGPA, satisfacción con estudios
- **Información Laboral**: Profesión, presión laboral
- **Bienestar y Estilo de Vida**: Duración del sueño, hábitos alimentarios, pensamientos suicidas, historial familiar
- **Situación Financiera**: Nivel de estrés financiero

### 🔧 Funcionalidades Avanzadas
- Validación en tiempo real de formularios
- Sliders interactivos para escalas numéricas
- Sistema de carga y feedback visual
- Modal de resultados con animaciones
- Modo demostración cuando la API no está disponible
- Descarga de reportes en formato texto
- Shortcuts de teclado (Escape para cerrar, Ctrl+Enter para enviar)

### 🚀 Tecnologías Utilizadas
- **HTML5**: Estructura semántica
- **CSS3**: Estilos avanzados con flexbox, grid, y animaciones
- **JavaScript ES6+**: Lógica de aplicación con async/await
- **Font Awesome**: Iconografía
- **API REST**: Integración con backend

## Estructura de Archivos

```
frontend/
├── index.html          # Página principal
├── styles.css          # Estilos CSS
├── script.js          # Lógica JavaScript
└── README.md          # Documentación
```

## Configuración

### 1. API Configuration
El frontend está configurado para conectarse a:
```
https://depression-api-student-ebbkctaba3e4ceej.eastus-01.azurewebsites.net
```

Para cambiar la URL de la API, modifica la constante `API_CONFIG` en `script.js`:

```javascript
const API_CONFIG = {
    baseUrl: 'TU_URL_API_AQUÍ',
    endpoints: {
        predict: '/predict',
        health: '/health'
    }
};
```

### 2. Despliegue Local

1. **Servidor Local Simple**:
   ```bash
   # Python 3
   python -m http.server 8000
   
   # Python 2
   python -m SimpleHTTPServer 8000
   
   # Node.js (con npx)
   npx serve .
   ```

2. **Live Server (VS Code)**:
   - Instala la extensión "Live Server"
   - Click derecho en `index.html` → "Open with Live Server"

3. **Navegador Directo**:
   - Abre `index.html` directamente en el navegador (funcionalidad limitada debido a CORS)

### 3. Despliegue en Producción

#### Netlify
1. Arrastra la carpeta `frontend/` a [netlify.com](https://netlify.com)
2. O conecta tu repositorio Git

#### Vercel
1. Instala Vercel CLI: `npm i -g vercel`
2. En la carpeta frontend: `vercel`

#### GitHub Pages
1. Sube los archivos a un repositorio de GitHub
2. Ve a Settings → Pages
3. Selecciona la branch y carpeta

## Uso

### Flujo de Usuario

1. **Completar Formulario**:
   - Llena todos los campos obligatorios
   - Usa los sliders para escalas de 1-5
   - Selecciona opciones de radio para preguntas binarias

2. **Validación**:
   - El formulario valida en tiempo real
   - Muestra errores específicos por campo
   - Previene envío con datos inválidos

3. **Envío y Procesamiento**:
   - Muestra spinner de carga
   - Intenta conectar con la API
   - Si falla, activa modo demostración

4. **Resultados**:
   - Modal con resultado visual
   - Probabilidad de depresión
   - Recomendaciones personalizadas
   - Opción de descargar reporte

### Características del Formulario

#### Campos de Entrada
- **Age**: Número (16-30)
- **Gender**: Select (Male/Female)
- **Academic Pressure**: Slider (1-5)
- **CGPA**: Número decimal (0-10)
- **Study Satisfaction**: Slider (1-5)
- **Profession**: Select múltiple
- **Work Pressure**: Slider (1-5)
- **Sleep Duration**: Número decimal (4-12)
- **Dietary Habits**: Select (Healthy/Moderate/Unhealthy)
- **Suicidal Thoughts**: Radio (Yes/No)
- **Family History**: Radio (Yes/No)
- **Financial Stress**: Slider (1-5)

#### Validaciones
- Campos obligatorios marcados
- Rangos numéricos validados
- Formato de datos verificado
- Feedback visual inmediato

## API Integration

### Endpoints Esperados

#### POST /predict
```json
{
  "Age": 20,
  "Gender": "Male",
  "Academic Pressure": 4,
  "CGPA": 7.5,
  "Study Satisfaction": 3,
  "Profession": "Student",
  "Work Pressure": 2,
  "Sleep Duration": 7.0,
  "Dietary Habits": "Moderate",
  "Suicidal thoughts": "No",
  "Family History of Mental Illness": "No",
  "Financial Stress": 3
}
```

**Respuesta Esperada**:
```json
{
  "prediction": 0,
  "probability": 0.25,
  "confidence": 0.85
}
```

#### GET /health
**Respuesta Esperada**:
```json
{
  "status": "healthy",
  "timestamp": "2025-01-07T10:30:00Z"
}
```

### Modo Demostración

Cuando la API no está disponible, el frontend calcula un resultado de demostración basado en:
- Factores de riesgo conocidos
- Algoritmo de puntuación simple
- Pesos asignados a diferentes variables

## Personalización

### Cambiar Colores
Modifica las variables CSS en `styles.css`:
```css
:root {
  --primary-color: #667eea;
  --secondary-color: #764ba2;
  --success-color: #27ae60;
  --danger-color: #e74c3c;
}
```

### Agregar Campos
1. Añade el HTML en `index.html`
2. Actualiza `collectFormData()` en `script.js`
3. Modifica la validación si es necesario

### Cambiar Recomendaciones
Edita la función `getRecommendations()` en `script.js`

## Accesibilidad

- Etiquetas semánticas HTML5
- ARIA labels para lectores de pantalla
- Contraste de colores accesible
- Navegación por teclado
- Texto alternativo para iconos

## Browser Support

- Chrome 60+
- Firefox 55+
- Safari 12+
- Edge 79+

## Troubleshooting

### Problemas Comunes

1. **API no responde**:
   - Verifica la URL en `API_CONFIG`
   - Revisa CORS en el servidor
   - El modo demo se activa automáticamente

2. **Estilos no cargan**:
   - Verifica las rutas de archivos
   - Comprueba la consola del navegador

3. **JavaScript no funciona**:
   - Abre DevTools → Console
   - Revisa errores de sintaxis
   - Verifica compatibilidad del navegador

### Debugging

Abre DevTools (F12) y revisa:
- **Console**: Errores de JavaScript
- **Network**: Llamadas a API
- **Elements**: Estructura HTML/CSS

## Contribución

Para contribuir al proyecto:

1. Fork el repositorio
2. Crea una branch para tu feature
3. Commit tus cambios
4. Push a la branch
5. Crea un Pull Request

## Licencia

Este proyecto es parte de un trabajo académico sobre detección de depresión estudiantil.

## Contacto

Para soporte o preguntas sobre el frontend, abre un issue en el repositorio del proyecto.

---

**Nota Importante**: Esta herramienta es solo para fines educativos y no debe usarse como sustituto de consulta médica profesional.
