import React, { useEffect, useState } from "react";
import { Link, useParams } from "react-router-dom";
import "./MinhasRecompensas.css";

const API = "http://localhost:8080";

export default function MinhasRecompensas() {
  const { id: idEstabParam } = useParams();
  const [estabelecimentos, setEstabelecimentos] = useState([]);
  const [idEstabelecimento, setIdEstabelecimento] = useState(idEstabParam || "");
  const [recompensas, setRecompensas] = useState([]);
  const [carregando, setCarregando] = useState(true);
  const [salvando, setSalvando] = useState(false);
  const [form, setForm] = useState({ nome: "", descricao: "", custoPontos: "" });

  useEffect(() => {
    const idGerente = localStorage.getItem("idUsuario");
    if (!idGerente) return;

    (async () => {
      try {
        const r = await fetch(`${API}/api/estabelecimentos/gerente/${idGerente}`);
        if (r.ok) {
          const lista = await r.json();
          setEstabelecimentos(lista);
          if (!idEstabParam && lista.length > 0) {
            setIdEstabelecimento(String(lista[0].idEstabelecimento));
          }
        }
      } catch (e) {
        console.error(e);
      }
    })();
  }, [idEstabParam]);

  useEffect(() => {
    if (!idEstabelecimento) {
      setRecompensas([]);
      setCarregando(false);
      return;
    }

    (async () => {
      setCarregando(true);
      try {
        const r = await fetch(
          `${API}/api/recompensas/estabelecimento/${idEstabelecimento}`,
        );
        if (r.ok) setRecompensas(await r.json());
        else setRecompensas([]);
      } catch (e) {
        console.error(e);
        setRecompensas([]);
      } finally {
        setCarregando(false);
      }
    })();
  }, [idEstabelecimento]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!idEstabelecimento) {
      alert("Selecione um estabelecimento.");
      return;
    }

    setSalvando(true);
    try {
      const r = await fetch(`${API}/api/recompensas`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          nome: form.nome.trim(),
          descricao: form.descricao.trim(),
          custoPontos: Number(form.custoPontos),
          estabelecimentoId: Number(idEstabelecimento),
        }),
      });

      if (!r.ok) {
        const err = await r.json();
        throw new Error(err.message || "Erro ao cadastrar.");
      }

      const nova = await r.json();
      setRecompensas((prev) => [...prev, nova].sort((a, b) => a.custoPontos - b.custoPontos));
      setForm({ nome: "", descricao: "", custoPontos: "" });
    } catch (err) {
      alert(err.message || "Erro ao salvar recompensa.");
    } finally {
      setSalvando(false);
    }
  };

  const handleExcluir = async (id) => {
    if (!window.confirm("Excluir esta recompensa?")) return;
    try {
      const r = await fetch(`${API}/api/recompensas/${id}`, { method: "DELETE" });
      if (r.ok) {
        setRecompensas((prev) => prev.filter((rec) => rec.id !== id));
      } else {
        alert("Erro ao excluir.");
      }
    } catch {
      alert("Erro de comunicação.");
    }
  };

  return (
    <div className="pagina-recompensas">
      <header className="recomp-header">
        <Link to="/" className="btn-voltar">
          ← Dashboard
        </Link>
        <div>
          <h1>Minhas Recompensas</h1>
          <p>Cadastre brindes para o mercado de pontos dos clientes.</p>
        </div>
      </header>

      <div className="recomp-layout">
        <section className="recomp-form-card">
          <h2>Novo brinde</h2>

          {estabelecimentos.length > 1 && (
            <label className="recomp-label">
              Estabelecimento
              <select
                value={idEstabelecimento}
                onChange={(e) => setIdEstabelecimento(e.target.value)}
              >
                {estabelecimentos.map((e) => (
                  <option key={e.idEstabelecimento} value={e.idEstabelecimento}>
                    {e.nome}
                  </option>
                ))}
              </select>
            </label>
          )}

          <form onSubmit={handleSubmit} className="recomp-form">
            <label className="recomp-label">
              Nome do brinde
              <input
                value={form.nome}
                onChange={(e) => setForm({ ...form, nome: e.target.value })}
                placeholder="Ex: Casquinha BK"
                required
              />
            </label>
            <label className="recomp-label">
              Descrição
              <textarea
                value={form.descricao}
                onChange={(e) => setForm({ ...form, descricao: e.target.value })}
                placeholder="Ex: Uma casquinha de baunilha"
                rows={3}
              />
            </label>
            <label className="recomp-label">
              Custo em pontos
              <input
                type="number"
                min={1}
                value={form.custoPontos}
                onChange={(e) => setForm({ ...form, custoPontos: e.target.value })}
                placeholder="Ex: 1000"
                required
              />
            </label>
            <button type="submit" className="btn-salvar" disabled={salvando}>
              {salvando ? "Salvando..." : "Cadastrar recompensa"}
            </button>
          </form>
        </section>

        <section className="recomp-lista-card">
          <h2>Recompensas cadastradas</h2>
          {carregando ? (
            <p className="recomp-muted">Carregando...</p>
          ) : recompensas.length === 0 ? (
            <p className="recomp-muted">Nenhuma recompensa para este estabelecimento.</p>
          ) : (
            <table className="recomp-tabela">
              <thead>
                <tr>
                  <th>Nome</th>
                  <th>Descrição</th>
                  <th>Custo</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {recompensas.map((rec) => (
                  <tr key={rec.id}>
                    <td>{rec.nome}</td>
                    <td>{rec.descricao || "—"}</td>
                    <td>{rec.custoPontos?.toLocaleString("pt-BR")} pts</td>
                    <td>
                      <button
                        type="button"
                        className="btn-excluir"
                        onClick={() => handleExcluir(rec.id)}
                      >
                        Excluir
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </section>
      </div>
    </div>
  );
}
