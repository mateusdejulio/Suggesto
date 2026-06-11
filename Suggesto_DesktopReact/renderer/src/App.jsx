import React, { useState} from "react";

import { HashRouter, Routes, Route} from "react-router-dom";

import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import DetalhesEstabelecimento from "./pages/DetalhesEstabelecimento";
import MinhasRecompensas from "./pages/MinhasRecompensas";

import "./App.css";

function App(){
  const [isLogado, setIsLogado] = useState(false);

  if(!isLogado) {
    return <Login aoLogar={() => setIsLogado(true)} />
  }

  return (
    <HashRouter>
      <Routes>

        {/* Quando o caminho (path) for "/", mostre o elemento (element) Dashboard */}
        <Route path = "/" element = {<Dashboard />} />

        {/* Quando o caminho for "/estabelecimento/QUALQUER-NUMERO", mostre os Detalhes */}
        <Route path = "/estabelecimento/:id" element = {<DetalhesEstabelecimento />} />
        <Route path = "/estabelecimento/:id/recompensas" element = {<MinhasRecompensas />} />
        <Route path = "/recompensas" element = {<MinhasRecompensas />} />

      </Routes>
    </HashRouter>
  )
}

export default App;