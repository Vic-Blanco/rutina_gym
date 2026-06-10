# 🐛 Troubleshooting - Rutina Gym

## Problemas Comunes y Soluciones

---

## 🔴 Backend (Java/Spring Boot)

### Error: "Connection refused" en PostgreSQL

```
Exception: org.postgresql.util.PSQLException: 
Connection to localhost:5432 refused
```

**Solución:**
```bash
# Verificar que PostgreSQL está corriendo
# Windows
net start PostgreSQL14

# macOS
brew services start postgresql

# Linux
sudo systemctl start postgresql

# Verificar conexión
psql -U rutina_user -d rutina_gym_db
```

---

### Error: "Port 8080 already in use"

```
java.net.BindException: Address already in use
```

**Soluciones:**

**Opción 1:** Cambiar puerto en `application.yml`
```yaml
server:
  port: 8081
```

**Opción 2:** Matar proceso en puerto 8080
```bash
# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# Mac/Linux
lsof -i :8080
kill -9 <PID>
```

---

### Error: "Prolog library not found"

```
java.lang.UnsatisfiedLinkError: no jpl in java.library.path
```

**Solución:**

1. Instalar SWI-Prolog
```bash
# Windows: Descargar desde swi-prolog.org
# Mac
brew install swi-prolog

# Linux
sudo apt-get install swi-prolog
```

2. Configurar variable de entorno:
```bash
# Windows
set SWI_PROLOG=C:\Program Files\swipl

# Mac/Linux
export SWI_PROLOG=/usr/lib/swi-prolog
```

---

### Error: "No suitable constructor found for Genero"

```
Exception in thread "main" 
org.springframework.beans.factory.UnsatisfiedDependencyException
```

**Solución:**
- Verificar que los enums estén correctamente definidos
- Usar `@Enumerated(EnumType.STRING)` en las entidades
- Reiniciar el servidor

---

### Error: "Cannot load MySQL driver"

```
java.sql.SQLException: No suitable driver found
```

**Solución:**
- Verificar que el driver PostgreSQL está en `pom.xml`
- Ejecutar `mvn clean install`
- Verificar que `application.yml` usa PostgreSQL (no MySQL)

---

### Error: "Hibernate dialect not recognized"

```
Exception: The Hibernate dialect must be explicitly specified
```

**Solución:**
```yaml
spring:
  jpa:
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
```

---

## 🟠 Frontend (React)

### Error: "Cannot find module"

```
Error: Module not found: Can't resolve 'axios'
```

**Solución:**
```bash
cd frontend
npm install axios
# O reinstalar todo
npm install
```

---

### Error: "CORS error"

```
Access to XMLHttpRequest blocked by CORS policy
```

**Solución en Backend:**

Agregar `@CrossOrigin` al controlador:
```java
@RestController
@RequestMapping("/v1/rutinas")
@CrossOrigin(origins = "*", maxAge = 3600)
public class RutinaController {
```

---

### Error: "Failed to compile"

```
SyntaxError: Unexpected token
```

**Solución:**
```bash
# Limpiar cache
npm cache clean --force

# Reinstalar dependencias
rm -rf node_modules package-lock.json
npm install

# Compilar nuevamente
npm start
```

---

### Error: "Port 3000 already in use"

```
Something is already running on port 3000
```

**Solución:**
```bash
# Cambiar puerto
PORT=3001 npm start

# O matar proceso
# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Mac/Linux
lsof -i :3000
kill -9 <PID>
```

---

### Error: "Cannot read property 'map' of undefined"

```
TypeError: Cannot read property 'map' of undefined
```

**Solución:**
- Verificar que la respuesta de API tiene estructura correcta
- Agregar validación antes de usar `.map()`
```javascript
{rutinas && rutinas.length > 0 ? (
  rutinas.map(r => ...)
) : (
  <p>No hay rutinas</p>
)}
```

---

### Error: "Blank page in frontend"

**Solución:**
1. Abrir Developer Tools (F12)
2. Revisar Console para errores
3. Revisar Network para fallos de API
4. Verificar que backend está corriendo
5. Verificar URL en `api.js` apunta a `http://localhost:8080/api`

---

## 🟡 Base de Datos

### Error: "Connection timeout"

```
PSQLException: Connection attempt timed out
```

**Solución:**
```bash
# Verificar que la BD está corriendo
psql -U postgres

# Crear BD si no existe
CREATE DATABASE rutina_gym_db;

# Crear usuario si no existe
CREATE USER rutina_user WITH PASSWORD 'rutina_pass';
GRANT ALL PRIVILEGES ON DATABASE rutina_gym_db TO rutina_user;
```

---

### Error: "Role already exists"

```
ERROR: role "rutina_user" already exists
```

**Solución:**
```sql
-- Opción 1: Dropear rol existente
DROP ROLE rutina_user;
CREATE USER rutina_user WITH PASSWORD 'rutina_pass';

-- Opción 2: Usar rol existente (cambiar contraseña)
ALTER USER rutina_user WITH PASSWORD 'rutina_pass';
```

---

### Error: "Database already exists"

```
ERROR: database "rutina_gym_db" already exists
```

**Solución:**
```bash
# Conectar con usuario postgres
psql -U postgres

# Conectar a la BD existente
\c rutina_gym_db

# Si necesitas recrear
DROP DATABASE rutina_gym_db;
CREATE DATABASE rutina_gym_db;
```

---

### Error: "Permission denied"

```
ERROR: permission denied for schema public
```

**Solución:**
```sql
GRANT USAGE ON SCHEMA public TO rutina_user;
GRANT CREATE ON SCHEMA public TO rutina_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO rutina_user;
```

---

## 🟣 Prolog

### Error: "consult failed"

```
Exception: Goal failed: consult('prolog/ejercicios.pl')
```

**Solución:**
1. Verificar que el archivo existe en `prolog/ejercicios.pl`
2. Verificar sintaxis Prolog:
```bash
swipl
?- consult('prolog/ejercicios.pl').
```
3. Cambiar ruta en `PrologService.java` si es necesario

---

### Error: "Variable not found"

```
Exception: Variable 'X' not found in query
```

**Solución:**
- Verificar que las variables comienzan con mayúscula
- Verificar sintaxis de la consulta
- Revisar predicados disponibles

---

### Error: "Stack overflow"

```
Exception: Stack overflow in Prolog query
```

**Solución:**
- Revisar reglas recursivas infinitas
- Agregar cortes (`!`) para evitar backtracking innecesario
- Limitar profundidad de búsqueda

---

## 🔵 Docker

### Error: "Cannot connect to Docker daemon"

```
Cannot connect to Docker daemon at unix:///var/run/docker.sock
```

**Solución:**
```bash
# Iniciar Docker
# Windows/Mac: Abrir Docker Desktop

# Linux
sudo systemctl start docker
```

---

### Error: "Port already allocated"

```
Error response from daemon: driver failed programming external connectivity on endpoint
```

**Solución:**
```bash
# Parar contenedores existentes
docker-compose down

# Eliminar volúmenes
docker-compose down -v

# Reiniciar
docker-compose up -d
```

---

## 📋 Checklist de Debugging

```
[ ] ¿PostgreSQL está corriendo?
[ ] ¿Puerto 5432 es accesible?
[ ] ¿Base de datos existe?
[ ] ¿Usuario tiene permisos?
[ ] ¿Backend compila sin errores?
[ ] ¿Backend está en puerto 8080?
[ ] ¿Archivo Prolog existe?
[ ] ¿SWI-Prolog está instalado?
[ ] ¿Frontend tiene node_modules?
[ ] ¿Frontend conecta a backend?
[ ] ¿CORS está habilitado?
[ ] ¿Credenciales son correctas?
```

---

## 🛠️ Comandos Útiles

### Maven
```bash
mvn clean              # Limpiar proyecto
mvn compile            # Compilar
mvn install            # Instalar
mvn test              # Ejecutar tests
mvn spring-boot:run   # Ejecutar aplicación
```

### NPM
```bash
npm install            # Instalar dependencias
npm start              # Iniciar desarrollo
npm build              # Crear build
npm test               # Ejecutar tests
npm cache clean --force # Limpiar cache
```

### PostgreSQL
```bash
psql -U postgres       # Conectar
\l                     # Listar bases de datos
\c nombre_db           # Conectar a BD
\dt                    # Listar tablas
\du                    # Listar usuarios
SELECT * FROM usuarios; -- Ver datos
```

### Docker
```bash
docker ps              # Ver contenedores activos
docker logs <id>       # Ver logs
docker-compose up -d   # Iniciar en background
docker-compose down    # Parar
docker-compose logs -f # Ver logs en tiempo real
```

---

## 📞 Escalada

Si el problema persiste después de intentar soluciones:

1. **Verificar logs:**
   ```bash
   # Backend
   tail -f backend/logs/app.log
   
   # Frontend
   npm start 2>&1 | tee frontend.log
   ```

2. **Revisar configuración:**
   - `backend/src/main/resources/application.yml`
   - `frontend/src/api/api.js`
   - `prolog/ejercicios.pl`

3. **Consultar documentación:**
   - README.md
   - PROLOG_GUIDE.md
   - DATABASE_SETUP.md

4. **Reiniciar todo:**
   ```bash
   # Backend
   mvn clean install
   mvn spring-boot:run
   
   # Frontend
   npm install
   npm start
   ```

---

## 🚀 Modo Debug

### Java
```bash
# Ejecutar con debug
mvn spring-boot:run -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"
```

### React
```bash
# Ejecutar con debug
npm start
# Abrir DevTools (F12)
```

### PostgreSQL
```bash
# Ver queries ejecutadas
SET log_statement = 'all';
SET log_duration = on;
```

---

**¿Aún hay problemas? Revisa los logs, verifica la configuración, y reinicia los servicios. 💪**
