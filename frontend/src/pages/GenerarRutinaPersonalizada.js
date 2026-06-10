import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { obtenerEjerciciosPorGrupo, obtenerInfoSistema } from '../api/api';
import './GenerarRutinaPersonalizada.scss';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080/api';

function GenerarRutinaPersonalizada() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');  const [ejerciciosPorGrupo, setEjerciciosPorGrupo] = useState({});
  const [infoSistema, setInfoSistema] = useState(null);
  const [formData, setFormData] = useState({
    nombre: 'Mi Rutina Personalizada',
    nivel: 'INTERMEDIO',
    objetivo: 'HIPERTROFIA',
    diasDisponibles: 4,
    gruposMusculares: [],
  });

  const niveles = [
    { value: 'INICIAL', label: 'Principiante', desc: 'Menos de 6 meses de experiencia' },
    { value: 'INTERMEDIO', label: 'Intermedio', desc: '6 meses a 2 años' },
    { value: 'AVANZADO', label: 'Avanzado', desc: 'Más de 2 años' },
  ];

  const objetivos = [
    { value: 'HIPERTROFIA', label: '💪 Hipertrofia', desc: 'Ganar masa muscular' },
    { value: 'FUERZA', label: '⚡ Fuerza', desc: 'Aumentar capacidad de levantamiento' },
    { value: 'RESISTENCIA', label: '🏃 Resistencia', desc: 'Mejorar capacidad aeróbica' },
    { value: 'ACONDICIONAMIENTO', label: '🎯 Acondicionamiento', desc: 'Fitness general' },
  ];

  const gruposMusculares = [
    { id: 'PECHO', label: '🏋️ Pecho', icon: '💪' },
    { id: 'ESPALDA', label: '🔙 Espalda', icon: '🔄' },
    { id: 'HOMBROS', label: '🎯 Hombros', icon: '📍' },
    { id: 'BICEPS', label: '💙 Bíceps', icon: '↑' },
    { id: 'TRICEPS', label: '💪 Tríceps', icon: '↓' },
    { id: 'ANTEBRAZO', label: '🔱 Antebrazo', icon: '🖐️' },
    { id: 'CUADRICEPS', label: '🦵 Cuádriceps', icon: '📍' },
    { id: 'ISQUIOTIBIAL', label: '🦵 Isquiotibial', icon: '🔄' },
    { id: 'GLUTEOS', label: '🍑 Glúteos', icon: '⭕' },
    { id: 'PANTORRILLA', label: '🦶 Pantorrilla', icon: '📍' },
    { id: 'CORE', label: '🎯 Core', icon: '⭐' },
    { id: 'CARDIO', label: '❤️ Cardio', icon: '🏃‍♂️' },
  ];

  const toggleGrupo = (grupoId) => {
    setFormData(prev => ({
      ...prev,
      gruposMusculares: prev.gruposMusculares.includes(grupoId)
        ? prev.gruposMusculares.filter(g => g !== grupoId)
        : [...prev.gruposMusculares, grupoId]
    }));
  };

  // Cargar información del sistema experto
  useEffect(() => {
    const cargarInfo = async () => {
      try {
        const response = await obtenerInfoSistema();
        setInfoSistema(response.data);

        // Cargar ejercicios para cada grupo muscular
        const ejerciciosMap = {};
        if (response.data.capacidades?.gruposMusculares) {
          for (const grupo of response.data.capacidades.gruposMusculares) {
            try {
              const ejerciciosResponse = await obtenerEjerciciosPorGrupo(grupo, 'INTERMEDIO');
              ejerciciosMap[grupo] = ejerciciosResponse.data.ejercicios || [];
            } catch (err) {
              ejerciciosMap[grupo] = [];
            }
          }
          setEjerciciosPorGrupo(ejerciciosMap);
        }
      } catch (err) {
        console.log('No se pudo cargar info del sistema');
      }
    };

    cargarInfo();
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (!formData.nombre.trim()) {
      setError('Ingresa un nombre para la rutina');
      return;
    }

    if (formData.gruposMusculares.length === 0) {
      setError('Selecciona al menos un grupo muscular');
      return;
    }

    setLoading(true);

    try {
      const response = await axios.post(`${API_BASE_URL}/v1/rutinas/generar`, {
        nombre: formData.nombre,
        objetivo: formData.objetivo,
        nivel: formData.nivel,
        diasDisponibles: formData.diasDisponibles,
        gruposMusculares: formData.gruposMusculares,
      });

      localStorage.setItem('rutinaActual', JSON.stringify(response.data));
      navigate('/detalle-rutina');
    } catch (err) {
      setError(err.response?.data?.message || 'Error al generar la rutina');
    } finally {
      setLoading(false);
    }
  };

  const gruposSeleccionados = formData.gruposMusculares.length;

  return (
    <div className="generar-personalizada-container">
      <button className="btn-volver" onClick={() => navigate('/generar-rutina')}>
        ← Volver
      </button>

      <div className="container-form">
        <div className="form-header">
          <h1>🎯 Generación Personalizada de Rutina</h1>
          <p>Elige qué grupos musculares entrenar y el sistema distribuye automáticamente</p>
        </div>

        {error && <div className="error-banner">{error}</div>}

        <form onSubmit={handleSubmit} className="personalizada-form">
          {/* NOMBRE */}
          <div className="form-section">
            <label>📝 Nombre de la Rutina</label>
            <input
              type="text"
              value={formData.nombre}
              onChange={(e) => setFormData({ ...formData, nombre: e.target.value })}
              placeholder="Ej: Rutina Power"
              className="input-text"
            />
          </div>

          {/* NIVEL */}
          <div className="form-section">
            <label>🎓 Nivel de Experiencia</label>
            <p className="section-description">Selecciona tu nivel para ejercicios apropiados</p>
            <div className="selector-group">
              {niveles.map(nivel => (
                <button
                  key={nivel.value}
                  type="button"
                  className={`selector-btn ${formData.nivel === nivel.value ? 'active' : ''}`}
                  onClick={() => setFormData({ ...formData, nivel: nivel.value })}
                >
                  <div className="btn-label">{nivel.label}</div>
                  <div className="btn-desc">{nivel.desc}</div>
                </button>
              ))}
            </div>
          </div>

          {/* OBJETIVO */}
          <div className="form-section">
            <label>🎯 Objetivo Principal</label>
            <p className="section-description">Elige tu objetivo para optimizar la rutina</p>
            <div className="selector-group">
              {objetivos.map(objetivo => (
                <button
                  key={objetivo.value}
                  type="button"
                  className={`selector-btn ${formData.objetivo === objetivo.value ? 'active' : ''}`}
                  onClick={() => setFormData({ ...formData, objetivo: objetivo.value })}
                >
                  <div className="btn-label">{objetivo.label}</div>
                  <div className="btn-desc">{objetivo.desc}</div>
                </button>
              ))}
            </div>
          </div>

          {/* DÍAS */}
          <div className="form-section">
            <label>📅 Cantidad de Días Disponibles</label>
            <p className="section-description">Selecciona cuántos días a la semana puedes entrenar</p>
            <div className="dias-selector">
              {[2, 3, 4, 5, 6].map(dia => (
                <button
                  key={dia}
                  type="button"
                  className={`dia-btn ${formData.diasDisponibles === dia ? 'active' : ''}`}
                  onClick={() => setFormData({ ...formData, diasDisponibles: dia })}
                >
                  {dia} días
                </button>
              ))}
            </div>
            <div className="dias-info">
              El sistema distribuirá tus grupos musculares en <strong>{formData.diasDisponibles} días</strong>
            </div>
          </div>

          {/* GRUPOS MUSCULARES */}
          <div className="form-section">
            <label>💪 Selecciona Grupos Musculares a Entrenar</label>
            <p className="section-description">Elige al menos 1 grupo. El sistema los agrupará inteligentemente</p>
            
            <div className="grupos-grid">
              {gruposMusculares.map(grupo => (
                <div
                  key={grupo.id}
                  className={`grupo-card ${formData.gruposMusculares.includes(grupo.id) ? 'selected' : ''}`}
                  onClick={() => toggleGrupo(grupo.id)}
                >
                  <div className="grupo-icon">{grupo.icon}</div>
                  <div className="grupo-label">{grupo.label}</div>
                  {formData.gruposMusculares.includes(grupo.id) && (
                    <div className="checkmark">✓</div>
                  )}
                </div>
              ))}
            </div>

            {gruposSeleccionados > 0 && (
              <div className="grupos-info">
                <strong>{gruposSeleccionados} grupo{gruposSeleccionados !== 1 ? 's' : ''} seleccionado{gruposSeleccionados !== 1 ? 's' : ''}</strong>
              </div>
            )}
          </div>

          {/* DISTRIBUCIÓN AUTOMÁTICA */}
          {gruposSeleccionados > 0 && (
            <div className="distribucion-preview">
              <h3>📊 Vista Previa de Distribución</h3>
              <div className="preview-content">
                <p>El sistema distribuirá automáticamente tus <strong>{gruposSeleccionados} grupo{gruposSeleccionados !== 1 ? 's' : ''}</strong> en <strong>{formData.diasDisponibles} día{formData.diasDisponibles !== 1 ? 's' : ''}</strong></p>
                <div className="distribution-example">
                  {formData.gruposMusculares.length > 0 && (
                    <>
                      {Array.from({ length: formData.diasDisponibles }).map((_, day) => (
                        <div key={day} className="day-preview">
                          <strong>Día {day + 1}</strong>
                          <p className="grupos-list">
                            {gruposMusculares
                              .filter(g => formData.gruposMusculares.includes(g.id))
                              .slice(
                                Math.floor((day / formData.diasDisponibles) * gruposSeleccionados),
                                Math.ceil(((day + 1) / formData.diasDisponibles) * gruposSeleccionados)
                              )
                              .map(g => g.label.split(' ')[1])
                              .join(' + ') || '-'
                            }
                          </p>
                        </div>
                      ))}
                    </>
                  )}
                </div>
              </div>
            </div>
          )}

          {/* BOTÓN */}
          <button
            type="submit"
            disabled={loading || gruposSeleccionados === 0}
            className="btn-generar"
          >
            {loading ? '⏳ Generando...' : `🚀 Generar Rutina Personalizada`}
          </button>
        </form>
      </div>
    </div>
  );
}

export default GenerarRutinaPersonalizada;
