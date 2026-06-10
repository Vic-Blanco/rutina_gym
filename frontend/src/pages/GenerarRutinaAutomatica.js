import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { obtenerInfoSistema } from '../api/api';
import './GenerarRutinaAutomatica.scss';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080/api';

function GenerarRutinaAutomatica() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [infoSistema, setInfoSistema] = useState(null);

  const [formData, setFormData] = useState({
    nombre: 'Mi Rutina Automática',
    nivel: 'INTERMEDIO',
    objetivo: 'HIPERTROFIA',
    diasDisponibles: 3,
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

  // Cargar información del sistema experto al montar el componente
  useEffect(() => {
    const cargarInfo = async () => {
      try {
        const response = await obtenerInfoSistema();
        setInfoSistema(response.data);
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

    setLoading(true);

    try {
      // Llamar al backend con parámetros de generación automática
      const response = await axios.post(`${API_BASE_URL}/v1/rutinas/generar`, {
        nombre: formData.nombre,
        objetivo: formData.objetivo,
        nivel: formData.nivel,
        diasDisponibles: formData.diasDisponibles,
        gruposMusculares: [], // Sistema elige automáticamente
      });

      localStorage.setItem('rutinaActual', JSON.stringify(response.data));
      navigate('/detalle-rutina');
    } catch (err) {
      setError(err.response?.data?.message || 'Error al generar la rutina');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="generar-automatica-container">
      <button className="btn-volver" onClick={() => navigate('/generar-rutina')}>
        ← Volver
      </button>

      <div className="container-form">
        <div className="form-header">
          <h1>🤖 Generación Automática de Rutina</h1>
          <p>El sistema experto determina todo automáticamente</p>
        </div>

        {error && <div className="error-banner">{error}</div>}

        <form onSubmit={handleSubmit} className="automatica-form">
          {/* NOMBRE */}
          <div className="form-section">
            <label>📝 Nombre de la Rutina</label>
            <input
              type="text"
              value={formData.nombre}
              onChange={(e) => setFormData({ ...formData, nombre: e.target.value })}
              placeholder="Ej: Rutina de Hipertrofia"
              className="input-text"
            />
          </div>

          {/* NIVEL */}
          <div className="form-section">
            <label>📊 Tu Nivel de Experiencia</label>
            <p className="section-description">El sistema adapta ejercicios y volumen a tu nivel</p>
            <div className="opciones-grid-small">
              {niveles.map(nivel => (
                <div
                  key={nivel.value}
                  className={`nivel-card ${formData.nivel === nivel.value ? 'active' : ''}`}
                  onClick={() => setFormData({ ...formData, nivel: nivel.value })}
                >
                  <div className="card-label">{nivel.label}</div>
                  <div className="card-desc">{nivel.desc}</div>
                </div>
              ))}
            </div>
          </div>

          {/* OBJETIVO */}
          <div className="form-section">
            <label>🎯 Tu Objetivo Principal</label>
            <p className="section-description">Esto determina el volumen, intensidad y descansos</p>
            <div className="opciones-grid-large">
              {objetivos.map(obj => (
                <div
                  key={obj.value}
                  className={`objetivo-card ${formData.objetivo === obj.value ? 'active' : ''}`}
                  onClick={() => setFormData({ ...formData, objetivo: obj.value })}
                >
                  <div className="card-label">{obj.label}</div>
                  <div className="card-desc">{obj.desc}</div>
                </div>
              ))}
            </div>
          </div>

          {/* DÍAS */}
          <div className="form-section">
            <label>📅 Días Disponibles para Entrenar</label>
            <p className="section-description">Selecciona cuántos días a la semana puedes entrenar (2-6)</p>
            <div className="dias-selector">
              {[2, 3, 4, 5, 6].map(dia => (
                <button
                  key={dia}
                  type="button"
                  className={`dia-btn ${formData.diasDisponibles === dia ? 'active' : ''}`}
                  onClick={() => setFormData({ ...formData, diasDisponibles: dia })}
                >
                  {dia}
                </button>
              ))}
            </div>
            <div className="dias-info">
              El sistema distribuirá tu entrenamiento en <strong>{formData.diasDisponibles} días</strong> de forma óptima
            </div>
          </div>

          {/* RESUMEN CON INFORMACIÓN DEL SISTEMA EXPERTO */}
          <div className="resumen-card">
            <h3>✨ Sistema Experto - Análisis Inteligente</h3>
            <ul>
              <li>✓ Tipo de rutina optimizado para {niveles.find(n => n.value === formData.nivel)?.label}</li>
              <li>✓ Enfoque en {objetivos.find(o => o.value === formData.objetivo)?.label}</li>
              <li>✓ {formData.diasDisponibles} días de entrenamiento distribuidos inteligentemente</li>
              <li>✓ Ejercicios seleccionados automáticamente</li>
              <li>✓ Series, repeticiones y descansos optimizados</li>
            </ul>
          </div>

          {/* BOTÓN */}
          <button
            type="submit"
            disabled={loading}
            className="btn-generar"
          >
            {loading ? '⏳ Generando...' : '🚀 Generar Rutina Automática'}
          </button>
        </form>
      </div>
    </div>
  );
}

export default GenerarRutinaAutomatica;
