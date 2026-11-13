# 🏗️ Arquitectura del Sistema OCJ

## 1. Visión general

Arquitectura centralizada cliente-servidor con tres capas:

```
┌─────────────┐      HTTPS/JWT      ┌──────────────────┐      TCP/5432      ┌─────────────┐
│   Frontend  │ ◄─────────────────► │    Backend       │ ◄─────────────────► │ PostgreSQL  │
│  React +    │      (puerto 80)    │   NestJS +       │      (privada)      │   15        │
│  Vite +     │                     │   TypeORM +      │                     │             │
│  Tailwind   │                     │   Prisma + JWT   │                     │             │
└─────────────┘                     └──────────────────┘                     └─────────────┘
  Puerto 80                             Puerto 3001
```

**Principio clave:** Toda la información centraliza en el servidor. No hay bases de datos locales en cada computadora.

## 2. Capa de datos (PostgreSQL)

- Motor: PostgreSQL 15 (imagen Alpine ligera)
- ORM/ODM: TypeORM (entidades) + Prisma (migraciones y schema fuente de verdad)
- Migraciones versionadas con Prisma Migrate
- Integridad referencial con claves foráneas y `ON DELETE CASCADE/SET NULL`
- Índices implícitos en claves primarias y únicas

### Tablas principales

| Tabla | Descripción |
|-------|-------------|
| `roles` | Secretaria, Asesor, Animador |
| `users` | Usuarios del sistema con rol asignado |
| `document_categories` | Categorías de documentos |
| `documents` | Metadatos de documentos (ruta física separada) |
| `audit_logs` | Registro de todas las acciones |
| `assistance_logs` | Registro de asistencia y actividades |

## 3. Capa de aplicación (Backend NestJS)

- Framework: NestJS (modular, inyección de dependencias)
- Autenticación: JWT (passport-jwt)
- Validación: class-validator + class-transformer
- Documentación API: Swagger/OpenAPI en `/api/docs`
- Manejo de archivos: Multer (almacenamiento local en `/uploads`)
- Filtro de excepciones global para logging de errores

### Módulos

| Módulo | Responsabilidad |
|--------|-----------------|
| `Auth` | Login, registro, validación de tokens, perfil |
| `Users` | CRUD de usuarios, cambio de estado (activo/inactivo) |
| `Documents` | Subida, descarga, listado, eliminación de documentos |
| `Audit` | Log de acciones (quién, qué entidad, cuándo, IP) |
| `Assistance` | Registro de actividades pastorales y asistencia |

## 4. Capa de presentación (Frontend)

- React 18 + TypeScript + Vite
- Estilos: Tailwind CSS con paleta institucional Salesiana
- Enrutamiento: React Router DOM (6)
- Cliente HTTP: Axios con interceptores (token automático, redirect en 401)
- Gestión de sesión: localStorage (token + datos de usuario)
- Rutas protegidas con `ProtectedRoute`
- Diseño responsive (mobile-first)

### Páginas

| Ruta | Componente | Rol mínimo |
|------|------------|------------|
| `/login` | Login | Público |
| `/dashboard` | Dashboard | Autenticado |
| `/documentos` | Documents | Animador+ |
| `/usuarios` | Users | Secretaria/Asesor |
| `/asistencia` | Assistance | Animador+ |
| `/auditoria` | Audit | Secretaria |

## 5. Seguridad

- **En tránsito:** HTTPS obligatorio (TLS 1.2+), en desarrollo se usa HTTP local
- **En reposo:** Contraseñas hasheadas con bcrypt (10 rondas)
- **Tokens:** JWT firmado con secreto fuerte, expiración 7d (configurable)
- **Acceso a BD:** Nunca expuesta a internet, solo accesible desde el backend
- **Archivos:** Servidos solo a través del backend con autenticación
- **Auditoría:** Toda acción write/delete queda registrada con IP y usuario
- **Variables de entorno:** Secretos en `.env`, nunca en el código

## 6. Infraestructura y despliegue

- Docker Compose para orquestación local y de producción
- Volumen Docker para datos de PostgreSQL (`ocj_postgres_data`)
- Volumen Docker para archivos subidos (`./backend/uploads`)
- Variables de entorno para configuración por entorno (dev/prod)
- Backend y frontend contenedorizados independientemente

### Opciones gratuitas de alojamiento

| Capa | Proveedor gratuito | Limitaciones |
|------|-------------------|--------------|
| Base de datos | Supabase Free, Neon Free, Render Free | 500MB-1GB, pausa por inactividad |
| Backend | Render Free, Koyeb Free | 512MB RAM, se duerme tras inactividad |
| Frontend | Vercel Hobby, Netlify Free, GitHub Pages | Ancho de banda limitado |
| Almacenamiento | Cloudflare R2 Free (10GB) | S3-compatible, sin cargos de salida |

**Recomendación:** Para el Centro Juvenil, desplegar en un servidor local o VPS económico con Docker Compose ofrece el mejor balance costo/control/privacidad.

## 7. Mantenibilidad y migración

- Código separado por capas (controlador → servicio → entidad)
- Proveedores de infraestructura abstraídos mediante variables de entorno
- Modelo de datos en Prisma (fácil migrar a otro proveedor SQL)
- Almacenamiento de archivos local, fácilmente movible a S3/R2 cambiando el servicio de documentos

---