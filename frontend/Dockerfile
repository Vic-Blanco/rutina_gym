# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copiar package.json
COPY package.json ./

# Instalar dependencias
RUN npm install

# Copiar código fuente
COPY public ./public
COPY src ./src

# Construir aplicación
RUN npm run build

# Production stage
FROM node:18-alpine

WORKDIR /app

# Instalar serve para servir archivos estáticos
RUN npm install -g serve

# Copiar build desde stage anterior
COPY --from=builder /app/build ./build

# Exponer puerto
EXPOSE 3000

# Variables de entorno
ENV REACT_APP_API_URL=http://localhost:8080/api

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Servir aplicación
CMD ["serve", "-s", "build", "-l", "3000"]
