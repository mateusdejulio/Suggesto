// --- CONFIGURAÇÕES ---
const API_BASE_URL = "http://localhost:8080/api/avaliacoes";

// Memória local para os filtros funcionarem rápido
let todasAsSugestoes = [];
let filtrosAtuais = {
  texto: "",
  tipo: "todos",
  categoria: "todos",
  status: "todos",
};

document.addEventListener("DOMContentLoaded", () => {
  carregarDadosUsuario();
  carregarSugestoesDoUsuario();
});

// --- COMUNICAÇÃO COM A API ---
async function carregarSugestoesDoUsuario() {
  const idUsuario = localStorage.getItem("idUsuario") || 11; // Seu ID de teste

  try {
    const resposta = await fetch(`${API_BASE_URL}/usuario/${idUsuario}`);

    if (!resposta.ok) {
      throw new Error(`Falha no servidor. Status: ${resposta.status}`);
    }

    todasAsSugestoes = await resposta.json();

    atualizarResumo(todasAsSugestoes);
    aplicarFiltros(); // Chama a função que desenha a lista com os filtros atuais (que começam em "todos")
  } catch (erro) {
    console.error("Erro na requisição da API:", erro);
    document.getElementById("sugestoesList").innerHTML = `
            <div style="text-align: center; padding: 40px; color: #f87171;">
                <p>Erro ao carregar as sugestões. Verifique o console.</p>
            </div>`;
  }
}

// --- LÓGICA DE FILTROS ---
function aplicarFiltros() {
  filtrosAtuais.texto = document
    .getElementById("campoBusca")
    .value.toLowerCase()
    .trim();

  // Controla o botão de limpar busca
  document.getElementById("btnLimparBusca").style.display = filtrosAtuais.texto
    ? "block"
    : "none";

  // Filtra a lista completa com base no que o usuário clicou
  const listaFiltrada = todasAsSugestoes.filter((sugestao) => {
    // 1. Filtro de Texto (Busca no nome do local ou no comentário)
    const nomeLoja = (
      sugestao.estabelecimento ? sugestao.estabelecimento.nome : ""
    ).toLowerCase();
    const comentario = (sugestao.comentario || "").toLowerCase();
    const passaTexto =
      nomeLoja.includes(filtrosAtuais.texto) ||
      comentario.includes(filtrosAtuais.texto);

    // 2. Filtro de Tipo (Sugestão, Crítica, Elogio)
    const tipoNoBanco = (sugestao.tipo || "").toLowerCase();
    const passaTipo =
      filtrosAtuais.tipo === "todos" || tipoNoBanco === filtrosAtuais.tipo;

    // 3. Filtro de Categoria
    const catNoBanco =
      sugestao.categoria && sugestao.categoria.nomeCategoria
        ? sugestao.categoria.nomeCategoria.toLowerCase()
        : "";
    // Simplificamos a categoria do banco tirando acentos e espaços para comparar com os chips
    const catNormalizada = catNoBanco
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .split(" ")[0];
    const passaCat =
      filtrosAtuais.categoria === "todos" ||
      catNormalizada === filtrosAtuais.categoria;

    // 4. Filtro de Status
    const statusNoBanco = (sugestao.status || "analise").toLowerCase();
    const passaStatus =
      filtrosAtuais.status === "todos" ||
      statusNoBanco === filtrosAtuais.status;

    // A sugestão só aparece se passar em todos os testes!
    return passaTexto && passaTipo && passaCat && passaStatus;
  });

  renderizarLista(listaFiltrada);

  // Atualiza o texto informando quantos resultados encontrou
  const resultadosInfo = document.getElementById("resultadosInfo");
  const textoResultados = document.getElementById("resultadosTexto");
  const btnLimpar = document.getElementById("btnLimparTudo");

  textoResultados.innerText = `${listaFiltrada.length} sugestões encontradas`;

  // Mostra o botão de "Limpar Filtros" se houver algum filtro ativo
  const temFiltro =
    filtrosAtuais.texto ||
    filtrosAtuais.tipo !== "todos" ||
    filtrosAtuais.categoria !== "todos" ||
    filtrosAtuais.status !== "todos";
  btnLimpar.style.display = temFiltro ? "inline-block" : "none";
}

// Funções chamadas pelos cliques nos Chips
function filtrarTipo(botao, valor) {
  document
    .querySelectorAll(".chip-tipo")
    .forEach((b) => b.classList.remove("chip-ativo"));
  botao.classList.add("chip-ativo");
  filtrosAtuais.tipo = valor;
  aplicarFiltros();
}

function filtrarCategoria(botao, valor) {
  document
    .querySelectorAll(".chip-cat")
    .forEach((b) => b.classList.remove("chip-ativo"));
  botao.classList.add("chip-ativo");
  filtrosAtuais.categoria = valor;
  aplicarFiltros();
}

function filtrarStatus(botao, valor) {
  document
    .querySelectorAll(".chip-status")
    .forEach((b) => b.classList.remove("chip-ativo"));
  botao.classList.add("chip-ativo");
  filtrosAtuais.status = valor;
  aplicarFiltros();
}

function limparBusca() {
  document.getElementById("campoBusca").value = "";
  aplicarFiltros();
}

function limparTudo() {
  limparBusca();

  // Reseta todos os filtros para 'todos'
  filtrosAtuais = {
    texto: "",
    tipo: "todos",
    categoria: "todos",
    status: "todos",
  };

  // Reseta o visual dos botões
  document
    .querySelectorAll(".chip")
    .forEach((b) => b.classList.remove("chip-ativo"));
  document
    .querySelector('.chip-tipo[onclick*="todos"]')
    .classList.add("chip-ativo");
  document
    .querySelector('.chip-cat[onclick*="todos"]')
    .classList.add("chip-ativo");
  document
    .querySelector('.chip-status[onclick*="todos"]')
    .classList.add("chip-ativo");

  aplicarFiltros();
}

// --- RENDERIZAÇÃO NA TELA ---
function renderizarLista(sugestoes) {
  const container = document.getElementById("sugestoesList");
  const listaVazia = document.getElementById("listaVazia");

  container.innerHTML = "";

  if (sugestoes.length === 0) {
    listaVazia.style.display = "flex";
    return;
  }

  listaVazia.style.display = "none";

  sugestoes.forEach((sugestao) => {
    // --- 1. Lógica do Status ---
    const statusAtual = (sugestao.status || "analise").toLowerCase();
    const classeStatusFaixa = `card-faixa-${statusAtual}`;
    const classeStatusTexto = `status-${statusAtual}`;

    let iconeStatus = "fa-clock";
    let textoStatus = "Em análise";
    if (statusAtual === "resolvida") {
      iconeStatus = "fa-check-circle";
      textoStatus = "Resolvida";
    }
    if (statusAtual === "recusada") {
      iconeStatus = "fa-times-circle";
      textoStatus = "Recusada";
    }

    // --- 2. Lógica do Tipo Visual (Elogio, Crítica, Sugestão) ---
    const tipoAtual = (sugestao.tipo || "sugestao").toLowerCase();
    let iconeTipo = "💡";
    if (tipoAtual === "critica") iconeTipo = "⚠️";
    if (tipoAtual === "elogio") iconeTipo = "🏆";

    // --- 3. Formatação Diversa ---
    const dataOriginal = sugestao.dataAvaliacao
      ? sugestao.dataAvaliacao.split("T")[0]
      : new Date().toISOString().split("T")[0];
    const dataFormatada = new Date(
      dataOriginal + "T00:00:00",
    ).toLocaleDateString("pt-BR", {
      day: "2-digit",
      month: "long",
      year: "numeric",
    });

    const nomeCategoria = sugestao.categoria
      ? sugestao.categoria.nomeCategoria
      : "Geral";
    const nomeLoja = sugestao.estabelecimento
      ? sugestao.estabelecimento.nome
      : "Estabelecimento";

    const palavras = nomeLoja.trim().split(" ");
    let letrasAvatar = palavras[0].substring(0, 1);
    if (palavras.length > 1) letrasAvatar += palavras[1].substring(0, 1);
    letrasAvatar = letrasAvatar.toUpperCase();

    const cardHTML = `
            <div class="sugestao-card" data-id="${sugestao.idAvaliacao}">
                <div class="card-faixa ${classeStatusFaixa}"></div>
                <div class="card-corpo">
                    <div class="card-topo">
                        <div class="card-esquerda">
                            <div class="card-avatar">${letrasAvatar}</div>
                            <div>
                                <h3 class="card-estabelecimento">${nomeLoja}</h3>
                                <p class="card-data"><i class="fas fa-calendar-alt"></i> ${dataFormatada}</p>
                            </div>
                        </div>
                        <div class="card-direita">
                            <span class="card-status ${classeStatusTexto}">
                                <i class="fas ${iconeStatus}"></i> ${textoStatus}
                            </span>
                        </div>
                    </div>

                    <div class="card-tags">
                        <span class="tag tag-${nomeCategoria
                          .toLowerCase()
                          .normalize("NFD")
                          .replace(/[\u0300-\u036f]/g, "")}">
                            ${iconeTipo} ${nomeCategoria}
                        </span>
                        <div class="card-estrelas">
                            ${gerarEstrelas(sugestao.nota)}
                        </div>
                    </div>

                    <p class="card-texto">${sugestao.comentario}</p>
                </div>
            </div>
        `;

    container.insertAdjacentHTML("beforeend", cardHTML);
  });
}

function gerarEstrelas(nota) {
  let estrelas = "";
  for (let i = 1; i <= 5; i++) {
    estrelas +=
      i <= nota ? '<i class="fas fa-star"></i>' : '<i class="far fa-star"></i>';
  }
  return estrelas;
}

function atualizarResumo(sugestoes) {
  const total = sugestoes.length;
  const resolvidas = sugestoes.filter(
    (s) => (s.status || "").toLowerCase() === "resolvida",
  ).length;
  const pendentes = sugestoes.filter(
    (s) => (s.status || "analise").toLowerCase() === "analise",
  ).length;

  document.getElementById("totalSugestoes").innerText = total;
  document.getElementById("totalResolvidas").innerText = resolvidas;
  document.getElementById("totalPendentes").innerText = pendentes;
}

function abrirModal(idModal) {
  document.getElementById(idModal).style.display = "flex";
}
function fecharModal(idModal) {
  document.getElementById(idModal).style.display = "none";
}
function abrirSugestao() {
  window.location.href = "./fazerSugestao.html";
}

function carregarDadosUsuario() {
    const nome = localStorage.getItem('nomeUsuario') || 'Usuário';

    const elementoSaudacao = document.getElementById('saudacaoNome');
    const elementoSidebar = document.getElementById('sidebarNome');
    const elementoAvatar = document.getElementById('sidebarAvatar');

    if (elementoSaudacao)
        elementoSaudacao.innerText = `Olá, ${nome.split(' ')[0]} 👋`;

    if (elementoSidebar)
        elementoSidebar.innerText = nome;

    if (elementoAvatar)
        elementoAvatar.innerText = nome.substring(0, 2).toUpperCase();
}

function abrirModalSair() { 
    const modal = document.getElementById('modalSair');
    if (modal) modal.classList.add('aberto'); 
}

function fecharModal(id) { 
    const modal = document.getElementById(id);
    if (modal) modal.classList.remove('aberto'); 
}

function confirmarSair() { 
    localStorage.clear(); 
    window.location.href = 'login.html'; 
}