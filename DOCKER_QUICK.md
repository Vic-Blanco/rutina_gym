# 🐳 Rutina Gym - Guía Docker

## Inicio Rápido con Docker (3 pasos)

### 1️⃣ Instala Docker

**Windows/Mac:** 
- Descarga [Docker Desktop](https://www.docker.com/products/docker-desktop)
- Ejecuta el instalador

**Linux:**
```bash
sudo apt-get install docker.io docker-compose
```

### 2️⃣ Ejecuta la aplicación

```bash
# Desde la carpeta del proyecto
cd d:\Downloads\rutina_gym

# Construir e iniciar todos los servicios
docker-compose up -d

# Ver logs (opcional)
docker-compose logs -f
```

### 3️⃣ Accede a la aplicación

- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:8080/api
- **Base de datos:** localhost:5432

---

## Servicios que se ejecutan

| Servicio | Puerto | URL |
|----------|--------|-----|
| **PostgreSQL** | 5432 | localhost:5432 |
| **Backend** | 8080 | http://localhost:8080/api |
| **Frontend** | 3000 | http://localhost:3000 |

---

## Comandos Útiles

### Ver estado de contenedores
```bash
docker ps
```

### Ver logs
```bash
# Todos
docker-compose logs -f

# Solo backend
docker-compose logs -f backend

# Solo frontend
docker-compose logs -f frontend

# Solo BD
docker-compose logs -f postgres
```

### Parar todo
```bash
docker-compose down
```

### Parar y eliminar datos
```bash
docker-compose down -v
```

### Reiniciar un servicio
```bash
docker-compose restart backend
```

### Reconstruir imágenes
```bash
docker-compose up -d --build
```

---

## Datos de prueba

### Crear usuario:
```
Email: test@example.com
Nombre: Juan
Género: Masculino
Contraseña: 123456
```

### Generar rutina:
```
Nombre: Mi primera rutina
Nivel: Inicial
Días: 3
Grupos: Selecciona los que prefieras
```

---

## Solución de problemas

### Error: "Docker daemon not running"
```bash
# Windows/Mac: Abre Docker Desktop
# Linux: Inicia Docker
sudo systemctl start docker
```

### Puerto ya está en uso
```bash
# Cambiar puertos en docker-compose.yml
ports:
  - "3001:3000"    # Frontend en 3001
  - "8081:8080"    # Backend en 8081
```

### Limpiar todo y empezar de cero
```bash
docker-compose down -v
docker-compose up -d --build
```

---

## ✅ Checklist

- [ ] Docker Desktop instalado
- [ ] `cd d:\Downloads\rutina_gym`
- [ ] `docker-compose up -d`
- [ ] Espera 30 segundos a que todo inicie
- [ ] Abre http://localhost:3000
- [ ] Crea una cuenta
- [ ] Genera tu primera rutina

---

**¡Eso es todo! Tu aplicación está corriendo completamente en Docker. 🚀**
