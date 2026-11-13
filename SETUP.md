# ⚙️ Guía de Instalación y Despliegue

## Opción A: Docker Compose (Recomendada)

### 1. Prerrequisitos
Instalar [Docker Desktop](https://www.docker.com/products/docker-desktop) para Windows.

### 2. Variables de entorno
```powershell
cd "C:\Users\ceped\Desktop\OCJ"
Copy-Item backend\.env.example backend\.env
# Editar backend\.env si es necesario
New-Item frontend\.env -Value "VITE_API_URL=http://localhost:3001"
```

### 3. Levantar servicios
```powershell
docker-compose up --build -d
```

### 4. Verificar estado
```powershell
docker-compose ps
```

### 5. Acceder
- Aplicación: `http://localhost`
- API Docs: `http://localhost:3001/api/docs`
- Base de datos: `localhost:5432` (usuario: `ocj_admin`, contraseña: `ocj_password_2026`)

### 6. Detener
```powershell
docker-compose down
```

---

## Opción B: Desarrollo local sin Docker

### Backend
```powershell
cd "C:\Users\ceped\Desktop\OCJ\backend"
npm install
npx prisma generate
npx prisma migrate dev --name init
npm run start:dev
```

### Frontend
```powershell
cd "C:\Users\ceped\Desktop\OCJ\frontend"
npm install
npm run dev
```

---

## 🌐 Despliegue en producción (gratuito / bajo costo)

### Paso 1: Servidor o VPS
Contratar un VPS económico (ej. DigitalOcean, Hetzner, Oracle Cloud Free Tier) con Ubuntu y Docker instalado.

### Paso 2: Variables de entorno de producción
Editar `backend/.env`:
```
NODE_ENV=production
DATABASE_URL="postgresql://usuario:contraseña@host:5432/db"
JWT_SECRET="secreto-muy-seguro-y-largo"
```

### Paso 3: HTTPS
Configurar un reverse proxy (Nginx o Traefik) con certificados SSL gratuitos de [Let's Encrypt](https://letsencrypt.org/) vía Certbot.

### Paso 4: Dominio institucional
Configurar el dominio (ej. `ocjvillajuana.org`) apuntando a la IP del servidor.

### Paso 5: Copias de seguridad
Configurar un cron job para hacer backup del volumen PostgreSQL:
```bash
docker exec ocj_postgres pg_dump -U ocj_admin ocj_db > backup_$(date +%F).sql
```

---

## 📱 Acceso multidispositivo

Una vez desplegado en un servidor con dominio y HTTPS, cualquier computadora autorizada puede acceder mediante el navegador usando la misma URL y las mismas credenciales. No se instala nada en las computadoras clientes.

Para usar como PWA (instalable), agregar `manifest.json` y service worker al frontend (pendiente en esta versión inicial).

---

## ✅ Lista de verificación post-instalación

- [ ] Docker Compose levanta sin errores
- [ ] Se puede acceder a `http://localhost`
- [ ] Se puede hacer login con un usuario creado
- [ ] Se puede subir un documento y descargarlo
- [ ] Los registros de auditoría se generan al hacer acciones
- [ ] Los roles restringen el acceso correctamente (ej. Animador no ve /usuarios)

---

**Soporte:** Para dudas sobre la arquitectura o despliegue, revisar `ARCHITECTURE.md`.