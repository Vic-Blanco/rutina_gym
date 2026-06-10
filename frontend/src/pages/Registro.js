import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { registro } from '../api/api';
import './Registro.scss';

function Registro({ onRegister }) {
  const [formData, setFormData] = useState({
    email: '',
    nombre: '',
    password: '',
    confirmPassword: '',
    nivel: 'INICIAL',
    objetivo: 'HIPERTROFIA',
    diasDisponibles: 3,
    gruposMusculares: [],
    grupoPrioritario: 'PECHO',
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const niveles = ['INICIAL', 'INTERMEDIO', 'AVANZADO'];
  const objetivos = ['HIPERTROFIA', 'FUERZA', 'RESISTENCIA', 'ACONDICIONAMIENTO'];
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

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (formData.password !== formData.confirmPassword) {
      setError('Las contraseñas no coinciden');
      return;
    }

    if (formData.gruposMusculares.length === 0) {
      setError('Debes seleccionar al menos un grupo muscular');
      return;
    }

    setLoading(true);

    try {
      const response = await registro({
        email: formData.email,
        nombre: formData.nombre,
        password: formData.password,
        nivel: formData.nivel,
        objetivo: formData.objetivo,
        diasDisponibles: formData.diasDisponibles,
        gruposMusculares: formData.gruposMusculares,
        grupoPrioritario: formData.grupoPrioritario,
      });

      if (response.data.datos) {
        onRegister(response.data.datos);
        navigate('/dashboard');
      }
    } catch (err) {
      setError(err.response?.data?.error || 'Error al registrarse');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="registro-container">
      <div className="registro-box">
        <div className="registro-header">
          <h1>💪 Crea tu cuenta</h1>
          <p>Comienza tu viaje fitness hoy</p>
        </div>

        {error && <div className="error">{error}</div>}

        <form onSubmit={handleSubmit} className="registro-form">
          <div className="form-group">
            <label htmlFor="nombre">Nombre</label>
            <input
              id="nombre"
              name="nombre"
              type="text"
              value={formData.nombre}
              onChange={handleChange}
              required
              placeholder="Tu nombre"
            />
          </div>

          <div className="form-group">
            <label htmlFor="email">Email</label>
            <input
              id="email"
              name="email"
              type="email"
              value={formData.email}
              onChange={handleChange}
              required
              placeholder="tu@email.com"
            />
          </div>

          <div className="form-row">
            <div className="form-group">
              <label htmlFor="nivel">Nivel</label>
              <select
                id="nivel"
                name="nivel"
                value={formData.nivel}
                onChange={handleChange}
              >
                {niveles.map(n => (
                  <option key={n} value={n}>{n}</option>
                ))}
              </select>
            </div>

            <div className="form-group">
              <label htmlFor="objetivo">Objetivo</label>
              <select
                id="objetivo"
                name="objetivo"
                value={formData.objetivo}
                onChange={handleChange}
              >
                {objetivos.map(obj => (
                  <option key={obj} value={obj}>{obj}</option>
                ))}
              </select>
            </div>

            <div className="form-group">
              <label htmlFor="diasDisponibles">Días Disponibles</label>
              <select
                id="diasDisponibles"
                name="diasDisponibles"
                value={formData.diasDisponibles}
                onChange={handleChange}
              >
                {[1, 2, 3, 4, 5, 6, 7].map(d => (
                  <option key={d} value={d}>{d} días</option>
                ))}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label htmlFor="grupoPrioritario">Grupo Muscular Prioritario</label>
            <select
              id="grupoPrioritario"
              name="grupoPrioritario"
              value={formData.grupoPrioritario}
              onChange={handleChange}
            >
              {gruposMusculares.map(g => (
                <option key={g} value={g}>{g}</option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label>Grupos Musculares Preferidos</label>
            <div className="grupos-checkboxes">
              {gruposMusculares.map(grupo => (
                <label key={grupo} className="checkbox-item">
                  <input
                    type="checkbox"
                    checked={formData.gruposMusculares.includes(grupo)}
                    onChange={() => handleGrupoToggle(grupo)}
                  />
                  <span>{grupo}</span>
                </label>
              ))}
            </div>
          </div>

          <div className="form-group">
            <label htmlFor="password">Contraseña</label>
            <input
              id="password"
              name="password"
              type="password"
              value={formData.password}
              onChange={handleChange}
              required
              placeholder="••••••••"
            />
          </div>

          <div className="form-group">
            <label htmlFor="confirmPassword">Confirmar Contraseña</label>
            <input
              id="confirmPassword"
              name="confirmPassword"
              type="password"
              value={formData.confirmPassword}
              onChange={handleChange}
              required
              placeholder="••••••••"
            />
          </div>

          <button type="submit" className="btn-primary" disabled={loading}>
            {loading ? 'Registrando...' : 'Crear Cuenta'}
          </button>
        </form>

        <p className="registro-footer">
          ¿Ya tienes cuenta? <a href="/login">Inicia sesión aquí</a>
        </p>
      </div>
    </div>
  );
}

export default Registro;
