import React from 'react';
import { useNavigate } from 'react-router-dom';
import './SeleccionarTipo.scss';

function SeleccionarTipo() {
  const navigate = useNavigate();

  return (
    <div className="seleccionar-tipo-container">
      <div className="header-section">
        <h1>🏋️ Generar Nueva Rutina</h1>
        <p>Elige cómo deseas crear tu rutina de entrenamiento</p>
      </div>

      <div className="opciones-grid">
        {/* OPCIÓN 1: AUTOMÁTICA */}
        <div 
          className="opcion-card automatica"
          onClick={() => navigate('/generar-automatica')}
        >
          <div className="opcion-icon">🤖</div>
          <h2>Generación Automática</h2>
          <p className="opcion-description">
            El sistema experto elige todo por ti
          </p>
          
          <div className="opcion-flow">
            <div className="flow-step">
              <span className="step-number">1</span>
              <span className="step-text">Selecciona tu nivel</span>
            </div>
            <div className="arrow">→</div>
            <div className="flow-step">
              <span className="step-number">2</span>
              <span className="step-text">Elige tu objetivo</span>
            </div>
            <div className="arrow">→</div>
            <div className="flow-step">
              <span className="step-number">3</span>
              <span className="step-text">Indica días disponibles</span>
            </div>
          </div>

          <div className="opcion-result">
            <strong>✨ Resultado:</strong>
            <ul>
              <li>Tipo de rutina optimizado</li>
              <li>Ejercicios automáticos</li>
              <li>Series y repeticiones</li>
              <li>Distribución semanal</li>
            </ul>
          </div>

          <button className="btn-opcion">
            Generación Automática →
          </button>
        </div>

        {/* OPCIÓN 2: PERSONALIZADA */}
        <div 
          className="opcion-card personalizada"
          onClick={() => navigate('/generar-personalizada')}
        >
          <div className="opcion-icon">🎯</div>
          <h2>Generación Personalizada</h2>
          <p className="opcion-description">
            Elige qué grupos musculares entrenar
          </p>
          
          <div className="opcion-flow">
            <div className="flow-step">
              <span className="step-number">1</span>
              <span className="step-text">Cantidad de días</span>
            </div>
            <div className="arrow">→</div>
            <div className="flow-step">
              <span className="step-number">2</span>
              <span className="step-text">Selecciona grupos</span>
            </div>
            <div className="arrow">→</div>
            <div className="flow-step">
              <span className="step-number">3</span>
              <span className="step-text">Sistema distribuye</span>
            </div>
          </div>

          <div className="opcion-result">
            <strong>✨ Resultado:</strong>
            <ul>
              <li>Distribución automática</li>
              <li>Grupos agrupados inteligentemente</li>
              <li>Ejercicios personalizados</li>
              <li>Plan adaptado a tus preferencias</li>
            </ul>
          </div>

          <button className="btn-opcion">
            Generación Personalizada →
          </button>
        </div>
      </div>
    </div>
  );
}

export default SeleccionarTipo;
