import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { FiArrowLeft, FiDownload } from 'react-icons/fi';
import { obtenerRutina } from '../api/api';
import { getExerciseImage } from '../utils/exerciseImages';
import './DetalleRutina.scss';

function DetalleRutina() {
  const { rutinaId } = useParams();
  const navigate = useNavigate();
  const [rutina, setRutina] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    cargarRutina();
  }, [rutinaId]);

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

        {/* AVISO: RUTINA ORIENTATIVA */}
        <div className="aviso-orientativo">
          <span className="aviso-icono">⚠️</span>
          <div className="aviso-texto">
            <strong>Rutina orientativa</strong>
            <p>Esta rutina es totalmente genérica y tiene carácter orientativo. Consulta siempre con un profesional del deporte o un médico antes de comenzar cualquier programa de entrenamiento.</p>
          </div>
        </div>

        {/* SECCIÓN: DÍAS DE ENTRENAMIENTO */}
        {rutina.diasEntrenamiento && rutina.diasEntrenamiento.length > 0 && (
          <div className="dias-section">
            <h2>📅 Plan de Entrenamiento</h2>
            {rutina.diasEntrenamiento.map((dia, idx) => {
              const ejercicios = dia.ejercicios || [];
              const entradaCalor = ejercicios.filter(e => e.grupoMuscular === 'CARDIO');
              const movilidad   = ejercicios.filter(e => e.grupoMuscular === 'MOVILIDAD' || e.grupoMuscular === 'ACTIVACION');
              const principales = ejercicios.filter(e => e.grupoMuscular !== 'CARDIO' && e.grupoMuscular !== 'MOVILIDAD' && e.grupoMuscular !== 'ACTIVACION');

              // Agrupar principales por grupoMuscular (como devuelve Prolog: grupo_ejercicios/2)
              const principalesPorGrupo = principales.reduce((acc, ej) => {
                const grupo = ej.grupoMuscular || 'OTROS';
                if (!acc[grupo]) acc[grupo] = [];
                acc[grupo].push(ej);
                return acc;
              }, {});

              const renderEjercicios = (lista, colorClass) =>
                lista.map((ej, ejIdx) => (
                  <div key={ejIdx} className={`ejercicio-item ${colorClass}`}>
                    <div className="ejercicio-header">
                      <img
                        src={getExerciseImage(ej)}
                        alt={ej.nombre}
                        className="ejercicio-imagen"
                        onError={(e) => { e.target.style.display = 'none'; }}
                      />
                      <div className="ejercicio-info">
                        <h4>{ej.nombre}</h4>
                        <p className="ejercicio-detalles">
                          {ej.tipo} | {ej.patron}
                        </p>
                      </div>
                    </div>
                    <div className="ejercicio-parametros">
                      {ej.series && (
                        <span className="param-badge">
                          {ej.series} × {ej.repeticiones} reps
                        </span>
                      )}
                      {ej.descansoSegundos > 0 && (
                        <span className="param-badge">⏱️ {ej.descansoSegundos}s</span>
                      )}
                    </div>
                  </div>
                ));

              // Grupos del día desde los grupos musculares del dia o desde los ejercicios principales
              const gruposDia = dia.gruposMusculares && dia.gruposMusculares.length > 0
                ? dia.gruposMusculares.join(' · ')
                : Object.keys(principalesPorGrupo).join(' · ');

              return (
                <div key={idx} className="dia-card">
                  <div className="dia-card-header">
                    <h3>Día {dia.numeroDia}</h3>
                    {gruposDia && <span className="dia-desc">{gruposDia}</span>}
                  </div>

                  {entradaCalor.length > 0 && (
                    <div className="ejercicios-bloque bloque-calor">
                      <h4>🔥 Entrada en Calor</h4>
                      {renderEjercicios(entradaCalor, 'ej-calor')}
                    </div>
                  )}

                  {movilidad.length > 0 && (
                    <div className="ejercicios-bloque bloque-movilidad">
                      <h4>🤸 Movilidad y Activación</h4>
                      {renderEjercicios(movilidad, 'ej-movilidad')}
                    </div>
                  )}

                  {Object.keys(principalesPorGrupo).length > 0 && (
                    <div className="ejercicios-bloque bloque-principales">
                      <h4>💪 Ejercicios Principales</h4>
                      {Object.entries(principalesPorGrupo).map(([grupo, ejsGrupo]) => (
                        <div key={grupo} className="grupo-muscular-bloque">
                          <span className="grupo-muscular-label">{grupo}</span>
                          {renderEjercicios(ejsGrupo, 'ej-principal')}
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              );
            })}
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
