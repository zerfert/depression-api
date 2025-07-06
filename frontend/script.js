// Configuration
const API_CONFIG = {
    baseUrl: 'https://depression-api-student-ebbkctaba3e4ceej.eastus-01.azurewebsites.net',
    endpoints: {
        predict: '/predict',
        health: '/health'
    }
};

// State management
let formData = {};

// DOM elements
const form = document.getElementById('depressionForm');
const submitBtn = document.getElementById('submitBtn');
const clearBtn = document.getElementById('clearForm');
const modal = document.getElementById('resultModal');
const modalContent = document.getElementById('resultContent');
const closeModal = document.querySelector('.close');
const loadingSpinner = document.getElementById('loadingSpinner');

// Initialize the application
document.addEventListener('DOMContentLoaded', function() {
    initializeForm();
    setupEventListeners();
    setupSliders();
    checkAPIHealth();
});

// Initialize form with default values and validation
function initializeForm() {
    // Set default values for sliders
    const sliders = document.querySelectorAll('.slider');
    sliders.forEach(slider => {
        updateSliderValue(slider);
    });
}

// Setup event listeners
function setupEventListeners() {
    // Form submission
    form.addEventListener('submit', handleFormSubmit);
    
    // Clear form button
    clearBtn.addEventListener('click', clearForm);
    
    // Modal close
    closeModal.addEventListener('click', closeModalHandler);
    window.addEventListener('click', function(event) {
        if (event.target === modal) {
            closeModalHandler();
        }
    });
    
    // Real-time validation
    const inputs = form.querySelectorAll('input, select');
    inputs.forEach(input => {
        input.addEventListener('blur', validateField);
        input.addEventListener('input', clearFieldError);
    });
}

// Setup slider functionality
function setupSliders() {
    const sliders = document.querySelectorAll('.slider');
    sliders.forEach(slider => {
        slider.addEventListener('input', function() {
            updateSliderValue(this);
        });
    });
}

// Update slider display value
function updateSliderValue(slider) {
    const valueDisplay = document.getElementById(slider.id + 'Value');
    if (valueDisplay) {
        valueDisplay.textContent = slider.value;
    }
}

// Check API health
async function checkAPIHealth() {
    try {
        const response = await fetch(`${API_CONFIG.baseUrl}${API_CONFIG.endpoints.health}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            }
        });
        
        if (!response.ok) {
            showAPIStatusWarning();
        }
    } catch (error) {
        console.warn('API health check failed:', error);
        showAPIStatusWarning();
    }
}

// Show API status warning
function showAPIStatusWarning() {
    const warning = document.createElement('div');
    warning.className = 'api-warning';
    warning.innerHTML = `
        <div style="background: #fff3cd; border: 1px solid #ffeaa7; color: #856404; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
            <i class="fas fa-exclamation-triangle"></i>
            <strong>Aviso:</strong> La API puede estar temporalmente inactiva. 
            El formulario seguirá funcionando en modo de demostración.
        </div>
    `;
    
    const formContainer = document.querySelector('.form-container');
    formContainer.insertBefore(warning, form);
}

// Handle form submission
async function handleFormSubmit(event) {
    event.preventDefault();
    
    if (!validateForm()) {
        return;
    }
    
    const formData = collectFormData();
    
    showLoading(true);
    
    try {
        const result = await submitPrediction(formData);
        showResult(result);
    } catch (error) {
        console.error('Error submitting prediction:', error);
        showDemoResult(formData);
    } finally {
        showLoading(false);
    }
}

// Collect form data
function collectFormData() {
    const data = {
        Age: parseInt(document.getElementById('age').value),
        Gender: document.getElementById('gender').value,
        'Academic Pressure': parseInt(document.getElementById('academicPressure').value),
        CGPA: parseFloat(document.getElementById('cgpa').value),
        'Study Satisfaction': parseInt(document.getElementById('studySatisfaction').value),
        Profession: document.getElementById('profession').value,
        'Work Pressure': parseInt(document.getElementById('workPressure').value),
        'Sleep Duration': parseFloat(document.getElementById('sleepDuration').value),
        'Dietary Habits': document.getElementById('dietaryHabits').value,
        'Suicidal thoughts': document.querySelector('input[name="suicidalThoughts"]:checked').value,
        'Family History of Mental Illness': document.querySelector('input[name="familyHistory"]:checked').value,
        'Financial Stress': parseInt(document.getElementById('financialStress').value)
    };
    
    return data;
}

// Submit prediction to API
async function submitPrediction(data) {
    const response = await fetch(`${API_CONFIG.baseUrl}${API_CONFIG.endpoints.predict}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data)
    });
    
    if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    return await response.json();
}

// Show demo result (fallback when API is unavailable)
function showDemoResult(formData) {
    // Simple scoring algorithm for demo purposes
    let riskScore = 0;
    
    // Age factor
    if (formData.Age < 20 || formData.Age > 25) riskScore += 0.1;
    
    // Academic and work pressure
    if (formData['Academic Pressure'] >= 4) riskScore += 0.2;
    if (formData['Work Pressure'] >= 4) riskScore += 0.15;
    
    // Financial stress
    if (formData['Financial Stress'] >= 4) riskScore += 0.2;
    
    // Sleep
    if (formData['Sleep Duration'] < 6 || formData['Sleep Duration'] > 9) riskScore += 0.15;
    
    // CGPA
    if (formData.CGPA < 6) riskScore += 0.1;
    
    // Study satisfaction
    if (formData['Study Satisfaction'] <= 2) riskScore += 0.2;
    
    // Critical factors
    if (formData['Suicidal thoughts'] === 'Yes') riskScore += 0.4;
    if (formData['Family History of Mental Illness'] === 'Yes') riskScore += 0.2;
    if (formData['Dietary Habits'] === 'Unhealthy') riskScore += 0.1;
    
    // Normalize to 0-1 range
    riskScore = Math.min(riskScore, 1);
    
    const result = {
        prediction: riskScore > 0.5 ? 1 : 0,
        probability: riskScore,
        confidence: Math.abs(riskScore - 0.5) * 2,
        demo_mode: true
    };
    
    showResult(result);
}

// Show loading state
function showLoading(show) {
    loadingSpinner.style.display = show ? 'flex' : 'none';
    submitBtn.disabled = show;
    
    if (show) {
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Analizando...';
    } else {
        submitBtn.innerHTML = '<i class="fas fa-brain"></i> Evaluar Riesgo de Depresión';
    }
}

// Show result in modal
function showResult(result) {
    const isHighRisk = result.prediction === 1;
    const probability = (result.probability * 100).toFixed(1);
    const confidence = result.confidence ? (result.confidence * 100).toFixed(1) : 'N/A';
    
    const resultHTML = `
        <div class="result-container ${isHighRisk ? 'result-high-risk' : 'result-low-risk'} fade-in">
            <div class="result-icon">
                <i class="fas ${isHighRisk ? 'fa-exclamation-triangle' : 'fa-check-circle'}"></i>
            </div>
            
            <h2 class="result-title">
                ${isHighRisk ? 'Riesgo Elevado Detectado' : 'Riesgo Bajo Detectado'}
            </h2>
            
            <div class="result-probability">
                Probabilidad de depresión: ${probability}%
            </div>
            
            <div class="result-description">
                ${isHighRisk ? 
                    'Los datos analizados sugieren que existe un riesgo elevado de síntomas depresivos. Es importante buscar apoyo profesional.' :
                    'Los datos analizados sugieren un riesgo bajo de síntomas depresivos. Continúa manteniendo hábitos saludables.'
                }
            </div>
            
            ${result.demo_mode ? `
                <div style="background: #e8f4ff; border: 1px solid #b3d9ff; color: #0066cc; padding: 10px; border-radius: 6px; margin: 15px 0; font-size: 0.9rem;">
                    <i class="fas fa-info-circle"></i> Resultado en modo demostración
                </div>
            ` : ''}
            
            <div class="result-recommendations">
                <h3><i class="fas fa-lightbulb"></i> Recomendaciones</h3>
                <ul>
                    ${getRecommendations(result, isHighRisk).map(rec => 
                        `<li><i class="fas fa-check"></i> ${rec}</li>`
                    ).join('')}
                </ul>
            </div>
            
            <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee; text-align: center;">
                <button onclick="closeModalHandler()" class="btn btn-primary">
                    <i class="fas fa-times"></i> Cerrar
                </button>
                <button onclick="downloadReport()" class="btn btn-secondary" style="margin-left: 10px;">
                    <i class="fas fa-download"></i> Descargar Reporte
                </button>
            </div>
        </div>
    `;
    
    modalContent.innerHTML = resultHTML;
    modal.style.display = 'block';
    document.body.style.overflow = 'hidden';
}

// Get recommendations based on result
function getRecommendations(result, isHighRisk) {
    const baseRecommendations = [
        'Mantén una rutina de sueño regular de 7-8 horas',
        'Practica ejercicio físico regularmente',
        'Consume una dieta balanceada y nutritiva',
        'Dedica tiempo a actividades que disfrutes'
    ];
    
    const highRiskRecommendations = [
        'Consulta con un profesional de salud mental',
        'Considera unirte a grupos de apoyo estudiantil',
        'Habla con amigos, familia o consejeros académicos',
        'Practica técnicas de manejo del estrés y mindfulness',
        'Evita el aislamiento social',
        'Si tienes pensamientos suicidas, busca ayuda inmediata'
    ];
    
    const lowRiskRecommendations = [
        'Continúa con tus hábitos saludables actuales',
        'Mantén un equilibrio entre estudios y vida personal',
        'Desarrolla una red de apoyo social sólida',
        'Aprende técnicas de manejo del estrés preventivas'
    ];
    
    return isHighRisk ? 
        [...highRiskRecommendations, ...baseRecommendations].slice(0, 6) :
        [...lowRiskRecommendations, ...baseRecommendations].slice(0, 5);
}

// Download report functionality
function downloadReport() {
    const formData = collectFormData();
    const resultData = modalContent.textContent;
    
    const reportContent = `
REPORTE DE EVALUACIÓN DE DEPRESIÓN ESTUDIANTIL
=============================================
Fecha: ${new Date().toLocaleDateString('es-ES')}

DATOS INGRESADOS:
${Object.entries(formData).map(([key, value]) => `${key}: ${value}`).join('\n')}

RESULTADO:
${resultData}

NOTA IMPORTANTE:
Este reporte es solo una herramienta de apoyo educativo y no constituye un diagnóstico médico.
Para una evaluación profesional, consulte con un especialista en salud mental.
    `;
    
    const blob = new Blob([reportContent], { type: 'text/plain' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `reporte_depresion_${new Date().toISOString().split('T')[0]}.txt`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    window.URL.revokeObjectURL(url);
}

// Validate form
function validateForm() {
    let isValid = true;
    const requiredFields = form.querySelectorAll('[required]');
    
    requiredFields.forEach(field => {
        if (!validateField({target: field})) {
            isValid = false;
        }
    });
    
    // Check radio groups
    const radioGroups = ['suicidalThoughts', 'familyHistory'];
    radioGroups.forEach(groupName => {
        const checkedRadio = document.querySelector(`input[name="${groupName}"]:checked`);
        if (!checkedRadio) {
            showFieldError(document.querySelector(`input[name="${groupName}"]`), 'Este campo es obligatorio');
            isValid = false;
        }
    });
    
    if (!isValid) {
        // Scroll to first error
        const firstError = document.querySelector('.error');
        if (firstError) {
            firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
            firstError.classList.add('shake');
            setTimeout(() => firstError.classList.remove('shake'), 500);
        }
    }
    
    return isValid;
}

// Validate individual field
function validateField(event) {
    const field = event.target;
    const value = field.value.trim();
    let isValid = true;
    let errorMessage = '';
    
    // Clear previous errors
    clearFieldError(event);
    
    // Required field validation
    if (field.hasAttribute('required') && !value) {
        errorMessage = 'Este campo es obligatorio';
        isValid = false;
    }
    
    // Type-specific validation
    switch (field.type) {
        case 'number':
            if (value && (isNaN(value) || value < field.min || value > field.max)) {
                errorMessage = `Valor debe estar entre ${field.min} y ${field.max}`;
                isValid = false;
            }
            break;
            
        case 'email':
            if (value && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                errorMessage = 'Formato de email inválido';
                isValid = false;
            }
            break;
    }
    
    // Field-specific validation
    switch (field.id) {
        case 'age':
            if (value && (value < 16 || value > 30)) {
                errorMessage = 'La edad debe estar entre 16 y 30 años';
                isValid = false;
            }
            break;
            
        case 'cgpa':
            if (value && (value < 0 || value > 10)) {
                errorMessage = 'El CGPA debe estar entre 0 y 10';
                isValid = false;
            }
            break;
            
        case 'sleepDuration':
            if (value && (value < 4 || value > 12)) {
                errorMessage = 'Las horas de sueño deben estar entre 4 y 12';
                isValid = false;
            }
            break;
    }
    
    if (!isValid) {
        showFieldError(field, errorMessage);
    }
    
    return isValid;
}

// Show field error
function showFieldError(field, message) {
    field.classList.add('error');
    
    let errorElement = field.parentNode.querySelector('.error-message');
    if (!errorElement) {
        errorElement = document.createElement('div');
        errorElement.className = 'error-message';
        field.parentNode.appendChild(errorElement);
    }
    
    errorElement.textContent = message;
    errorElement.classList.add('show');
}

// Clear field error
function clearFieldError(event) {
    const field = event.target;
    field.classList.remove('error');
    
    const errorElement = field.parentNode.querySelector('.error-message');
    if (errorElement) {
        errorElement.classList.remove('show');
        setTimeout(() => {
            if (errorElement.parentNode) {
                errorElement.parentNode.removeChild(errorElement);
            }
        }, 300);
    }
}

// Clear form
function clearForm() {
    if (confirm('¿Estás seguro de que quieres limpiar todos los campos?')) {
        form.reset();
        
        // Reset sliders to default values
        const sliders = document.querySelectorAll('.slider');
        sliders.forEach(slider => {
            slider.value = 3;
            updateSliderValue(slider);
        });
        
        // Clear all errors
        const errorFields = document.querySelectorAll('.error');
        errorFields.forEach(field => {
            field.classList.remove('error');
        });
        
        const errorMessages = document.querySelectorAll('.error-message');
        errorMessages.forEach(msg => {
            if (msg.parentNode) {
                msg.parentNode.removeChild(msg);
            }
        });
        
        // Focus on first field
        document.getElementById('age').focus();
    }
}

// Close modal
function closeModalHandler() {
    modal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

// Utility functions
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Add some helpful keyboard shortcuts
document.addEventListener('keydown', function(event) {
    // Escape key closes modal
    if (event.key === 'Escape' && modal.style.display === 'block') {
        closeModalHandler();
    }
    
    // Ctrl/Cmd + Enter submits form
    if ((event.ctrlKey || event.metaKey) && event.key === 'Enter') {
        event.preventDefault();
        if (form.checkValidity()) {
            handleFormSubmit(event);
        }
    }
});

// Add smooth scrolling for better UX
function smoothScrollTo(element) {
    element.scrollIntoView({
        behavior: 'smooth',
        block: 'center'
    });
}

// Error handling for global errors
window.addEventListener('error', function(event) {
    console.error('Global error:', event.error);
    // You could show a user-friendly error message here
});

// Log when the script is loaded
console.log('Depression Assessment App initialized successfully');
