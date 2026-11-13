# 🏛️ OCJ - Sistema Integral de Gestión

**Oratorio Centro Juvenil Sagrado Corazón de Jesús**  
Villa Juana - Obra Salesiana de Villa Juana

Plataforma de gestión documental, administrativa y pastoral con frontend, backend, base de datos persistente, autenticación, gestión de permisos y acceso multidispositivo.

---

## 📁 Estructura del Proyecto

```
OCJ/
├── docker-compose.yml          # Orquestación: PostgreSQL + Backend + Frontend
├── README.md                   # Este archivo
├── ARCHITECTURE.md             # Arquitectura y decisiones de diseño
├── SETUP.md                    # Guía de instalación y despliegue
├── backend/                    # API NestJS + TypeORM + PostgreSQL
│   ├── Dockerfile
│   ├── package.json
│   ├── tsconfig.json
│   ├── nest-cli.json
│   ├── .env.example
│   ├── prisma/schema.prisma    # Modelo de datos
│   └── src/
│       ├── main.ts
│       ├── app.module.ts
│       ├── auth/               # Autenticación JWT + roles
│       ├── users/              # Gestión de usuarios
│       ├── documents/          # Gestión documental
│       ├── audit/              # Registro de auditoría
│       ├── assistance/         # Registro de asistencia
│       └── common/
└── frontend/                   # React + Vite + TypeScript + Tailwind
    ├── Dockerfile
    ├── nginx.conf
    ├── package.json
    ├── vite.config.ts
    ├── tailwind.config.js
    ├── index.html
    ├── .env
    └── src/
        ├── main.tsx
        ├── App.tsx
        ├── index.css
        ├── lib/api.ts          # Cliente Axios con interceptores
        ├── lib/auth.ts         # Helpers de autenticación (localStorage)
        ├── types/index.ts      # Tipos TypeScript
        ├── components/         # Navbar, Layout, ProtectedRoute, Dashboard stats
        └── pages/              # Login, Dashboard, Documents, Users, Assistance, Audit
```

---

## 🚀 Inicio rápido (Desarrollo local)

### Requisitos
- [Docker](https://www.docker.com/products/docker-desktop) y Docker Compose
- Node.js 20+ (para desarrollo sin Docker)

### 1. Clonar/abrir el proyecto
```powershell
cd "C:\Users\ceped\Desktop\OCJ"
```

### 2. Configurar variables de entorno
```powershell
# Backend
Copy-Item backend\.env.example backend\.env

# Frontend
New-Item frontend\.env -Value "VITE_API_URL=http://localhost:3001"
```

### 3. Levantar todo con Docker Compose
```powershell
docker-compose up --build
```

Esto iniciará:
- **PostgreSQL** en `localhost:5432`
- **Backend (NestJS)** en `http://localhost:3001` (API docs en `/api/docs`)
- **Frontend (React)** en `http://localhost:80`

### 4. Acceder al sistema
- Frontend: `http://localhost`
- API Documentación (Swagger): `http://localhost:3001/api/docs`
- pgAdmin (opcional): configurar en docker-compose si se desea

---

## 👥 Roles y Permisos

| Rol | Puede subir documentos | Puede ver usuarios | Puede ver auditoría | Puede registrar asistencia |
|-----|----------------------|-------------------|--------------------|---------------------------|
| **Secretaria** | ✅ | ✅ | ✅ | ✅ |
| **Asesor** | ✅ | ✅ | ✅ | ✅ |
| **Animador** | ❌ | ❌ | ❌ | ✅ |

---

## 🛠️ Módulos implementados

1. **Auth** - Login/registro con JWT, hash de contraseñas (bcrypt), roles
2. **Users** - CRUD de usuarios, activación/desactivación, asignación de roles
3. **Documents** - Subida de archivos, metadatos, descarga, eliminación, categorías
4. **Audit** - Registro de todas las acciones (quién, qué, cuándo, IP)
5. **Assistance** - Registro de actividades y asistencia pastoral

---

## 🔒 Seguridad

- Contraseñas hasheadas con bcrypt (10 rondas)
- Autenticación JWT con expiración configurable
- Guard de roles para protección de rutas
- Validación de datos con class-validator (backend)
- CORS configurado
- HTTPS obligatorio en producción
- Base de datos **nunca expuesta directamente a internet**
- Registro de auditoría para trazabilidad

---

## ☁️ Despliegue gratuito (Opciones evaluadas)

| Componente | Opción gratuita recomendada | Costo | Notas |
|------------|---------------------------|-------|-------|
| **Base de datos PostgreSQL** | Railway (trial), Render (free), Supabase (free), Neon (free) | $0 | Free tiers con límites de almacenamiento y horas activo |
| **Backend (Node.js)** | Render (web service free), Koyeb (free), Railway (trial) | $0 | Se duerme tras inactividad en free tier |
| **Frontend (React)** | Vercel (hobby), Netlify (free), GitHub Pages | $0 | Despliegue estático, CDN incluido |
| **Almacenamiento de archivos** | Sistema de archivos local (Docker volume), Cloudflare R2 (free tier) | $0 | Para producción usar S3-compatible con ciclo de vida |

**Recomendación para inicio:** Ejecutar todo en un servidor propio o VPS económico con Docker Compose. Esto mantiene el control total, sin costos mensuales de SaaS, y permite migrar de proveedor sin reescribir el sistema.

---

## 📋 Próximos pasos sugeridos

1. Configurar CI/CD (GitHub Actions) para builds automáticos
2. Agregar PWA (service worker, manifest.json) para instalación en dispositivos
3. Configurar copias de seguridad automáticas del volumen PostgreSQL
4. Implementar cifrado de archivos en reposo (AES-256)
5. Agregar notificaciones por correo electrónico (nodemailer + servicio gratuito)

---

**Desarrollado para la Obra Salesiana de Villa Juana - Centro Juvenil Sagrado Corazón de Jesús**