import React from 'react';
import { Link } from 'react-router-dom';
import { FiPlus, FiBook } from 'react-icons/fi';
import './Dashboard.scss';

function Dashboard({ usuario }) {
  return (
    <div className="dashboard-container">
      <div className="container">
        <div className="dashboard-header">
          <h1>¡Bienvenido, {usuario.nombre}! 💪</h1>
          <p>Crea y gestiona tus rutinas de entrenamiento personalizadas</p>
        </div>

        <div className="dashboard-grid">
          <Link to="/generar-rutina" className="dashboard-card">
            <div className="card-icon">
              <FiPlus />
            </div>
            <h2>Nueva Rutina</h2>
            <p>Genera una rutina personalizada según tu nivel y objetivos</p>
            <span className="card-cta">Comenzar →</span>
          </Link>

          <Link to="/mis-rutinas" className="dashboard-card">
            <div className="card-icon">
              <FiBook />
            </div>
            <h2>Mis Rutinas</h2>
            <p>Visualiza y gestiona todas tus rutinas de entrenamiento</p>
            <span className="card-cta">Ver rutinas →</span>
          </Link>
        </div>

        <div className="dashboard-info">
          <h3>📋 Cómo funciona</h3>
          <ol>
            <li><strong>Selecciona tu nivel:</strong> Inicial, Intermedio o Avanzado</li>
            <li><strong>Elige días de entrenamiento:</strong> Entre 1 y 7 días</li>
            <li><strong>Define grupos musculares:</strong> Selecciona los que deseas trabajar</li>
            <li><strong>Genera tu rutina:</strong> El sistema combinará OOP y Prolog para personalizarla</li>
            <li><strong>Entrena:</strong> Sigue tu rutina personalizada</li>
          </ol>
        </div>

        <div className="dashboard-tech">
          <h3>🔧 Tecnología</h3>
          <p>
            Esta aplicación utiliza <strong>OOP (Programación Orientada a Objetos)</strong> en Java Spring Boot
            para la lógica de negocio y <strong>Prolog (Lógica Declarativa)</strong> para crear reglas inteligentes
            sobre qué ejercicios son más apropiados según tu perfil.
          </p>
        </div>
      </div>
    </div>
  );
}

export default Dashboard;
