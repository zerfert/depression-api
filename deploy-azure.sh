#!/bin/bash

# Script para desplegar la API en Azure Container Instances
# Ejecutar desde Azure Cloud Shell o con Azure CLI instalado

# Variables de configuración
RESOURCE_GROUP="depression-api-rg"
LOCATION="East US"
CONTAINER_NAME="depression-api"
ACR_NAME="depressionapiregistry"
IMAGE_NAME="depression-prediction-api"
DNS_NAME="depression-api-$(date +%s)"

echo "🚀 Desplegando API de Predicción de Depresión en Azure"
echo "=================================================="

# 1. Crear grupo de recursos
echo "[1/6] Creando grupo de recursos..."
az group create --name $RESOURCE_GROUP --location "$LOCATION"

# 2. Crear Azure Container Registry
echo "[2/6] Creando Azure Container Registry..."
az acr create --resource-group $RESOURCE_GROUP \
    --name $ACR_NAME \
    --sku Basic \
    --admin-enabled true

# 3. Construir y subir imagen Docker
echo "[3/6] Construyendo y subiendo imagen Docker..."
az acr build --registry $ACR_NAME \
    --image $IMAGE_NAME:latest \
    .

# 4. Obtener credenciales del registry
echo "[4/6] Obteniendo credenciales..."
ACR_SERVER=$(az acr show --name $ACR_NAME --resource-group $RESOURCE_GROUP --query "loginServer" --output tsv)
ACR_USERNAME=$(az acr credential show --name $ACR_NAME --resource-group $RESOURCE_GROUP --query "username" --output tsv)
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --resource-group $RESOURCE_GROUP --query "passwords[0].value" --output tsv)

# 5. Crear container instance
echo "[5/6] Creando Azure Container Instance..."
az container create \
    --resource-group $RESOURCE_GROUP \
    --name $CONTAINER_NAME \
    --image $ACR_SERVER/$IMAGE_NAME:latest \
    --registry-login-server $ACR_SERVER \
    --registry-username $ACR_USERNAME \
    --registry-password $ACR_PASSWORD \
    --dns-name-label $DNS_NAME \
    --ports 8000 \
    --cpu 1 \
    --memory 2 \
    --restart-policy Always

# 6. Obtener URL de la API
echo "[6/6] Obteniendo información de despliegue..."
FQDN=$(az container show --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME --query "ipAddress.fqdn" --output tsv)
IP=$(az container show --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME --query "ipAddress.ip" --output tsv)

echo ""
echo "✅ ¡Despliegue completado exitosamente!"
echo "=================================================="
echo "🌐 URL de la API: http://$FQDN:8000"
echo "📖 Documentación: http://$FQDN:8000/docs"
echo "🔍 Estado: http://$FQDN:8000/health"
echo "🖥️  IP Pública: $IP"
echo ""
echo "💡 Comandos útiles:"
echo "   - Ver logs: az container logs --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME"
echo "   - Reiniciar: az container restart --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME"
echo "   - Eliminar: az group delete --name $RESOURCE_GROUP --yes --no-wait"
