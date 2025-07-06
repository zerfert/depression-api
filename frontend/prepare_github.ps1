# PowerShell script para preparar el frontend para GitHub Pages

Write-Host "🚀 Preparando frontend para GitHub Pages..." -ForegroundColor Green

# Verificar archivos necesarios
Write-Host "📋 Verificando archivos..." -ForegroundColor Yellow

$requiredFiles = @("index.html", "styles.css", "script.js", "about.html")
$missingFiles = @()

foreach ($file in $requiredFiles) {
    if (!(Test-Path $file)) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Host "❌ Faltan archivos requeridos: $($missingFiles -join ', ')" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Todos los archivos necesarios están presentes" -ForegroundColor Green

# Crear archivo _config.yml para Jekyll (GitHub Pages)
$configContent = @"
# GitHub Pages configuration
title: "Detector de Depresión Estudiantil"
description: "Sistema de detección temprana de depresión en estudiantes universitarios usando machine learning"
url: "https://tu-usuario.github.io"
baseurl: "/depression-detector-frontend"

# Jekyll configuration
markdown: kramdown
highlighter: rouge
theme: minima

# Exclude files from processing
exclude:
  - README.md
  - DEPLOY_GUIDE.md
  - deploy.bat
  - prepare_github.ps1
  - prepare_github.sh
  - "*.backup"
  - temp/
  - .gitignore

# Include files that start with underscore
include:
  - _redirects

# SEO settings
author: "Proyecto Final - Análisis de Datos"
twitter:
  username: tu_usuario
  card: summary_large_image

# Social media
social:
  name: Detector de Depresión Estudiantil
  links:
    - https://github.com/tu-usuario/depression-detector-frontend

# GitHub repository
repository: tu-usuario/depression-detector-frontend
"@

Set-Content -Path "_config.yml" -Value $configContent -Encoding UTF8

# Crear archivo robots.txt
$robotsContent = @"
User-agent: *
Allow: /

# Sitemap
Sitemap: https://tu-usuario.github.io/depression-detector-frontend/sitemap.xml
"@

Set-Content -Path "robots.txt" -Value $robotsContent -Encoding UTF8

# Crear archivo sitemap.xml básico
$currentDate = Get-Date -Format "yyyy-MM-dd"
$sitemapContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://tu-usuario.github.io/depression-detector-frontend/</loc>
    <lastmod>$currentDate</lastmod>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>https://tu-usuario.github.io/depression-detector-frontend/about.html</loc>
    <lastmod>$currentDate</lastmod>
    <priority>0.8</priority>
  </url>
</urlset>
"@

Set-Content -Path "sitemap.xml" -Value $sitemapContent -Encoding UTF8

# Crear archivo manifest.json para PWA (opcional)
$manifestContent = @"
{
  "name": "Detector de Depresión Estudiantil",
  "short_name": "DepresionDetector",
  "description": "Sistema de detección temprana de depresión en estudiantes universitarios",
  "start_url": ".",
  "display": "standalone",
  "background_color": "#667eea",
  "theme_color": "#667eea",
  "icons": [
    {
      "src": "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🧠</text></svg>",
      "sizes": "192x192",
      "type": "image/svg+xml"
    }
  ]
}
"@

Set-Content -Path "manifest.json" -Value $manifestContent -Encoding UTF8

# Crear archivo 404.html personalizado
$notFoundContent = @"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página no encontrada - Detector de Depresión Estudiantil</title>
    <link rel="stylesheet" href="styles.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="main-content" style="text-align: center; padding: 60px 20px;">
            <i class="fas fa-exclamation-triangle" style="font-size: 4rem; color: #f39c12; margin-bottom: 20px;"></i>
            <h1 style="color: #2c3e50; margin-bottom: 20px;">Página no encontrada</h1>
            <p style="color: #666; margin-bottom: 30px;">
                La página que buscas no existe o ha sido movida.
            </p>
            <a href="./" class="btn btn-primary">
                <i class="fas fa-home"></i> Volver al Inicio
            </a>
        </div>
    </div>
</body>
</html>
"@

Set-Content -Path "404.html" -Value $notFoundContent -Encoding UTF8

# Verificar API endpoint
Write-Host "🌐 Verificando API endpoint..." -ForegroundColor Yellow

$apiUrl = "https://depression-api-student-ebbkctaba3e4ceej.eastus-01.azurewebsites.net"

try {
    $response = Invoke-WebRequest -Uri $apiUrl -Method Head -TimeoutSec 10 -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ API endpoint accesible" -ForegroundColor Green
    } else {
        Write-Host "⚠️  API endpoint no responde (el frontend funcionará en modo demo)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️  No se puede verificar API endpoint (el frontend funcionará en modo demo)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📝 Archivos de configuración creados:" -ForegroundColor Cyan
Write-Host "   - _config.yml (configuración Jekyll)" -ForegroundColor White
Write-Host "   - robots.txt (SEO)" -ForegroundColor White
Write-Host "   - sitemap.xml (SEO)" -ForegroundColor White
Write-Host "   - manifest.json (PWA)" -ForegroundColor White
Write-Host "   - 404.html (página de error)" -ForegroundColor White

Write-Host ""
Write-Host "✅ Frontend preparado para GitHub Pages!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Próximos pasos:" -ForegroundColor Cyan
Write-Host "   1. Sube todos los archivos a tu repositorio GitHub" -ForegroundColor White
Write-Host "   2. Ve a Settings → Pages en tu repositorio" -ForegroundColor White
Write-Host "   3. Selecciona 'Deploy from a branch' → 'main' → '/ (root)'" -ForegroundColor White
Write-Host "   4. Espera 5-10 minutos para el despliegue" -ForegroundColor White
Write-Host ""
Write-Host "🌐 Tu sitio estará disponible en:" -ForegroundColor Cyan
Write-Host "   https://tu-usuario.github.io/depression-detector-frontend" -ForegroundColor Yellow
Write-Host ""
Write-Host "⚠️  Recuerda actualizar las URLs en los archivos con tu usuario real de GitHub" -ForegroundColor Red

# Preguntar si quiere abrir GitHub
$openGitHub = Read-Host "¿Quieres abrir GitHub en el navegador? (s/n)"
if ($openGitHub -eq "s" -or $openGitHub -eq "S") {
    Start-Process "https://github.com"
}

Write-Host ""
Write-Host "🎉 ¡Listo para subir a GitHub!" -ForegroundColor Green
pause
