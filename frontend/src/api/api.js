import axios from 'axios';

const API_URL = 'http://localhost:8080/api';

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Usuarios
export const registro = (usuarioData) => {
  return api.post('/v1/usuarios/registro', {
    email: usuarioData.email,
    nombre: usuarioData.nombre,
    password: usuarioData.password,
    nivel: usuarioData.nivel,
    objetivo: usuarioData.objetivo,
    diasDisponibles: usuarioData.diasDisponibles,
    gruposMusculares: usuarioData.gruposMusculares,
    grupoPrioritario: usuarioData.grupoPrioritario,
  });
};

export const login = (email, password) => {
  return api.post('/v1/usuarios/login', {
    email,
    password,
  });
};

export const obtenerPerfil = (usuarioId) => {
  return api.get(`/v1/usuarios/${usuarioId}`);
};

// Rutinas
export const generarRutina = (rutinaData) => {
  return api.post('/v1/rutinas/generar', {
    nombre: rutinaData.nombre,
    objetivo: rutinaData.objetivo,
    diasDisponibles: rutinaData.diasDisponibles,
    gruposMusculares: rutinaData.gruposMusculares,
    grupoPrioritario: rutinaData.grupoPrioritario,
  });
};

// NUEVOS ENDPOINTS BASADOS EN PROLOG

/**
 * Obtiene ejercicios recomendados por grupo muscular
 */
export const obtenerEjerciciosPorGrupo = (grupoMuscular, nivel = 'INTERMEDIO') => {
  return api.get(`/v1/rutinas/ejercicios/${grupoMuscular}`, {
    params: { nivel }
  });
};

/**
 * Valida una rutina generada
 */
export const validarRutina = (rutina) => {
  return api.post('/v1/rutinas/validar', rutina);
};

/**
 * Obtiene explicación del sistema experto sobre una rutina
 */
export const explicarRutina = (objetivo, diasDisponibles) => {
  return api.post('/v1/rutinas/explicacion', {
    objetivo,
    diasDisponibles,
  });
};

/**
 * Obtiene información del sistema experto Prolog
 */
export const obtenerInfoSistema = () => {
  return api.get('/v1/rutinas/info');
};

export const obtenerRutinasUsuario = (usuarioId) => {
  return api.get(`/v1/rutinas/usuario/${usuarioId}`);
};

export const obtenerRutina = (rutinaId) => {
  return api.get(`/v1/rutinas/${rutinaId}`);
};

export const eliminarRutina = (rutinaId) => {
  return api.delete(`/v1/rutinas/${rutinaId}`);
};

export default api;
