import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { FiArrowLeft, FiDownload } from 'react-icons/fi';
import { obtenerRutina, validarRutina } from '../api/api';
import { getExerciseImage } from '../utils/exerciseImages';
import './DetalleRutina.scss';

function DetalleRutina() {
  const { rutinaId } = useParams();
  const navigate = useNavigate();
  const [rutina, setRutina] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [validacion, setValidacion] = useState(null);

  useEffect(() => {
    cargarRutina();
  }, [rutinaId]);

  // Validar rutina cuando se carga
  useEffect(() => {
    if (rutina) {
      validarRutinaInteligente();
    }
  }, [rutina]);

  const validarRutinaInteligente = async () => {
    try {
      const response = await validarRutina(rutina);
      setValidacion(response.data);
    } catch (err) {
      console.log('No se pudo validar la rutina');
    }
  };

  const cargarRutina = async () => {
    try {
      // Primero intentar cargar desde localStorage (generada recientemente)
      const rutinaLocal = localStorage.getItem('rutinaActual');
      if (rutinaLocal) {
        const rutinaParsed = JSON.parse(rutinaLocal);
        setRutina(rutinaParsed);
        setLoading(false);
        return;
      }

      // Si no está en localStorage e hay un ID, intentar cargar del backend
      if (rutinaId) {
        const response = await obtenerRutina(rutinaId);
        setRutina(response.data.datos);
      } else {
        setError('Rutina no encontrada. Crea una nueva.');
      }
    } catch (err) {
      setError('Error al cargar la rutina: ' + (err.response?.data || err.message));
    } finally {
      setLoading(false);
    }
  };

  const descargarPDF = () => {
    alert('Función de descarga en desarrollo');
  };

  if (loading) {
    return (
      <div className="detalle-rutina-container">
        <div className="loading">Cargando rutina...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="detalle-rutina-container">
        <div className="error">{error}</div>
      </div>
    );
  }

  if (!rutina) {
    return (
      <div className="detalle-rutina-container">
        <div className="error">Rutina no encontrada</div>
      </div>
    );
  }

  return (
    <div className="detalle-rutina-container">
      <div className="container">
        <div className="detalle-header">
          <button onClick={() => navigate(-1)} className="btn-back">
            <FiArrowLeft /> Volver
          </button>
          <button onClick={descargarPDF} className="btn-download">
            <FiDownload /> Descargar PDF
          </button>
        </div>

        <div className="rutina-info">
          <h1>{rutina.nombre || 'Mi Rutina'}</h1>
          {rutina.division && (
            <div className="division-info">
              <span className="badge-primary">División: {rutina.division}</span>
            </div>
          )}
        </div>

        {/* SECCIÓN: VALIDACIONES */}
        {rutina.validaciones && (
          <div className="validaciones-section">
            <h2>✅ Validaciones del Sistema Experto</h2>
            <div className="validaciones-grid">
              {typeof rutina.validaciones === 'object' && Object.entries(rutina.validaciones).map(([key, value]) => (
                <div key={key} className={`validacion-card ${value ? 'pass' : 'fail'}`}>
                  <div className="validacion-icon">{value ? '✓' : '✗'}</div>
                  <div className="validacion-label">{key}</div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* SECCIÓN: ANÁLISIS INTELIGENTE DE RUTINA */}
        {validacion && (
          <div className="validacion-inteligente-section">
            <h2>🔍 Análisis Inteligente del Sistema Experto</h2>
            <div className="validacion-status">
              <span className={`status-badge ${validacion.valida ? 'valida' : 'invalida'}`}>
                {validacion.valida ? '✓ Rutina Válida' : '✗ Problemas Detectados'}
              </span>
            </div>

            {validacion.errores && validacion.errores.length > 0 && (
              <div className="errores-box">
                <h3>❌ Errores:</h3>
                <ul>
                  {validacion.errores.map((err, idx) => (
                    <li key={idx}>{err}</li>
                  ))}
                </ul>
              </div>
            )}

            {validacion.advertencias && validacion.advertencias.length > 0 && (
              <div className="advertencias-box">
                <h3>⚠️ Advertencias:</h3>
                <ul>
                  {validacion.advertencias.map((adv, idx) => (
                    <li key={idx}>{adv}</li>
                  ))}
                </ul>
              </div>
            )}

            {validacion.estadisticas && (
              <div className="estadisticas-box">
                <h3>📊 Estadísticas:</h3>
                <div className="estadisticas-grid">
                  <div className="stat-item">
                    <span className="stat-label">Total de Días</span>
                    <span className="stat-value">{validacion.estadisticas.totalDias}</span>
                  </div>
                  <div className="stat-item">
                    <span className="stat-label">Total Ejercicios</span>
                    <span className="stat-value">{validacion.estadisticas.totalEjercicios}</span>
                  </div>
                  <div className="stat-item">
                    <span className="stat-label">Promedio por Día</span>
                    <span className="stat-value">{validacion.estadisticas.promedioPorDia.toFixed(1)}</span>
                  </div>
                </div>
              </div>
            )}
          </div>
        )}

        {/* SECCIÓN: EXPLICACIÓN DEL SISTEMA EXPERTO */}
        {rutina.explicacion && (
          <div className="explicacion-section">
            <h2>🧠 Explicación del Sistema Experto</h2>
            <div className="explicacion-content">
              {rutina.explicacion}
            </div>
          </div>
        )}

        {/* SECCIÓN: RECOMENDACIONES */}
        {rutina.recomendaciones && rutina.recomendaciones.length > 0 && (
          <div className="recomendaciones-section">
            <h2>💡 Recomendaciones Personalizadas</h2>
            <ul className="recomendaciones-list">
              {rutina.recomendaciones.map((rec, idx) => (
                <li key={idx}>{rec}</li>
              ))}
            </ul>
          </div>
        )}

        {/* SECCIÓN: DÍAS DE ENTRENAMIENTO */}
        {rutina.diasEntrenamiento && rutina.diasEntrenamiento.length > 0 && (
          <div className="dias-section">
            <h2>📅 Plan de Entrenamiento</h2>
            {rutina.diasEntrenamiento.map((dia, idx) => (
              <div key={idx} className="dia-card">
                <h3>Día {dia.numeroDia}</h3>
                {dia.gruposMusculares && (
                  <p className="grupos-del-dia">
                    Grupos: {dia.gruposMusculares.join(', ')}
                  </p>
                )}
                {dia.ejercicios && dia.ejercicios.length > 0 && (
                  <div className="ejercicios-list">
                    {dia.ejercicios.map((ej, ejIdx) => (
                      <div key={ejIdx} className="ejercicio-item">
                        <div className="ejercicio-header">
                          <img 
                            src={getExerciseImage(ej)} 
                            alt={ej.nombre}
                            className="ejercicio-imagen"
                            onError={(e) => {
                              e.target.style.display = 'none';
                            }}
                          />
                          <div className="ejercicio-info">
                            <h4>{ej.nombre}</h4>
                            <p className="ejercicio-detalles">
                              Tipo: {ej.tipo} | Patrón: {ej.patron}
                            </p>
                          </div>
                        </div>
                        <div className="ejercicio-parametros">
                          {ej.series && (
                            <span className="param-badge">
                              {ej.series} x {ej.repeticiones} reps
                            </span>
                          )}
                          {ej.descansoSegundos && (
                            <span className="param-badge">
                              ⏱️ {ej.descansoSegundos}s descanso
                            </span>
                          )}
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            ))}
          </div>
        )}

        {/* SECCIÓN: ESTADÍSTICAS */}
        {rutina.estadisticas && (
          <div className="estadisticas-section">
            <h2>📊 Estadísticas</h2>
            <div className="stats-grid">
              {typeof rutina.estadisticas === 'object' && Object.entries(rutina.estadisticas).map(([key, value]) => (
                <div key={key} className="stat-card">
                  <div className="stat-value">{value}</div>
                  <div className="stat-label">{key}</div>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default DetalleRutina;
