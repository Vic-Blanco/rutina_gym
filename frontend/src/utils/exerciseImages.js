/**
 * Mapeo de grupos musculares y nombres de ejercicio a imágenes
 */

export const getExerciseImage = (ejercicio) => {
  const nombre = ejercicio.nombre ? ejercicio.nombre.toLowerCase() : '';
  const grupo = ejercicio.grupoMuscular ? ejercicio.grupoMuscular.toLowerCase() : '';
  
  // Mapeo por nombre exacto
  const imagenesNombre = {
    'press de banca': '/exercises/pecho.svg',
    'press inclinado': '/exercises/pecho.svg',
    'aperturas': '/exercises/pecho.svg',
    'flexiones': '/exercises/pecho.svg',
    
    'dominadas': '/exercises/espalda.svg',
    'jalón lateral': '/exercises/espalda.svg',
    'remo con mancuerna': '/exercises/espalda.svg',
    'remo horizontal': '/exercises/espalda.svg',
    
    'press de hombros': '/exercises/hombros.svg',
    'elevaciones laterales': '/exercises/hombros.svg',
    'pájaros': '/exercises/hombros.svg',
    'press arnold': '/exercises/hombros.svg',
    
    'curl de barra': '/exercises/biceps.svg',
    'curl de mancuerna': '/exercises/biceps.svg',
    'curl concentrado': '/exercises/biceps.svg',
    'curl predicador': '/exercises/biceps.svg',
    
    'extensión de cuerda': '/exercises/triceps.svg',
    'press de brazos': '/exercises/triceps.svg',
    'flexiones cerradas': '/exercises/triceps.svg',
    'barras paralelas': '/exercises/triceps.svg',
    
    'sentadilla': '/exercises/piernas.svg',
    'peso muerto': '/exercises/piernas.svg',
    'prensa de piernas': '/exercises/piernas.svg',
    'extensión de piernas': '/exercises/piernas.svg',
    
    'planchas': '/exercises/core.svg',
    'crunches': '/exercises/core.svg',
    'levantamientos de piernas': '/exercises/core.svg',
    'abdominales': '/exercises/core.svg',
  };
  
  // Buscar por nombre exacto
  if (imagenesNombre[nombre]) {
    return imagenesNombre[nombre];
  }
  
  // Mapeo por grupo muscular
  const imagenesPorGrupo = {
    'pecho': '/exercises/pecho.svg',
    'espalda': '/exercises/espalda.svg',
    'hombros': '/exercises/hombros.svg',
    'biceps': '/exercises/biceps.svg',
    'triceps': '/exercises/triceps.svg',
    'piernas': '/exercises/piernas.svg',
    'core': '/exercises/core.svg',
    'cardio': '/exercises/cardio.svg',
    'brazos': '/exercises/brazos.svg',
  };
  
  // Buscar por grupo muscular
  if (imagenesPorGrupo[grupo]) {
    return imagenesPorGrupo[grupo];
  }
  
  // Por defecto, retornar pecho
  return '/exercises/pecho.svg';
};

export const ejercicioImagenes = {
  PECHO: '/exercises/pecho.svg',
  ESPALDA: '/exercises/espalda.svg',
  HOMBROS: '/exercises/hombros.svg',
  BICEPS: '/exercises/biceps.svg',
  TRICEPS: '/exercises/triceps.svg',
  PIERNAS: '/exercises/piernas.svg',
  CORE: '/exercises/core.svg',
  CARDIO: '/exercises/cardio.svg',
  BRAZOS: '/exercises/brazos.svg',
};
