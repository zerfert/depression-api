#!/bin/bash

# Script alternativo para desplegar en Azure App Service (más económico)
# Requiere Azure CLI

# Variables
RESOURCE_GROUP="depression-api-app-rg"
APP_NAME="depression-prediction-api-$(date +%s)"
APP_SERVICE_PLAN="depression-api-plan"
LOCATION="East US"
RUNTIME="PYTHON|3.9"

echo "🚀 Desplegando API en Azure App Service"
echo "======================================="

# 1. Crear grupo de recursos
echo "[1/5] Creando grupo de recursos..."
az group create --name $RESOURCE_GROUP --location "$LOCATION"

# 2. Crear App Service Plan (Free tier)
echo "[2/5] Creando App Service Plan..."
az appservice plan create \
    --name $APP_SERVICE_PLAN \
    --resource-group $RESOURCE_GROUP \
    --sku F1 \
    --is-linux

# 3. Crear Web App
echo "[3/5] Creando Web App..."
az webapp create \
    --resource-group $RESOURCE_GROUP \
    --plan $APP_SERVICE_PLAN \
    --name $APP_NAME \
    --runtime "$RUNTIME"

# 4. Configurar settings de la aplicación
echo "[4/5] Configurando aplicación..."
az webapp config appsettings set \
    --resource-group $RESOURCE_GROUP \
    --name $APP_NAME \
    --settings SCM_DO_BUILD_DURING_DEPLOYMENT=true

# 5. Desplegar código
echo "[5/5] Desplegando código..."
az webapp up \
    --resource-group $RESOURCE_GROUP \
    --name $APP_NAME \
    --runtime "$RUNTIME" \
    --sku F1

echo ""
echo "✅ ¡Despliegue en App Service completado!"
echo "======================================="
echo "🌐 URL de la API: https://$APP_NAME.azurewebsites.net"
echo "📖 Documentación: https://$APP_NAME.azurewebsites.net/docs"
echo "🔍 Estado: https://$APP_NAME.azurewebsites.net/health"
echo ""
echo "💡 Nota: El tier gratuito puede tardar en despertar la aplicación."
