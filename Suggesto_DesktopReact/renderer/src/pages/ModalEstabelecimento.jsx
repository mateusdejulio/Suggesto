import React, { useState, useRef } from "react";
import './ModalEstabelecimento.css'; // Importando o CSS separado

// ─── ÍCONE INLINE ─────────────────────────────────────────────────────────────
const Icon = ({ d, size = 16 }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none"
    stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
    <path d={d} />
  </svg>
);
const IC = {
  close:   "M18 6L6 18M6 6l12 12",
  upload:  "M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4M17 8l-5-5-5 5M12 3v12",
  check:   "M20 6L9 17l-5-5",
  img:     "M21 19a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h4l2-3h6l2 3h4a2 2 0 012 2z M12 13a3 3 0 100-6 3 3 0 000 6z",
  logo:    "M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5",
};

const CATEGORIAS = [
  "Restaurante", "Bar", "Lanchonete", "Pizzaria",
  "Cafeteria", "Padaria", "Sorveteria", "Outro",
];

export default function ModalEstabelecimento({ fecharModal, aoSalvar }) {
  const [nome,      setNome]      = useState("");
  const [cnpj,      setCnpj]      = useState("");
  const [endereco,  setEndereco]  = useState("");
  const [categoria, setCategoria] = useState("");
  const [telefone,  setTelefone]  = useState("");
  const [arquivo,   setArquivo]   = useState(null);
  const [preview,   setPreview]   = useState(null);
  const [salvando,  setSalvando]  = useState(false);
  const [dragOver,  setDragOver]  = useState(false);
  const fileRef = useRef();

  // ── Lógica de arquivo ───────────────────────────────────────────────────────
  const aplicarArquivo = (file) => {
    if (!file) return;
    setArquivo(file);
    setPreview(URL.createObjectURL(file));
  };

  const handleFile = (e) => aplicarArquivo(e.target.files[0]);

  const handleDrop = (e) => {
    e.preventDefault();
    setDragOver(false);
    aplicarArquivo(e.dataTransfer.files[0]);
  };

  // ── Submissão ───────────────────────────────────────────────────────────────
  const handleSalvar = async (e) => {
    e.preventDefault();
    setSalvando(true);

    const idGerente = localStorage.getItem("idUsuario");
    if (!idGerente) { alert("Erro: ID do gerente não encontrado."); setSalvando(false); return; }

    const formData = new FormData();
    formData.append(
      "estabelecimento",
      new Blob([JSON.stringify({ nome, cnpj, endereco, categoria, telefone, idGerente })],
        { type: "application/json" })
    );
    if (arquivo) formData.append("foto", arquivo);

    try {
      const r = await fetch("http://localhost:8080/api/estabelecimentos", { method: "POST", body: formData });
      if (r.ok) {
        aoSalvar(await r.json());
        fecharModal();
      } else {
        alert("Erro ao guardar: " + await r.text());
      }
    } catch {
      alert("Erro de comunicação com o servidor.");
    } finally {
      setSalvando(false);
    }
  };

  // ── Máscara CNPJ ────────────────────────────────────────────────────────────
  const mascaraCnpj = (v) => {
    const n = v.replace(/\D/g, "").slice(0, 14);
    return n
      .replace(/^(\d{2})(\d)/, "$1.$2")
      .replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3")
      .replace(/\.(\d{3})(\d)/, ".$1/$2")
      .replace(/(\d{4})(\d)/, "$1-$2");
  };

  // ── Máscara Telefone ────────────────────────────────────────────────────────
  const mascaraTel = (v) => {
    const n = v.replace(/\D/g, "").slice(0, 11);
    if (n.length <= 10) return n.replace(/^(\d{2})(\d{4})(\d{0,4})/, "($1) $2-$3");
    return n.replace(/^(\d{2})(\d{5})(\d{0,4})/, "($1) $2-$3");
  };

  return (
    <>
      {/* ── Overlay ───────────────────────────────────────────────────────── */}
      <div className="modal-overlay" onClick={fecharModal} />

      {/* ── Painel ────────────────────────────────────────────────────────── */}
      <div className="modal-painel">

        {/* Glows */}
        <div className="modal-glow-1" />
        <div className="modal-glow-2" />

        {/* ── Cabeçalho ─────────────────────────────────────────────────── */}
        <div className="modal-header">
          <div className="header-left">
            <div className="logo-icon"><Icon d={IC.logo} size={16} /></div>
            <div>
              <h2 className="modal-titulo">Novo Estabelecimento</h2>
              <p className="modal-subtitulo">Preencha os dados para cadastrar</p>
            </div>
          </div>
          <button className="btn-fechar" onClick={fecharModal}>
            <Icon d={IC.close} size={16} />
          </button>
        </div>

        <div className="modal-divider" />

        {/* ── Formulário ────────────────────────────────────────────────── */}
        <form onSubmit={handleSalvar} className="modal-form">
          <div className="form-grid-2">
            <Campo label="Nome do local" required>
              <input className="form-input" value={nome}
                onChange={(e) => setNome(e.target.value)} required
                placeholder="Ex: Café Central" />
            </Campo>

            <Campo label="Categoria" required>
              <select className="form-input form-select"
                value={categoria} onChange={(e) => setCategoria(e.target.value)} required>
                <option value="" disabled>Selecione...</option>
                {CATEGORIAS.map((c) => <option key={c} value={c}>{c}</option>)}
              </select>
            </Campo>
          </div>

          <Campo label="Endereço completo" required>
            <input className="form-input" value={endereco}
              onChange={(e) => setEndereco(e.target.value)} required
              placeholder="Rua, número, bairro, cidade" />
          </Campo>

          <div className="form-grid-2">
            <Campo label="CNPJ" required>
              <input className="form-input" value={cnpj}
                onChange={(e) => setCnpj(mascaraCnpj(e.target.value))} required
                placeholder="00.000.000/0000-00" />
            </Campo>

            <Campo label="Telefone" required>
              <input className="form-input" value={telefone}
                onChange={(e) => setTelefone(mascaraTel(e.target.value))} required
                placeholder="(00) 00000-0000" />
            </Campo>
          </div>

          {/* ── Upload de foto ──────────────────────────────────────────── */}
          <Campo label="Foto do estabelecimento">
            <div
              className={`dropzone ${dragOver ? 'ativo' : ''}`}
              onClick={() => fileRef.current.click()}
              onDragOver={(e) => { e.preventDefault(); setDragOver(true); }}
              onDragLeave={() => setDragOver(false)}
              onDrop={handleDrop}
            >
              {preview ? (
                <div className="preview-wrap">
                  <img src={preview} alt="preview" className="preview-img" />
                  <div className="preview-overlay">
                    <span className="preview-troca">Trocar imagem</span>
                  </div>
                </div>
              ) : (
                <div className="drop-content">
                  <div className="drop-icon"><Icon d={IC.upload} size={22} /></div>
                  <p className="drop-title">Arraste ou clique para enviar</p>
                  <p className="drop-sub">PNG, JPG, WEBP — máx. 5 MB</p>
                </div>
              )}
              <input ref={fileRef} type="file" accept="image/*"
                onChange={handleFile} style={{ display: "none" }} />
            </div>
          </Campo>

          <div className="modal-divider" />

          {/* ── Rodapé ──────────────────────────────────────────────────── */}
          <div className="modal-footer">
            <button type="button" className="btn-cancelar" onClick={fecharModal}>
              Cancelar
            </button>
            <button type="submit" className="btn-salvar" disabled={salvando}>
              {salvando ? (
                <><span className="spinner" /> Registrando...</>
              ) : (
                <><Icon d={IC.check} size={15} /> Registrar</>
              )}
            </button>
          </div>
        </form>
      </div>
    </>
  );
}

// ─── SUB-COMPONENTE: CAMPO ────────────────────────────────────────────────────
function Campo({ label, required, children }) {
  return (
    <div className="campo-wrapper">
      <label className="form-label">
        {label}
        {required && <span className="asterisco">*</span>}
      </label>
      {children}
    </div>
  );
}