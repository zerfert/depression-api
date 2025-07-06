# 🚀 GUÍA RÁPIDA: Subir a GitHub Pages

## ⚡ 3 Pasos Simples

### 1️⃣ Preparar Archivos
```powershell
# Ejecuta en PowerShell (Windows)
.\prepare_github.ps1

# O en Bash (Linux/Mac)
chmod +x prepare_github.sh
./prepare_github.sh
```

### 2️⃣ Crear Repositorio
1. Ve a [github.com](https://github.com) → **"New Repository"**
2. Nombre: `depression-detector-frontend`
3. **Público** ✅ (necesario para GitHub Pages gratuito)
4. **NO** marcar "Initialize with README"
5. **"Create Repository"**

### 3️⃣ Subir Archivos

#### Opción A: GitHub Desktop (Fácil) 👍
1. Descarga [GitHub Desktop](https://desktop.github.com)
2. Clone tu repositorio
3. Copia TODOS los archivos del frontend
4. Commit: "🚀 Deploy frontend"
5. Push

#### Opción B: Drag & Drop Web
1. En tu repositorio GitHub → **"uploading an existing file"**
2. Arrastra TODOS los archivos
3. Commit: "🚀 Deploy frontend"

#### Opción C: Git Terminal
```bash
git init
git remote add origin https://github.com/TU_USUARIO/depression-detector-frontend.git
git add .
git commit -m "🚀 Deploy frontend"
git branch -M main
git push -u origin main
```

### 4️⃣ Activar GitHub Pages
1. En tu repo → **Settings** → **Pages**
2. Source: **"Deploy from a branch"**
3. Branch: **"main"**
4. Folder: **"/ (root)"**
5. **Save** ✅

### 5️⃣ ¡Listo! 🎉
- Tu sitio estará en: `https://TU_USUARIO.github.io/depression-detector-frontend`
- Primer deploy: 5-10 minutos
- Actualizaciones futuras: 1-2 minutos

---

## 📋 Lista de Archivos a Subir

**Asegúrate de incluir TODOS estos archivos:**

✅ **Principales:**
- `index.html` (página principal)
- `styles.css` (estilos)
- `script.js` (funcionalidad)
- `about.html` (información)

✅ **Configuración GitHub:**
- `_config.yml` (Jekyll config)
- `.github/workflows/deploy.yml` (auto-deploy)
- `.gitignore` (archivos a ignorar)

✅ **SEO & Extras:**
- `robots.txt` (SEO)
- `sitemap.xml` (SEO)
- `manifest.json` (PWA)
- `404.html` (página error)

✅ **Documentación:**
- `README.md` (documentación)
- `DEPLOY_GUIDE.md` (guía completa)
- `config.json` (configuración)

---

## 🔧 Personalización Rápida

### Cambiar URLs
Busca y reemplaza en TODOS los archivos:
- `tu-usuario` → `TU_USUARIO_GITHUB`
- `depression-detector-frontend` → `TU_NOMBRE_REPO`

### Cambiar Colores
En `styles.css`:
```css
:root {
    --primary-color: #667eea;    /* Cambia aquí */
    --secondary-color: #764ba2;  /* Y aquí */
}
```

### Cambiar API URL
En `script.js`:
```javascript
const API_CONFIG = {
    baseUrl: 'TU_API_URL_AQUÍ',
    // ...
};
```

---

## 🆘 Solución de Problemas

### El sitio no carga
- ✅ Verifica que `index.html` esté en la raíz
- ✅ Espera 10 minutos después del primer deploy
- ✅ Revisa Settings → Pages que esté configurado

### Sin estilos (texto plano)
- ✅ Verifica que `styles.css` esté en la raíz
- ✅ Revisa que no haya errores en `index.html`

### JavaScript no funciona
- ✅ Abre DevTools (F12) → Console
- ✅ Verifica que `script.js` esté en la raíz
- ✅ Revisa errores en la consola

### 404 en GitHub Pages
- ✅ El repositorio debe ser **público**
- ✅ GitHub Pages debe estar **activado**
- ✅ Branch debe ser **main** o **master**

---

## 🎯 URLs Importantes

- **Tu sitio**: `https://TU_USUARIO.github.io/TU_REPO`
- **Repositorio**: `https://github.com/TU_USUARIO/TU_REPO`
- **Settings**: `https://github.com/TU_USUARIO/TU_REPO/settings/pages`

---

## 📞 Más Ayuda

- 📖 [Documentación GitHub Pages](https://docs.github.com/pages)
- 🎥 [Video: GitHub Pages Tutorial](https://youtube.com/results?search_query=github+pages+tutorial)
- 💬 [GitHub Community](https://github.community)

---

**¡Tu detector de depresión estará online en minutos! 🧠✨**
