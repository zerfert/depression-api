# Guía de Despliegue en GitHub Pages

## 🚀 Pasos para Subir a GitHub

### 1. Crear Repositorio en GitHub

1. Ve a [github.com](https://github.com) e inicia sesión
2. Click en el botón **"New"** (repositorio nuevo)
3. Nombra tu repositorio: `depression-detector-frontend`
4. Marca como **público** (necesario para GitHub Pages gratuito)
5. **NO** inicialices con README (ya tienes uno)
6. Click **"Create repository"**

### 2. Subir Archivos desde tu Computadora

#### Opción A: Usando GitHub Desktop (Fácil)

1. **Descarga GitHub Desktop**: [desktop.github.com](https://desktop.github.com)
2. **Instala** y **inicia sesión** con tu cuenta GitHub
3. **Clone** tu repositorio vacío:
   - File → Clone repository
   - Selecciona tu repositorio
   - Elige una carpeta local
4. **Copia todos los archivos** del frontend a la carpeta clonada
5. En GitHub Desktop:
   - Verás todos los archivos en "Changes"
   - Escribe un mensaje: "🚀 Primer deploy del frontend"
   - Click **"Commit to main"**
   - Click **"Push origin"**

#### Opción B: Usando Git (Terminal)

```bash
# En la carpeta de tu frontend, inicializa git
git init

# Agrega el repositorio remoto (cambia TU_USUARIO y TU_REPO)
git remote add origin https://github.com/TU_USUARIO/depression-detector-frontend.git

# Agrega todos los archivos
git add .

# Hace commit
git commit -m "🚀 Primer deploy del frontend"

# Sube a GitHub
git branch -M main
git push -u origin main
```

#### Opción C: Upload desde Web (Si tienes pocos archivos)

1. Ve a tu repositorio en GitHub
2. Click **"uploading an existing file"**
3. Arrastra todos los archivos del frontend
4. Scroll abajo, escribe mensaje: "🚀 Primer deploy del frontend"
5. Click **"Commit changes"**

### 3. Activar GitHub Pages

1. En tu repositorio, ve a **Settings** (pestaña superior)
2. Scroll hasta **"Pages"** en el menú lateral izquierdo
3. En **"Source"**: selecciona **"Deploy from a branch"**
4. En **"Branch"**: selecciona **"main"** 
5. En **"Folder"**: selecciona **"/ (root)"**
6. Click **"Save"**

### 4. Verificar Despliegue

- GitHub te mostrará la URL de tu sitio
- Será algo como: `https://TU_USUARIO.github.io/depression-detector-frontend`
- El primer despliegue puede tardar 5-10 minutos

## 🔧 Configuración Adicional

### Custom Domain (Opcional)

Si tienes un dominio propio:

1. En Settings → Pages
2. En "Custom domain" escribe tu dominio
3. Crea un archivo `CNAME` en la raíz con tu dominio

### HTTPS (Automático)

GitHub Pages activa HTTPS automáticamente. Tu sitio será seguro.

### Actualizaciones Automáticas

Con el workflow que creé (`.github/workflows/deploy.yml`):
- Cada vez que hagas `git push` a `main`
- Se desplegará automáticamente
- Sin intervención manual

## 📱 Verificar que Todo Funciona

### 1. Checklist Pre-Deploy

- [ ] Todos los archivos están en la carpeta
- [ ] `index.html` está en la raíz
- [ ] Links a CSS y JS son relativos (`href="styles.css"`)
- [ ] No hay rutas absolutas (`/folder/file.css`)

### 2. Checklist Post-Deploy

- [ ] El sitio carga correctamente
- [ ] Los estilos se aplican (no texto plano)
- [ ] JavaScript funciona (formulario responde)
- [ ] Modal de resultados funciona
- [ ] Modo demo funciona si API no responde

### 3. Troubleshooting Común

**Problema**: El sitio muestra texto plano sin estilos
**Solución**: Verifica que `styles.css` esté en la misma carpeta que `index.html`

**Problema**: JavaScript no funciona
**Solución**: Abre DevTools (F12) → Console y busca errores

**Problema**: 404 en GitHub Pages
**Solución**: Verifica que `index.html` esté en la raíz del repositorio

**Problema**: Changes no se reflejan
**Solución**: GitHub Pages puede tardar hasta 10 minutos en actualizar

## 🎯 Resultado Final

Una vez completado, tendrás:

- ✅ **Sitio web público** en `https://tu-usuario.github.io/repo-name`
- ✅ **Deploy automático** cada vez que actualices el código
- ✅ **HTTPS gratuito** y seguro
- ✅ **CDN global** (sitio rápido en todo el mundo)
- ✅ **Backup en GitHub** de todo tu código

## 📞 Ayuda Adicional

Si tienes problemas:

1. **GitHub Docs**: [docs.github.com/pages](https://docs.github.com/pages)
2. **Video Tutorial**: Busca "GitHub Pages tutorial" en YouTube
3. **Comunidad**: [GitHub Community](https://github.community)

¡Tu frontend estará disponible para todo el mundo! 🌍
