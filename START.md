# 🚀 COMIENZA AQUÍ - Rutina Gym

## ⚡ Opción Rápida: Docker (RECOMENDADO)

Si solo quieres probar la aplicación sin instalar nada en tu PC:

### Windows
```powershell
# 1. Abre PowerShell en esta carpeta
# 2. Ejecuta:
.\docker-manage.ps1 start

# 3. Abre en tu navegador:
# http://localhost:3000
```

### Mac/Linux
```bash
# 1. Abre terminal en esta carpeta
# 2. Ejecuta:
docker-compose up -d

# 3. Abre en tu navegador:
# http://localhost:3000
```

---

## 📋 Requisitos

✅ **Docker Desktop** instalado (descárgalo [aquí](https://www.docker.com/products/docker-desktop))

¡Eso es todo! Docker se encarga de todo lo demás.

---

## 🎯 Crear una rutina

1. **Regístrate:**
   - Email: `test@example.com`
   - Nombre: `Tu nombre`
   - Género: Selecciona
   - Contraseña: `123456`

2. **Genera una rutina:**
   - Click en "Generar Rutina"
   - Elige nombre, nivel, días y grupos musculares
   - ¡Listo! Se genera automáticamente

---

## 🛠️ Comandos Docker útiles

```powershell
# Ver logs en tiempo real
.\docker-manage.ps1 logs-backend

# Ver estado
.\docker-manage.ps1 status

# Parar
.\docker-manage.ps1 stop

# Reiniciar
.\docker-manage.ps1 restart

# Limpiar todo
.\docker-manage.ps1 clean
```

---

## 🔗 URLs después de ejecutar

| Servicio | URL |
|----------|-----|
| **Aplicación Web** | http://localhost:3000 |
| **API Backend** | http://localhost:8080/api |
| **Base de Datos** | localhost:5432 |

---

## 📖 Más información

- Ver más detalles: [DOCKER_QUICK.md](DOCKER_QUICK.md)
- Resolver problemas: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- Entender el proyecto: [README.md](README.md)
- Explorar API: [API_EXAMPLES.md](API_EXAMPLES.md)

---

## ❓ Problemas?

### "Docker no está instalado"
→ Descarga [Docker Desktop](https://www.docker.com/products/docker-desktop)

### "Port 3000/8080 already in use"
→ Cambia los puertos en `docker-compose.yml`

### "Connection refused"
→ Espera 30 segundos a que los contenedores inicien completamente

### Más ayuda
→ Lee [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

**¡A crear rutinas! 💪**
