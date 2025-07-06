#!/bin/bash

echo "🚀 Preparando frontend para GitHub Pages..."

# Crear directorio temporal si no existe
mkdir -p temp

# Verificar archivos necesarios
echo "📋 Verificando archivos..."

required_files=("index.html" "styles.css" "script.js" "about.html")
missing_files=()

for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -ne 0 ]; then
    echo "❌ Faltan archivos requeridos: ${missing_files[*]}"
    exit 1
fi

echo "✅ Todos los archivos necesarios están presentes"

# Optimizar HTML (minificar comentarios, espacios extras)
echo "🔧 Optimizando archivos..."

# Crear backup
cp index.html index.html.backup
cp styles.css styles.css.backup

# Optimizar CSS (remover comentarios innecesarios)
sed -i.bak '/^[[:space:]]*\/\*/d; /^[[:space:]]*\*\//d' styles.css 2>/dev/null || true

# Verificar que los enlaces son relativos (importantes para GitHub Pages)
echo "🔗 Verificando enlaces relativos..."

if grep -q 'href="/' index.html; then
    echo "⚠️  ADVERTENCIA: Se encontraron enlaces absolutos en index.html"
    echo "   GitHub Pages requiere enlaces relativos"
fi

if grep -q 'src="/' index.html; then
    echo "⚠️  ADVERTENCIA: Se encontraron rutas absolutas en index.html"
    echo "   GitHub Pages requiere rutas relativas"
fi

# Verificar que el API endpoint es accesible
echo "🌐 Verificando API endpoint..."

api_url="https://depression-api-student-ebbkctaba3e4ceej.eastus-01.azurewebsites.net"

if command -v curl >/dev/null 2>&1; then
    if curl -s --head "$api_url" | head -n 1 | grep -q "200"; then
        echo "✅ API endpoint accesible"
    else
        echo "⚠️  API endpoint no responde (el frontend funcionará en modo demo)"
    fi
else
    echo "ℹ️  curl no disponible - no se puede verificar API"
fi

# Crear archivo _config.yml para Jekyll (GitHub Pages)
cat > _config.yml << EOF
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

# Google Analytics (opcional - reemplaza con tu ID)
# google_analytics: UA-XXXXXXXXX-X

# GitHub repository
repository: tu-usuario/depression-detector-frontend
EOF

# Crear archivo robots.txt
cat > robots.txt << EOF
User-agent: *
Allow: /

# Sitemap
Sitemap: https://tu-usuario.github.io/depression-detector-frontend/sitemap.xml
EOF

# Crear archivo sitemap.xml básico
cat > sitemap.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://tu-usuario.github.io/depression-detector-frontend/</loc>
    <lastmod>$(date +%Y-%m-%d)</lastmod>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>https://tu-usuario.github.io/depression-detector-frontend/about.html</loc>
    <lastmod>$(date +%Y-%m-%d)</lastmod>
    <priority>0.8</priority>
  </url>
</urlset>
EOF

# Crear archivo manifest.json para PWA (opcional)
cat > manifest.json << EOF
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
EOF

# Crear archivo 404.html personalizado
cat > 404.html << EOF
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
EOF

echo "📝 Archivos de configuración creados:"
echo "   - _config.yml (configuración Jekyll)"
echo "   - robots.txt (SEO)"
echo "   - sitemap.xml (SEO)"
echo "   - manifest.json (PWA)"
echo "   - 404.html (página de error)"

# Limpiar archivos temporales
rm -f *.bak 2>/dev/null || true

echo ""
echo "✅ Frontend preparado para GitHub Pages!"
echo ""
echo "📋 Próximos pasos:"
echo "   1. Sube todos los archivos a tu repositorio GitHub"
echo "   2. Ve a Settings → Pages en tu repositorio"
echo "   3. Selecciona 'Deploy from a branch' → 'main' → '/ (root)'"
echo "   4. Espera 5-10 minutos para el despliegue"
echo ""
echo "🌐 Tu sitio estará disponible en:"
echo "   https://tu-usuario.github.io/depression-detector-frontend"
echo ""
echo "⚠️  Recuerda actualizar las URLs en los archivos con tu usuario real de GitHub"
EOF
