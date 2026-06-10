import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { FiLogOut, FiHome, FiPlus, FiList } from 'react-icons/fi';
import './Navbar.scss';

function Navbar({ usuario, onLogout }) {
  const navigate = useNavigate();

  const handleLogout = () => {
    onLogout();
    navigate('/login');
  };

  return (
    <nav className="navbar">
      <div className="navbar-container">
        <Link to="/dashboard" className="navbar-brand">
          💪 Rutina Gym
        </Link>
        
        <div className="navbar-menu">
          <Link to="/dashboard" className="nav-link">
            <FiHome /> Dashboard
          </Link>
          <Link to="/generar-rutina" className="nav-link">
            <FiPlus /> Nueva Rutina
          </Link>
          <Link to="/mis-rutinas" className="nav-link">
            <FiList /> Mis Rutinas
          </Link>
        </div>

        <div className="navbar-user">
          <span className="usuario-nombre">{usuario.nombre}</span>
          <button className="btn-logout" onClick={handleLogout}>
            <FiLogOut /> Salir
          </button>
        </div>
      </div>
    </nav>
  );
}

export default Navbar;
