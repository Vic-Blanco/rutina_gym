import React, { useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import './App.scss';
import SeleccionarTipo from './pages/SeleccionarTipo';
import GenerarRutinaAutomatica from './pages/GenerarRutinaAutomatica';
import GenerarRutinaPersonalizada from './pages/GenerarRutinaPersonalizada';
import DetalleRutina from './pages/DetalleRutina';

function App() {
  const [rutinaGenerada, setRutinaGenerada] = useState(null);

  return (
    <Router>
      <div className="App">
        <Routes>
          <Route path="/" element={<SeleccionarTipo />} />
          <Route path="/generar-rutina" element={<SeleccionarTipo />} />
          <Route path="/generar-automatica" element={<GenerarRutinaAutomatica onRutinaGenerada={setRutinaGenerada} />} />
          <Route path="/generar-personalizada" element={<GenerarRutinaPersonalizada onRutinaGenerada={setRutinaGenerada} />} />
          <Route path="/detalle-rutina" element={<DetalleRutina rutina={rutinaGenerada} />} />
          <Route path="/rutina" element={<DetalleRutina rutina={rutinaGenerada} />} />
          <Route path="*" element={<Navigate to="/" />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
