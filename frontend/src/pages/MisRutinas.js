import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { FiTrash2, FiEye } from 'react-icons/fi';
import { obtenerRutinasUsuario, eliminarRutina } from '../api/api';
import './MisRutinas.scss';

function MisRutinas({ usuario }) {
  const [rutinas, setRutinas] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    cargarRutinas();
  }, []);

  const cargarRutinas = async () => {
    try {
      const response = await obtenerRutinasUsuario(usuario.id);
      setRutinas(response.data.datos || []);
    } catch (err) {
      setError('Error al cargar las rutinas');
    } finally {
      setLoading(false);
    }
  };

  const handleEliminar = async (rutinaId) => {
    if (window.confirm('¿Deseas eliminar esta rutina?')) {
      try {
        await eliminarRutina(rutinaId);
        setRutinas(rutinas.filter(r => r.id !== rutinaId));
      } catch (err) {
        setError('Error al eliminar la rutina');
      }
    }
  };

  return (
    <div className="mis-rutinas-container">
      <div className="container">
        <div className="rutinas-header">
          <h1>Mis Rutinas 📚</h1>
          <p>Gestiona todas tus rutinas de entrenamiento</p>
        </div>

        {error && <div className="error">{error}</div>}

        {loading ? (
          <div className="loading">
            <span>Cargando rutinas...</span>
          </div>
        ) : rutinas.length === 0 ? (
          <div className="empty-state">
            <p>Aún no tienes rutinas creadas</p>
            <Link to="/generar-rutina" className="btn-primary">
              Crear mi primera rutina
            </Link>
          </div>
        ) : (
          <div className="rutinas-grid">
            {rutinas.map(rutina => (
              <div key={rutina.id} className="rutina-card">
                <div className="card-header">
                  <h2>{rutina.nombre}</h2>
                  <div className="card-badges">
                    <span className={`badge nivel-${rutina.nivel.toLowerCase()}`}>
                      {rutina.nivel}
                    </span>
                    <span className="badge dias">
                      {rutina.numDias} días
                    </span>
                  </div>
                </div>

                <div className="card-body">
                  <p className="descripcion">{rutina.descripcion}</p>
                  <div className="ejercicios-preview">
                    <h4>Días de entrenamiento:</h4>
                    <ul>
                      {rutina.diasEntrenamiento?.slice(0, 3).map((dia, idx) => (
                        <li key={idx}>
                          <strong>Día {dia.numeroDia}:</strong> {dia.descripcion}
                        </li>
                      ))}
                      {rutina.diasEntrenamiento?.length > 3 && (
                        <li>
                          <em>+{rutina.diasEntrenamiento.length - 3} días más...</em>
                        </li>
                      )}
                    </ul>
                  </div>
                </div>

                <div className="card-footer">
                  <Link to={`/rutina/${rutina.id}`} className="btn-view">
                    <FiEye /> Ver Detalles
                  </Link>
                  <button
                    className="btn-delete"
                    onClick={() => handleEliminar(rutina.id)}
                  >
                    <FiTrash2 /> Eliminar
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

export default MisRutinas;
