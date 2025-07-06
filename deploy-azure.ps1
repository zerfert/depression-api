# Script de PowerShell para desplegar en Azure Container Instances
# Requiere Azure CLI instalado

# Variables de configuración
$RESOURCE_GROUP = "depression-api-rg"
$LOCATION = "East US"
$CONTAINER_NAME = "depression-api"
$ACR_NAME = "depressionapiregistry" + (Get-Random -Maximum 9999)
$IMAGE_NAME = "depression-prediction-api"
$DNS_NAME = "depression-api-" + (Get-Date -Format "yyyyMMddHHmm")

Write-Host "🚀 Desplegando API de Predicción de Depresión en Azure" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Green

try {
    # Verificar que Azure CLI está instalado
    Write-Host "[0/6] Verificando Azure CLI..." -ForegroundColor Yellow
    az --version | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Azure CLI no está instalado. Instálelo desde: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    }

    # Verificar login
    Write-Host "[0/6] Verificando sesión de Azure..." -ForegroundColor Yellow
    $account = az account show 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Por favor, inicie sesión en Azure:" -ForegroundColor Red
        az login
    }

    # 1. Crear grupo de recursos
    Write-Host "[1/6] Creando grupo de recursos..." -ForegroundColor Yellow
    az group create --name $RESOURCE_GROUP --location $LOCATION
    if ($LASTEXITCODE -ne 0) { throw "Error creando grupo de recursos" }

    # 2. Crear Azure Container Registry
    Write-Host "[2/6] Creando Azure Container Registry..." -ForegroundColor Yellow
    az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic --admin-enabled true
    if ($LASTEXITCODE -ne 0) { throw "Error creando Container Registry" }

    # 3. Construir y subir imagen Docker
    Write-Host "[3/6] Construyendo y subiendo imagen Docker..." -ForegroundColor Yellow
    az acr build --registry $ACR_NAME --image "${IMAGE_NAME}:latest" .
    if ($LASTEXITCODE -ne 0) { throw "Error construyendo imagen Docker" }

    # 4. Obtener credenciales del registry
    Write-Host "[4/6] Obteniendo credenciales..." -ForegroundColor Yellow
    $ACR_SERVER = az acr show --name $ACR_NAME --resource-group $RESOURCE_GROUP --query "loginServer" --output tsv
    $ACR_USERNAME = az acr credential show --name $ACR_NAME --resource-group $RESOURCE_GROUP --query "username" --output tsv
    $ACR_PASSWORD = az acr credential show --name $ACR_NAME --resource-group $RESOURCE_GROUP --query "passwords[0].value" --output tsv

    # 5. Crear container instance
    Write-Host "[5/6] Creando Azure Container Instance..." -ForegroundColor Yellow
    az container create `
        --resource-group $RESOURCE_GROUP `
        --name $CONTAINER_NAME `
        --image "$ACR_SERVER/${IMAGE_NAME}:latest" `
        --registry-login-server $ACR_SERVER `
        --registry-username $ACR_USERNAME `
        --registry-password $ACR_PASSWORD `
        --dns-name-label $DNS_NAME `
        --ports 8000 `
        --cpu 1 `
        --memory 2 `
        --restart-policy Always
    if ($LASTEXITCODE -ne 0) { throw "Error creando Container Instance" }

    # 6. Obtener URL de la API
    Write-Host "[6/6] Obteniendo información de despliegue..." -ForegroundColor Yellow
    $FQDN = az container show --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME --query "ipAddress.fqdn" --output tsv
    $IP = az container show --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME --query "ipAddress.ip" --output tsv

    Write-Host ""
    Write-Host "✅ ¡Despliegue completado exitosamente!" -ForegroundColor Green
    Write-Host "======================================================" -ForegroundColor Green
    Write-Host "🌐 URL de la API: http://$FQDN:8000" -ForegroundColor Cyan
    Write-Host "📖 Documentación: http://$FQDN:8000/docs" -ForegroundColor Cyan
    Write-Host "🔍 Estado: http://$FQDN:8000/health" -ForegroundColor Cyan
    Write-Host "🖥️  IP Pública: $IP" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "💡 Comandos útiles:" -ForegroundColor Yellow
    Write-Host "   - Ver logs: az container logs --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME" -ForegroundColor White
    Write-Host "   - Reiniciar: az container restart --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME" -ForegroundColor White
    Write-Host "   - Eliminar: az group delete --name $RESOURCE_GROUP --yes --no-wait" -ForegroundColor White

    # Guardar información en archivo
    $deployInfo = @"
Despliegue completado: $(Get-Date)
Grupo de recursos: $RESOURCE_GROUP
URL de la API: http://$FQDN:8000
Documentación: http://$FQDN:8000/docs
IP: $IP
Container Registry: $ACR_NAME
"@
    $deployInfo | Out-File -FilePath "azure-deployment-info.txt" -Encoding UTF8
    Write-Host "📄 Información guardada en: azure-deployment-info.txt" -ForegroundColor Green

} catch {
    Write-Host "❌ Error durante el despliegue: $_" -ForegroundColor Red
    Write-Host "Limpiando recursos..." -ForegroundColor Yellow
    az group delete --name $RESOURCE_GROUP --yes --no-wait 2>$null
    exit 1
}
