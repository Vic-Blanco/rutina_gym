# 🚀 Inicio Rápido - Rutina Gym

## Instalación en 5 minutos

### Paso 1: Preparar Base de Datos

```bash
# Windows - Abrir PowerShell como administrador
psql -U postgres

# SQL a ejecutar:
CREATE DATABASE rutina_gym_db WITH ENCODING 'UTF8';
CREATE USER rutina_user WITH PASSWORD 'rutina_pass';
GRANT ALL PRIVILEGES ON DATABASE rutina_gym_db TO rutina_user;
\q
```

**⏱️ Tiempo: 1 minuto**

### Paso 2: Ejecutar Backend

```bash
cd backend
mvn clean install
mvn spring-boot:run
```

✅ Backend listo cuando veas: `Started RutinaGymApplication`

**⏱️ Tiempo: 2-3 minutos**

### Paso 3: Ejecutar Frontend

```bash
cd frontend
npm install
npm start
```

✅ Frontend abierto automáticamente en `http://localhost:3000`

**⏱️ Tiempo: 1-2 minutos**

---

## 🎮 Prueba Rápida

### 1. Crear Cuenta
- Email: `test@example.com`
- Nombre: `Test User`
- Contraseña: `test123`
- Género: Masculino/Femenino

### 2. Generar Rutina
- Nombre: "Mi Primera Rutina"
- Nivel: **Inicial**
- Días: **3**
- Grupos: Pecho, Espalda, Piernas

### 3. Visualizar
- Haz clic en "Ver Detalles"
- ¡Observa cómo OOP + Prolog generaron tu rutina! 💪

---

## 🛠️ Verificación

### Backend está corriendo?
```bash
curl http://localhost:8080/api/v1/usuarios/1
```

### Frontend está corriendo?
Navega a `http://localhost:3000`

### Base de datos está conectada?
En el backend verás: `Hibernate: create table usuarios`

---

## 📝 Credenciales de Prueba

| Servicio | Usuario | Contraseña |
|----------|---------|-----------|
| PostgreSQL | rutina_user | rutina_pass |
| Aplicación | test@example.com | test123 |

---

## 🚨 Errores Comunes

### ❌ "Connection refused" en PostgreSQL
```bash
# Verificar que PostgreSQL está corriendo
net start PostgreSQL14  # Windows
# o
brew services start postgresql@14  # Mac
```

### ❌ "Port 8080 already in use"
```bash
# Cambiar puerto en backend/src/main/resources/application.yml
server:
  port: 8081  # Cambiar a otro puerto
```

### ❌ "Cannot find module" en React
```bash
cd frontend
rm -rf node_modules
npm cache clean --force
npm install
```

---

## 📊 Arquitectura en Acción

```
Frontend (React)               Backend (Spring Boot)           Database (PostgreSQL)
┌─────────────────┐           ┌──────────────────┐           ┌────────────────────┐
│  Registro/Login │──────────>│  UsuarioController          │  usuarios          │
│  Generar Rutina │───────┐   │  RutinaController│─────────>│  rutinas           │
│  Ver Rutinas    │       │   │  RutinaService   │          │  dias_entrenamiento│
└─────────────────┘       │   │  PrologService   │          │  ejercicios        │
                          │   │  ╱╲ JPL7/Prolog  │          └────────────────────┘
                          └──>│  ║  ejercicios.pl │
                              └──────────────────┘
```

---

## 🔧 Próximos Pasos

1. **Personalizar ejercicios**: Edita `prolog/ejercicios.pl`
2. **Agregar autenticación JWT**: Implementa en `UsuarioController`
3. **Desplegar en la nube**: Usa Docker o servicio cloud
4. **Mejorar UI**: Añade más gráficos y visualizaciones
5. **Exportar PDF**: Implementa generación de reportes

---

## 💡 Tips

- 🔄 **Auto-recarga**: El frontend se actualiza automáticamente al editar
- 📁 **Logs**: Revisa en `backend/logs` para debugging
- 🎯 **Hot reload**: Usa DevTools de Spring Boot para cambios sin reiniciar
- 📱 **Responsive**: Prueba en mobile con F12 Developer Tools

---

## 📞 Soporte

Si algo no funciona:
1. Verifica los requisitos previos
2. Revisa los logs en terminal
3. Ejecuta `mvn clean install` nuevamente
4. Reinicia todos los servicios

**¡Listo! A crear rutinas con OOP + Prolog! 💪**
