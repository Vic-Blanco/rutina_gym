import React, { useState } from 'react';
import axios from 'axios';
import './GenerarRutina.scss';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080/api';

function GenerarRutina({ onRutinaGenerada }) {
  const [formData, setFormData] = useState({
    nombre: '',
    objetivo: 'HIPERTROFIA',
    diasDisponibles: 3,
    gruposMusculares: [],
    grupoPrioritario: 'PECHO',
  });

  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const objetivos = [
    { value: 'HIPERTROFIA', label: 'Hipertrofia - Ganar masa muscular' },
    { value: 'FUERZA', label: 'Fuerza - Aumentar capacidad de levantamiento' },
    { value: 'RESISTENCIA', label: 'Resistencia - Mejorar capacidad aeróbica' },
    { value: 'ACONDICIONAMIENTO', label: 'Acondicionamiento - Fitness general' },
  ];

  const gruposMusculares = [
    'PECHO', 'ESPALDA', 'HOMBROS', 'BICEPS', 'TRICEPS', 'ANTEBRAZO',
    'CUADRICEPS', 'ISQUIOTIBIAL', 'GLUTEOS', 'PANTORRILLA', 'CORE', 'CARDIO'
  ];

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleGrupoToggle = (grupo) => {
    setFormData(prev => ({
      ...prev,
      gruposMusculares: prev.gruposMusculares.includes(grupo)
        ? prev.gruposMusculares.filter(g => g !== grupo)
        : [...prev.gruposMusculares, grupo]
    }));
  };

  const handleDiasChange = (dias) => {
    setFormData(prev => ({
      ...prev,
      diasDisponibles: dias,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (!formData.nombre.trim()) {
      setError('Debes ingresar un nombre para la rutina');
      return;
    }

    if (formData.gruposMusculares.length === 0) {
      setError('Debes seleccionar al menos un grupo muscular');
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
        grupoPrioritario: formData.grupoPrioritario,
      });

      localStorage.setItem('rutinaActual', JSON.stringify(response.data));
      if (onRutinaGenerada) {
        onRutinaGenerada(response.data);
      }
      window.location.href = '/rutina';
    } catch (err) {
      setError(err.response?.data || 'Error al generar la rutina');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="generar-rutina-container">
      <div className="header-simple">
        <h1>🏋️ Generador de Rutinas con IA</h1>
        <p>Crea tu rutina personalizada usando el Sistema Experto Prolog</p>
      </div>

      <div className="container">
        {error && <div className="error-banner">{error}</div>}

        <form onSubmit={handleSubmit} className="rutina-form-simple">
          
          <div className="form-section">
            <h2>Información Básica</h2>

            <div className="form-group">
              <label htmlFor="nombre">📝 Nombre de la Rutina</label>
              <input
                id="nombre"
                name="nombre"
                type="text"
                value={formData.nombre}
                onChange={handleChange}
                placeholder="Ej: Mi Rutina Full Body"
                required
              />
            </div>

            <div className="form-row">
              <div className="form-group">
                <label htmlFor="objetivo">🎯 Objetivo de Entrenamiento</label>
                <select
                  id="objetivo"
                  name="objetivo"
                  value={formData.objetivo}
                  onChange={handleChange}
                >
                  {objetivos.map(obj => (
                    <option key={obj.value} value={obj.value}>{obj.label}</option>
                  ))}
                </select>
              </div>

              <div className="form-group">
                <label htmlFor="diasDisponibles">📅 Días de Entrenamiento</label>
                <div className="days-selector">
                  {[1, 2, 3, 4, 5, 6, 7].map(day => (
                    <button
                      key={day}
                      type="button"
                      className={`day-btn ${formData.diasDisponibles === day ? 'active' : ''}`}
                      onClick={() => handleDiasChange(day)}
                    >
                      {day}
                    </button>
                  ))}
                </div>
              </div>

              <div className="form-group">
                <label htmlFor="grupoPrioritario">⭐ Grupo Muscular Prioritario</label>
                <select
                  id="grupoPrioritario"
                  name="grupoPrioritario"
                  value={formData.grupoPrioritario}
                  onChange={handleChange}
                >
                  {gruposMusculares.map(grupo => (
                    <option key={grupo} value={grupo}>{grupo}</option>
                  ))}
                </select>
              </div>
            </div>
          </div>

          <div className="form-section">
            <h2>🎯 Selecciona Grupos Musculares</h2>
            <div className="grupos-grid">
              {gruposMusculares.map(grupo => (
                <label key={grupo} className="grupo-checkbox">
                  <input
                    type="checkbox"
                    checked={formData.gruposMusculares.includes(grupo)}
                    onChange={() => handleGrupoToggle(grupo)}
                  />
                  <span className="grupo-label">{grupo}</span>
                </label>
              ))}
            </div>
          </div>

          <button
            type="submit"
            disabled={loading}
            className="submit-btn"
          >
            {loading ? '⏳ Generando Rutina...' : '✨ Generar Mi Rutina'}
          </button>
        </form>

        <div className="info-section">
          <h3>ℹ️ ¿Cómo Funciona?</h3>
          <ul>
            <li><strong>Prolog:</strong> Decide inteligentemente qué ejercicios son mejores para ti</li>
            <li><strong>OOP:</strong> Organiza los ejercicios por día</li>
            <li><strong>Sin Login:</strong> Crea rutinas al instante</li>
            <li><strong>Sin BD:</strong> No guardamos nada, solo tú tienes tus rutinas</li>
          </ul>
        </div>
      </div>
    </div>
  );
}

export default GenerarRutina;
