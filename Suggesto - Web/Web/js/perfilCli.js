const API_BASE = "http://localhost:8080/api";
let usuarioAtual = null;

document.addEventListener("DOMContentLoaded", () => {
    iniciarEventos();
    carregarDadosUsuario();
});

function iniciarEventos() {
    document.getElementById("btnSairSidebar")?.addEventListener("click", abrirModalSair);
    document.getElementById("btnConfirmarSaida")?.addEventListener("click", logout);

    document.querySelectorAll(".modal-fechar").forEach(btn => {
        btn.addEventListener("click", () => {
            btn.closest(".modal-fundo")?.classList.remove("aberto");
        });
    });

    document.querySelector(".botao-editar-perfil")?.addEventListener("click", abrirEdicao);

    document.querySelectorAll(".toggle").forEach(toggle => {
        toggle.addEventListener("click", (e) => toggleSwitch(toggle, e));
    });

    document.querySelectorAll(".menu-item").forEach(item => {
        item.addEventListener("click", () => {
            const acao = item.getAttribute("data-acao");
            if (acao) abrirSecao(acao);
        });
    });
}

function abrirModalSair() {
    document.getElementById("modalSaida")?.classList.add("aberto");
}

function abrirEdicao() {
    if (!usuarioAtual) {
        usuarioAtual = {
            nome: localStorage.getItem("nomeUsuario") || document.getElementById("heroNome")?.textContent || "",
            email: document.getElementById("heroEmail")?.textContent || "",
            telefone: "",
            cidade: "",
            fotoUrl: ""
        };
    }

    const editNome = document.getElementById("editNome");
    const editEmail = document.getElementById("editEmail");
    const editTelefone = document.getElementById("editTelefone");
    const editCidade = document.getElementById("editCidade");
    const editFotoFile = document.getElementById("editFotoFile");

    if (editNome) editNome.value = usuarioAtual.nome || "";
    if (editEmail) editEmail.value = usuarioAtual.email || "";
    if (editTelefone) editTelefone.value = usuarioAtual.telefone || "";
    if (editCidade) editCidade.value = usuarioAtual.cidade || "";
    if (editFotoFile) editFotoFile.value = "";

    document.getElementById("modalEdicao")?.classList.add("aberto");
}

function fecharModal(id) {
    document.getElementById(id)?.classList.remove("aberto");
}

function logout() {
    localStorage.clear();
    window.location.href = "login.html";
}

async function carregarDadosUsuario() {
    const idUsuario = localStorage.getItem("idUsuario");

    if (!idUsuario) {
        window.location.href = "login.html";
        return;
    }

    try {
        const resposta = await fetch(`${API_BASE}/usuarios/${idUsuario}`);

        if (resposta.status === 404) {
            logout();
            return;
        }

        if (!resposta.ok) {
            throw new Error("Erro ao buscar dados do usuário.");
        }

        usuarioAtual = await resposta.json();
        preencherPerfil(usuarioAtual);

        if (usuarioAtual.nome) {
            localStorage.setItem("nomeUsuario", usuarioAtual.nome);
        }
    } catch (error) {
        console.error("Erro ao carregar perfil:", error);

        const nome = localStorage.getItem("nomeUsuario") || "Usuário";
        preencherPerfil({ nome, email: "", totalLocaisSalvos: 0, totalSugestoes: 0 });
    }
}

function preencherPerfil(usuario) {
    const nome = usuario.nome || "Usuário";
    const email = usuario.email || "";
    const telefone = usuario.telefone || "";
    const cidade = usuario.cidade || "";
    const fotoUrl = resolverUrlFoto(usuario.fotoUrl);
    const iniciais = gerarIniciais(nome);
    const totalSalvos = usuario.totalLocaisSalvos ?? 0;
    const totalSugestoes = usuario.totalSugestoes ?? 0;

    setTexto("sidebarNome", nome);
    setTexto("sidebarAvatar", iniciais);
    setTexto("heroNome", nome);
    setTexto("heroEmail", email);

    const heroCidade = document.getElementById("heroCidade");
    if (heroCidade) {
        heroCidade.textContent = cidade
            ? `${cidade}${telefone ? " · " + telefone : ""}`
            : (telefone || "");
    }

    const heroPlanoWrap = document.getElementById("heroPlanoWrap");
    const heroPlanoNome = document.getElementById("heroPlanoNome");
    if (usuario.nomePlano && heroPlanoWrap && heroPlanoNome) {
        heroPlanoNome.textContent = usuario.nomePlano;
        heroPlanoWrap.style.display = "";
    } else if (heroPlanoWrap) {
        heroPlanoWrap.style.display = "none";
    }

    atualizarAvatar(fotoUrl, iniciais);

    setTexto("totalSalvos",
        `${totalSalvos} estabelecimento${totalSalvos !== 1 ? "s" : ""} favorito${totalSalvos !== 1 ? "s" : ""}`);
    setTexto("totalSugestoes",
        `${totalSugestoes} sugest${totalSugestoes !== 1 ? "ões" : "ão"} enviada${totalSugestoes !== 1 ? "s" : ""}`);
    setTexto("statSalvos", totalSalvos);
    setTexto("statSugestoes", totalSugestoes);

    aplicarNivelPerfil(usuario.pontos ?? 0);
}

function aplicarNivelPerfil(pontos) {
    const prog = calcularProgressoNivel(pontos);

    const desc = document.getElementById("perfilNivelDesc");
    if (desc) {
        desc.textContent = prog.proximo
            ? `Próximo nível: ${prog.proximo.nome} (Faltam ${formatarPontos(prog.faltaParaProximo)} pts)`
            : `Nível máximo: ${prog.atual.nome}`;
    }

    const badge = document.getElementById("perfilBadgeNivel");
    const badgeTexto = document.getElementById("perfilBadgeTexto");
    if (badge) {
        badge.className = `nivel-badge-grande ${classeNivel(prog.atual.id)}`;
    }
    if (badgeTexto) badgeTexto.textContent = prog.atual.nome;

    setTexto("labelNivelAtual", prog.atual.nome);
    setTexto(
        "labelPontosProgresso",
        prog.proximo
            ? `${formatarPontos(prog.pontosNoNivel)} / ${formatarPontos(prog.pontosParaProximo)} pts`
            : `${formatarPontos(pontos)} pts`
    );
    setTexto("labelProximoNivel", prog.proximo ? prog.proximo.nome : "Máximo");

    const barra = document.getElementById("perfilBarraFill");
    if (barra) barra.style.width = `${prog.percentual}%`;

    const faltam = document.getElementById("perfilFaltamPontos");
    if (faltam) {
        faltam.innerHTML = prog.proximo
            ? `<i class="fas fa-bolt"></i> Faltam ${formatarPontos(prog.faltaParaProximo)} pontos para ${prog.proximo.nome}`
            : `<i class="fas fa-crown"></i> Nível máximo alcançado`;
    }

    const tituloBenef = document.getElementById("perfilBeneficiosTitulo");
    if (tituloBenef) tituloBenef.textContent = `Benefícios ${prog.atual.nome}`;

    const lista = document.getElementById("perfilBeneficiosLista");
    if (lista) {
        lista.innerHTML = beneficiosPorNivel(prog.atual.id)
            .map(
                (b) => `
              <div class="beneficio-item">
                <i class="fas fa-check-circle"></i>
                <span>${b}</span>
              </div>`
            )
            .join("");
    }
}

function setTexto(id, valor) {
    const el = document.getElementById(id);
    if (el) el.textContent = valor;
}

function atualizarAvatar(fotoUrl, iniciais) {
    const img = document.getElementById("avatarImg");
    const iniciaisEl = document.getElementById("avatarIniciais");

    if (!img || !iniciaisEl) return;

    const urlFoto = resolverUrlFoto(fotoUrl);

    if (urlFoto) {
        img.src = urlFoto;
        img.style.display = "block";
        iniciaisEl.style.display = "none";
        iniciaisEl.textContent = iniciais;
    } else {
        img.removeAttribute("src");
        img.style.display = "none";
        iniciaisEl.style.display = "flex";
        iniciaisEl.textContent = iniciais;
    }
}

function resolverUrlFoto(fotoUrl) {
    if (!fotoUrl) return "";

    if (fotoUrl.startsWith("http://") || fotoUrl.startsWith("https://")) {
        return fotoUrl;
    }

    if (fotoUrl.startsWith("/uploads/")) {
        return `http://localhost:8080${fotoUrl}`;
    }

    return `http://localhost:8080/uploads/${fotoUrl}`;
}

async function salvarEdicao() {
    const idUsuario = localStorage.getItem("idUsuario");
    if (!idUsuario) {
        window.location.href = "login.html";
        return;
    }

    const formData = new FormData();
    formData.append("nome", document.getElementById("editNome")?.value?.trim() || "");
    formData.append("telefone", document.getElementById("editTelefone")?.value?.trim() || "");
    formData.append("cidade", document.getElementById("editCidade")?.value?.trim() || "");

    const arquivoFoto = document.getElementById("editFotoFile")?.files?.[0];
    if (arquivoFoto) {
        if (!arquivoFoto.type.startsWith("image/")) {
            mostrarToast("Selecione um arquivo de imagem válido.");
            return;
        }
        if (arquivoFoto.size > 5 * 1024 * 1024) {
            mostrarToast("A imagem deve ter no máximo 5 MB.");
            return;
        }
        formData.append("foto", arquivoFoto);
    }

    try {
        const resposta = await fetch(`${API_BASE}/usuarios/${idUsuario}`, {
            method: "PUT",
            body: formData
        });

        if (!resposta.ok) {
            const erro = await resposta.json();
            throw new Error(erro.message || "Erro ao salvar perfil.");
        }

        usuarioAtual = await resposta.json();
        preencherPerfil(usuarioAtual);

        if (usuarioAtual.nome) {
            localStorage.setItem("nomeUsuario", usuarioAtual.nome);
        }

        fecharModal("modalEdicao");
        mostrarToast("Perfil atualizado com sucesso!");
    } catch (error) {
        console.error("Erro ao salvar perfil:", error);
        mostrarToast(error.message || "Não foi possível salvar o perfil.");
    }
}

function gerarIniciais(nome) {
    if (!nome || !nome.trim()) return "??";

    return nome
        .trim()
        .split(/\s+/)
        .map(parte => parte[0])
        .join("")
        .substring(0, 2)
        .toUpperCase();
}

function mostrarToast(msg) {
    const toast = document.getElementById("toast");
    const texto = document.getElementById("toastMsg");

    if (!toast || !texto) return;

    texto.textContent = msg;
    toast.classList.add("ativo");

    setTimeout(() => {
        toast.classList.remove("ativo");
    }, 3000);
}

function toggleSwitch(element, event) {
    event.stopPropagation();
    element.classList.toggle("ativo");
}

function abrirSecao(secao) {
    const rotas = {
        "locais-salvos": "locaisSalvosCli.html",
        "minhas-sugestoes": "sugestoesCli.html",
        "contribuicao": "#",
        "historico": "#",
        "notificacoes": "#",
        "privacidade": "#"
    };

    if (rotas[secao]) {
        window.location.href = rotas[secao];
    }
}
