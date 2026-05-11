document.addEventListener("DOMContentLoaded", () => {
    iniciarEventos();
    carregarDadosUsuario();
});

/* ================= EVENTOS ================= */

function iniciarEventos() {

    // Botão sair (sidebar)
    document.querySelector(".user-sair")?.addEventListener("click", abrirModalSair);

    // Confirmar saída
    document.querySelector(".botao-modal-perigo")?.addEventListener("click", confirmarSair);

    // Fechar modais
    document.querySelectorAll(".modal-fechar").forEach(btn => {
        btn.addEventListener("click", () => {
            btn.closest(".modal-fundo").classList.remove("aberto");
        });
    });

    // Editar perfil
    document.querySelector(".botao-editar-perfil")?.addEventListener("click", abrirEdicao);

    // Salvar edição
    document.querySelector(".botao-modal")?.addEventListener("click", salvarEdicao);

    // Toggle notificações
    document.querySelectorAll(".toggle").forEach(toggle => {
        toggle.addEventListener("click", (e) => toggleSwitch(toggle, e));
    });

    // Menu lateral do perfil
    document.querySelectorAll(".menu-item").forEach(item => {
        item.addEventListener("click", () => {
            const acao = item.getAttribute("data-acao");
            if (acao) abrirSecao(acao);
        });
    });
}

/* ================= MODAIS ================= */

function abrirModalSair() {
    document.getElementById("modalSaida")?.classList.add("aberto");
}

function abrirEdicao() {
    document.getElementById("modalEdicao")?.classList.add("aberto");
}

function fecharModal(id) {
    document.getElementById(id)?.classList.remove("aberto");
}

/* ================= LOGOUT ================= */

function confirmarSair() {
    localStorage.clear();
    window.location.href = "login.html";
}

/* ================= USUÁRIO ================= */

function carregarDadosUsuario() {
    const usuario = JSON.parse(localStorage.getItem("usuario")) || {
        nome: "Usuário",
        email: "email@exemplo.com"
    };

    // Nome sidebar
    const nomeSidebar = document.getElementById("sidebarNome");
    if (nomeSidebar) nomeSidebar.textContent = usuario.nome;

    // Avatar sidebar
    const avatar = document.getElementById("sidebarAvatar");
    if (avatar) {
        avatar.textContent = gerarIniciais(usuario.nome);
    }

    // Nome perfil
    const nomePerfil = document.querySelector(".hero-nome");
    if (nomePerfil) nomePerfil.textContent = usuario.nome;

    // Email perfil
    const emailPerfil = document.querySelector(".hero-email");
    if (emailPerfil) emailPerfil.textContent = usuario.email;
}

function salvarEdicao() {
    const nome = document.querySelector("input[type='text']").value;
    const email = document.querySelector("input[type='email']").value;

    const usuario = {
        nome,
        email
    };

    localStorage.setItem("usuario", JSON.stringify(usuario));

    carregarDadosUsuario();
    fecharModal("modalEdicao");
    mostrarToast("Perfil atualizado com sucesso!");
}

/* ================= UTIL ================= */

function gerarIniciais(nome) {
    return nome
        .split(" ")
        .map(n => n[0])
        .join("")
        .substring(0, 2)
        .toUpperCase();
}

/* ================= TOAST ================= */

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

/* ================= TOGGLE ================= */

function toggleSwitch(element, event) {
    event.stopPropagation();
    element.classList.toggle("ativo");
}

/* ================= NAVEGAÇÃO ================= */

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