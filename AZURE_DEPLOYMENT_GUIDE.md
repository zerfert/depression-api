# 🚀 Guía de Despliegue en Azure

## Opciones de Despliegue

### Opción 1: Azure Container Instances (Recomendado)
- **Costo**: ~$20-30/mes
- **Ventajas**: Fácil de usar, escalable, sin servidor
- **Desventajas**: Más costoso que App Service

### Opción 2: Azure App Service
- **Costo**: Gratis (tier F1) o ~$10/mes (tier B1)
- **Ventajas**: Muy económico, CI/CD integrado
- **Desventajas**: Tiempo de arranque lento en tier gratuito

---

## 📋 Prerequisitos

1. **Azure CLI instalado**
   ```bash
   # Windows (con Chocolatey)
   choco install azure-cli
   
   # O descargar desde: https://aka.ms/installazurecliwindows
   ```

2. **Docker Desktop** (solo para Container Instances)
   - Descargar: https://www.docker.com/products/docker-desktop

3. **Cuenta de Azure**
   - Crear cuenta gratuita: https://azure.microsoft.com/free/

---

## 🔧 Despliegue Paso a Paso

### Opción 1: Container Instances (PowerShell)

```powershell
# 1. Iniciar sesión en Azure
az login

# 2. Ejecutar script de despliegue
.\deploy-azure.ps1
```

### Opción 2: App Service (Más económico)

```bash
# 1. Iniciar sesión
az login

# 2. Instalar extensión de webapp (si es necesario)
az extension add --name webapp

# 3. Ejecutar despliegue
chmod +x deploy-appservice.sh
./deploy-appservice.sh
```

### Opción 3: Despliegue Manual en App Service

```bash
# 1. Crear recursos
az group create --name myResourceGroup --location "East US"

az appservice plan create --name myAppServicePlan --resource-group myResourceGroup --sku F1 --is-linux

az webapp create --resource-group myResourceGroup --plan myAppServicePlan --name myUniqueAppName --runtime "PYTHON|3.9"

# 2. Configurar para despliegue desde código local
az webapp config appsettings set --resource-group myResourceGroup --name myUniqueAppName --settings SCM_DO_BUILD_DURING_DEPLOYMENT=true

# 3. Desplegar
az webapp up --resource-group myResourceGroup --name myUniqueAppName
```

---

## 🔍 Verificación del Despliegue

Una vez desplegado, verifica que funciona:

1. **Endpoint de salud**: `https://tu-app.azurewebsites.net/health`
2. **Documentación**: `https://tu-app.azurewebsites.net/docs`
3. **Predicción de prueba**:
   ```bash
   curl -X POST "https://tu-app.azurewebsites.net/predict" \
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

---

## 🛠️ Comandos Útiles

### Monitoreo
```bash
# Ver logs de Container Instance
az container logs --resource-group depression-api-rg --name depression-api

# Ver logs de App Service
az webapp log tail --resource-group myResourceGroup --name myAppName

# Ver métricas
az monitor metrics list --resource /subscriptions/SUBSCRIPTION-ID/resourceGroups/RESOURCE-GROUP/providers/Microsoft.Web/sites/APP-NAME
```

### Gestión
```bash
# Reiniciar aplicación
az webapp restart --resource-group myResourceGroup --name myAppName

# Escalar App Service
az appservice plan update --name myAppServicePlan --resource-group myResourceGroup --sku B1

# Eliminar todos los recursos
az group delete --name myResourceGroup --yes --no-wait
```

---

## 💰 Estimación de Costos

### App Service (F1 - Gratuito)
- **Costo**: $0/mes
- **Limitaciones**: 
  - 60 minutos de CPU por día
  - 1 GB de almacenamiento
  - Sin dominio personalizado
  - Tiempo de arranque lento

### App Service (B1 - Básico)
- **Costo**: ~$10/mes
- **Recursos**: 1 Core, 1.75 GB RAM
- **Sin limitaciones de tiempo**

### Container Instances
- **Costo**: ~$20-30/mes
- **Recursos**: 1 vCPU, 2 GB RAM
- **Escalabilidad automática**

---

## 🔐 Seguridad y Configuración

### Variables de Entorno (Producción)
```bash
# Configurar variables sensibles
az webapp config appsettings set \
  --resource-group myResourceGroup \
  --name myAppName \
  --settings \
  MODEL_VERSION="1.0" \
  LOG_LEVEL="INFO" \
  ALLOWED_ORIGINS="https://mi-frontend.com"
```

### HTTPS y Dominio Personalizado
```bash
# Configurar dominio personalizado
az webapp config hostname add --webapp-name myAppName --resource-group myResourceGroup --hostname myapp.mydomain.com

# Habilitar SSL automático
az webapp config ssl bind --certificate-thumbprint THUMBPRINT --ssl-type SNI --resource-group myResourceGroup --name myAppName
```

---

## 🚨 Solución de Problemas

### Error: "Application failed to start"
1. Verificar logs: `az webapp log tail`
2. Verificar que `train_model.py` se ejecuta correctamente
3. Asegurar que el puerto sea 8000

### Error: "Module not found"
1. Verificar `requirements.txt`
2. Configurar: `SCM_DO_BUILD_DURING_DEPLOYMENT=true`

### Tiempo de respuesta lento
1. Usar tier B1 o superior
2. Configurar "Always On" en App Service
3. Considerar usar Container Instances

---

## 📞 Soporte

- **Azure Support**: https://azure.microsoft.com/support/
- **Documentación**: https://docs.microsoft.com/azure/
- **Pricing Calculator**: https://azure.microsoft.com/pricing/calculator/
