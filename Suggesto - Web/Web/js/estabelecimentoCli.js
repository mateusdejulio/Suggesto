// =====================================================================
// estabelecimentoCli.js
//
// Tela de sugestões do estabelecimento — intermediária entre a lista
// de locais e o mapa.
//
// Como navegar para esta tela a partir de outra página:
//   sessionStorage.setItem('est_nome',      'Big Jack Hamburgueria');
//   sessionStorage.setItem('est_categoria', 'Restaurante');
//   sessionStorage.setItem('est_endereco',  'R. Oliveira Cardoso, 376, Campinas, SP');
//   sessionStorage.setItem('est_telefone',  '(19) 3210-3025');
//   sessionStorage.setItem('est_horario',   'Seg. a Dom.: 11:00 – 22:30');
//   sessionStorage.setItem('est_fecha',     '22:30');
//   sessionStorage.setItem('est_nota',      '4.8');
//   sessionStorage.setItem('est_avaliacoes','127');
//   sessionStorage.setItem('est_logo',      'imagens/bigjack.png');
//   window.location.href = 'estabelecimentoCli.html';
// =====================================================================


// ── DADOS DO ESTABELECIMENTO ─────────────────────────────────────────
const est = {
  nome:       sessionStorage.getItem('est_nome')       || 'Big Jack Hamburgueria',
  categoria:  sessionStorage.getItem('est_categoria')  || 'Restaurante',
  endereco:   sessionStorage.getItem('est_endereco')   || 'R. Oliveira Cardoso, 376, Jardim Chapadão, Campinas, SP',
  telefone:   sessionStorage.getItem('est_telefone')   || '(19) 3210-3025',
  horario:    sessionStorage.getItem('est_horario')    || 'Seg. a Dom.: 11:00 – 22:30',
  fecha:      sessionStorage.getItem('est_fecha')      || '22:30',
  nota:       sessionStorage.getItem('est_nota')       || '4.8',
  avaliacoes: sessionStorage.getItem('est_avaliacoes') || '127',
  logo:       sessionStorage.getItem('est_logo')       || 'imagens/bigjack.png',
};

// Limpa o sessionStorage após ler
['est_nome','est_categoria','est_endereco','est_telefone',
 'est_horario','est_fecha','est_nota','est_avaliacoes','est_logo']
  .forEach(k => sessionStorage.removeItem(k));


// ── SUGESTÕES DE EXEMPLO ─────────────────────────────────────────────
// Em produção, essas sugestões viriam de uma API/banco de dados.
// Por enquanto, usamos dados fictícios para demonstrar a interface.
const sugestoesExemplo = [
  {
    id: 1,
    usuario: 'Maria S.',
    iniciais: 'MS',
    data: 'há 2 dias',
    categoria: 'Atendimento',
    texto: 'O atendimento poderia ser mais rápido nos horários de pico. Esperei mais de 20 minutos para ser atendido numa terça-feira ao meio-dia.',
    likes: 12,
    curtido: false,
    visita: 'Esta semana',
    resposta: {
      texto: 'Olá Maria! Obrigado pelo feedback. Estamos treinando novos funcionários para melhorar o tempo de atendimento nos horários de pico. Volte em breve!'
    }
  },
  {
    id: 2,
    usuario: 'Carlos M.',
    iniciais: 'CM',
    data: 'há 5 dias',
    categoria: 'Produto',
    texto: 'Sugestão: adicionar opção de hambúrguer vegetariano ou vegano ao cardápio. Tenho amigos que não comem carne e ficamos sem opção para indicar o lugar.',
    likes: 28,
    curtido: false,
    visita: 'Semana passada',
    resposta: null
  },
  {
    id: 3,
    usuario: 'Ana L.',
    iniciais: 'AL',
    data: 'há 1 semana',
    categoria: 'Estrutura',
    texto: 'O espaço é muito bom, mas seria ótimo ter mais tomadas disponíveis para carregar celular. Muitas pessoas trabalham de lá durante a semana.',
    likes: 9,
    curtido: false,
    visita: 'Semana passada',
    resposta: null
  },
  {
    id: 4,
    usuario: 'Pedro R.',
    iniciais: 'PR',
    data: 'há 2 semanas',
    categoria: 'Atendimento',
    texto: 'Excelente atendimento! Só sugiro que o sistema de senhas seja melhorado — fica difícil ouvir quando chamam o número.',
    likes: 6,
    curtido: false,
    visita: 'Semana passada',
    resposta: {
      texto: 'Olá Pedro! Já estamos avaliando um sistema de display para facilitar a visualização dos pedidos. Obrigado pela sugestão!'
    }
  },
  {
    id: 5,
    usuario: 'Julia F.',
    iniciais: 'JF',
    data: 'há 3 semanas',
    categoria: 'Limpeza',
    texto: 'Os banheiros precisam de atenção com mais frequência, especialmente nos finais de semana quando o movimento é maior.',
    likes: 17,
    curtido: false,
    visita: 'Mais de 15 dias',
    resposta: null
  },
];

// ── ESTADO ───────────────────────────────────────────────────────────
let salvo = false;
let filtroAtivo = 'todas';
let sugestoes = [...sugestoesExemplo];


// ── INICIALIZA ────────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  carregarDadosUsuario();
  preencherHeader();
  verificarStatus();
  verificarSeFavorito();
  renderizarResumo();
  renderizarSugestoes();
  configurarContador();
});


// ── CARREGAR NOME DO USUÁRIO ─────────────────────────────────────────
function carregarDadosUsuario() {
  const nomeCompleto = localStorage.getItem('nomeUsuario') || 'Cliente';
  const partes = nomeCompleto.split(' ');
  let iniciais = partes[0].charAt(0).toUpperCase();
  if (partes.length > 1) iniciais += partes[partes.length - 1].charAt(0).toUpperCase();

  const elNome = document.getElementById('sidebarNome');
  const elAvatar = document.getElementById('sidebarAvatar');
  if (elNome) elNome.innerText = nomeCompleto;
  if (elAvatar) elAvatar.innerText = iniciais;
}


// ── PREENCHER HEADER ─────────────────────────────────────────────────
function preencherHeader() {
  document.title = `${est.nome} — Suggesto`;

  document.getElementById('nomeEstab').textContent      = est.nome;
  document.getElementById('notaEstab').textContent      = est.nota;
  document.getElementById('totalAvaliacoes').textContent = `(${est.avaliacoes})`;
  document.getElementById('categoriaEstab').textContent  = est.categoria;
  document.getElementById('enderecoCurto').textContent   = est.endereco.split(',').slice(-2).join(',').trim();
  document.getElementById('enderecoCompleto').textContent = est.endereco;
  document.getElementById('horarioEstab').textContent    = est.horario;
  document.getElementById('telefoneEstab').textContent   = est.telefone;
  document.getElementById('modalNomeEstab').textContent  = est.nome;

  // Logo
  const logo = document.getElementById('logoEstab');
  if (est.logo) {
    logo.src = est.logo;
  } else {
    logo.style.display = 'none';
    document.getElementById('logoPlaceholder').style.display = 'flex';
  }
}


// ── VERIFICAR STATUS ABERTO/FECHADO ──────────────────────────────────
function verificarStatus() {
  const agora = new Date();
  const [hF, mF] = est.fecha.split(':').map(Number);
  const fechaMin = hF * 60 + mF;
  const agoraMin = agora.getHours() * 60 + agora.getMinutes();
  const aberto = agoraMin >= 10 * 60 && agoraMin < fechaMin;

  const dot   = document.getElementById('statusDot');
  const texto = document.getElementById('statusTexto');
  const hora  = document.getElementById('statusHora');

  dot.className     = `status-dot ${aberto ? 'status-aberto' : 'status-fechado'}`;
  texto.textContent = aberto ? 'Aberto' : 'Fechado';
  texto.className   = `status-texto${aberto ? '' : ' fechado'}`;
  hora.textContent  = aberto ? `Fecha às ${est.fecha}` : 'Abre amanhã às 11:00';
}


// ── RESUMO DE AVALIAÇÃO ───────────────────────────────────────────────
function renderizarResumo() {
  const nota = parseFloat(est.nota);
  const total = parseInt(est.avaliacoes);

  // Estrelas
  const el = document.getElementById('resumoEstrelas');
  document.getElementById('resumoNota').textContent = est.nota;
  document.getElementById('resumoTotal').textContent = `${total} avaliações`;

  el.innerHTML = '';
  for (let i = 1; i <= 5; i++) {
    const star = document.createElement('i');
    star.className = i <= Math.round(nota) ? 'fas fa-star' : 'fas fa-star vazia';
    el.appendChild(star);
  }

  // Barras de distribuição (simuladas com base na nota)
  const dist = gerarDistribuicao(nota, total);
  const barrasEl = document.getElementById('resumoBarras');
  barrasEl.innerHTML = '';

  for (let i = 5; i >= 1; i--) {
    const pct = total > 0 ? Math.round((dist[i] / total) * 100) : 0;
    barrasEl.innerHTML += `
      <div class="barra-linha">
        <span class="barra-label">${i}</span>
        <div class="barra-track">
          <div class="barra-fill" style="width:${pct}%"></div>
        </div>
        <span class="barra-qtd">${dist[i]}</span>
      </div>`;
  }
}

// Gera distribuição de avaliações com base na nota média
function gerarDistribuicao(nota, total) {
  const pesos = { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 };
  if (nota >= 4.5)      { pesos[5] = 0.6; pesos[4] = 0.25; pesos[3] = 0.1; pesos[2] = 0.03; pesos[1] = 0.02; }
  else if (nota >= 4.0) { pesos[5] = 0.4; pesos[4] = 0.35; pesos[3] = 0.15; pesos[2] = 0.07; pesos[1] = 0.03; }
  else if (nota >= 3.0) { pesos[5] = 0.2; pesos[4] = 0.3; pesos[3] = 0.3; pesos[2] = 0.15; pesos[1] = 0.05; }
  else                   { pesos[5] = 0.05; pesos[4] = 0.1; pesos[3] = 0.2; pesos[2] = 0.35; pesos[1] = 0.3; }

  let acum = 0;
  const dist = {};
  [5, 4, 3, 2].forEach(n => {
    dist[n] = Math.round(total * pesos[n]);
    acum += dist[n];
  });
  dist[1] = total - acum;
  return dist;
}


// ── RENDERIZAR SUGESTÕES ──────────────────────────────────────────────
function renderizarSugestoes() {
  const lista = document.getElementById('listaSugestoes');
  const vazio = document.getElementById('vazio');

  const filtradas = filtroAtivo === 'todas'
    ? sugestoes
    : sugestoes.filter(s => s.categoria.toLowerCase().includes(filtroAtivo.toLowerCase()));

  if (filtradas.length === 0) {
    lista.innerHTML = '';
    vazio.style.display = 'flex';
    return;
  }

  vazio.style.display = 'none';
  lista.innerHTML = filtradas.map(s => `
    <div class="sugestao-card" id="card-${s.id}">
      <div class="sug-topo">
        <div class="sug-usuario">
          <div class="sug-avatar">${s.iniciais}</div>
          <div class="sug-user-info">
            <span class="sug-nome">${s.usuario}</span>
            <span class="sug-data">${s.data}</span>
          </div>
        </div>
        <span class="sug-categoria">${s.categoria}</span>
      </div>

      <p class="sug-texto">${s.texto}</p>

      ${s.resposta ? `
        <div class="sug-resposta">
          <div class="sug-resp-header">
            <i class="fas fa-store"></i>
            <span>Resposta do estabelecimento</span>
          </div>
          <p class="sug-resp-texto">${s.resposta.texto}</p>
        </div>
      ` : ''}

      <div class="sug-rodape">
        <button class="sug-likes ${s.curtido ? 'curtido' : ''}" onclick="curtir(${s.id})">
          <i class="${s.curtido ? 'fas' : 'far'} fa-thumbs-up"></i>
          ${s.likes} ${s.likes === 1 ? 'pessoa achou útil' : 'pessoas acharam útil'}
        </button>
        <span class="sug-visita">Visita: ${s.visita}</span>
      </div>
    </div>
  `).join('');
}


// ── FILTRAR SUGESTÕES ─────────────────────────────────────────────────
function filtrar(botao, categoria) {
  document.querySelectorAll('.filtro').forEach(b => b.classList.remove('ativo'));
  botao.classList.add('ativo');
  filtroAtivo = categoria;
  renderizarSugestoes();
}


// ── CURTIR SUGESTÃO ───────────────────────────────────────────────────
function curtir(id) {
  const sug = sugestoes.find(s => s.id === id);
  if (!sug) return;

  sug.curtido = !sug.curtido;
  sug.likes += sug.curtido ? 1 : -1;
  renderizarSugestoes();
}


// ── ABAS DE NAVEGAÇÃO ─────────────────────────────────────────────────
function trocarAba(botao, id) {
  document.querySelectorAll('.aba').forEach(b => b.classList.remove('ativa'));
  botao.classList.add('ativa');

  document.querySelectorAll('.aba-corpo').forEach(c => c.classList.add('oculto'));
  const alvo = document.getElementById('aba-' + id);
  if (alvo) {
    alvo.classList.remove('oculto');
    alvo.style.opacity = '0';
    requestAnimationFrame(() => {
      alvo.style.transition = 'opacity 0.25s ease';
      alvo.style.opacity = '1';
    });
  }
}


// ── SALVAR LOCAL ─────────────────────────────────────────────────────
function salvarLocal() {
  salvo = !salvo;
  const btn = document.getElementById('btnSalvar');
  const icone = document.getElementById('iconeSalvar');

  btn.classList.toggle('salvo', salvo);
  icone.className = salvo ? 'fas fa-bookmark' : 'far fa-bookmark';
  mostrarToast(salvo ? 'Local salvo nos favoritos!' : 'Local removido dos favoritos');

  const favoritos = JSON.parse(localStorage.getItem('sg_favoritos') || '[]');
  if (salvo) {
    if (!favoritos.includes(est.nome)) favoritos.push(est.nome);
  } else {
    const idx = favoritos.indexOf(est.nome);
    if (idx > -1) favoritos.splice(idx, 1);
  }
  localStorage.setItem('sg_favoritos', JSON.stringify(favoritos));
}

function verificarSeFavorito() {
  const favoritos = JSON.parse(localStorage.getItem('sg_favoritos') || '[]');
  if (favoritos.includes(est.nome)) {
    salvo = true;
    document.getElementById('btnSalvar').classList.add('salvo');
    document.getElementById('iconeSalvar').className = 'fas fa-bookmark';
  }
}


// ── IR PARA O MAPA ────────────────────────────────────────────────────
// Passa os dados para a tela de mapa existente via sessionStorage
function irParaMapa() {
  sessionStorage.setItem('loc_nome',       est.nome);
  sessionStorage.setItem('loc_endereco',   est.endereco);
  sessionStorage.setItem('loc_telefone',   est.telefone);
  sessionStorage.setItem('loc_horario',    est.horario);
  sessionStorage.setItem('loc_fecha',      est.fecha);
  sessionStorage.setItem('loc_nota',       est.nota);
  sessionStorage.setItem('loc_avaliacoes', est.avaliacoes);
  sessionStorage.setItem('loc_logo',       est.logo);
  window.location.href = 'mapaCli.html';
}


// ── LIGAR ────────────────────────────────────────────────────────────
function ligarPara() {
  const numero = est.telefone.replace(/\D/g, '');
  window.location.href = `tel:${numero}`;
}


// ── MODAL: NOVA SUGESTÃO ──────────────────────────────────────────────
function abrirModal() {
  document.getElementById('modalSugestao').classList.add('aberto');
}

function fecharModal() {
  document.getElementById('modalSugestao').classList.remove('aberto');
}

document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('modalSugestao').addEventListener('click', e => {
    if (e.target === document.getElementById('modalSugestao')) fecharModal();
  });
});

document.addEventListener('keydown', e => {
  if (e.key === 'Escape') fecharModal();
});

function enviarSugestao() {
  const texto = document.getElementById('textSugestao').value.trim();
  if (!texto) {
    const campo = document.getElementById('textSugestao');
    campo.style.borderColor = 'rgba(248,113,113,0.6)';
    setTimeout(() => campo.style.borderColor = '', 1800);
    return;
  }

  const categoria = document.getElementById('selectCategoria').value;
  const visita    = document.getElementById('selectVisita').value;

  // Adiciona a sugestão no topo da lista
  const nova = {
    id: Date.now(),
    usuario: localStorage.getItem('nomeUsuario') || 'Você',
    iniciais: obterIniciais(localStorage.getItem('nomeUsuario') || 'VC'),
    data: 'agora',
    categoria,
    texto,
    likes: 0,
    curtido: false,
    visita,
    resposta: null,
  };

  sugestoes.unshift(nova);
  fecharModal();
  document.getElementById('textSugestao').value = '';
  document.getElementById('contador').textContent = '0/300';
  filtroAtivo = 'todas';
  document.querySelectorAll('.filtro').forEach((b, i) => b.classList.toggle('ativo', i === 0));
  renderizarSugestoes();
  mostrarToast('Sugestão enviada com sucesso!');
}

function obterIniciais(nome) {
  const p = nome.split(' ');
  let ini = p[0].charAt(0).toUpperCase();
  if (p.length > 1) ini += p[p.length - 1].charAt(0).toUpperCase();
  return ini;
}


// ── CONTADOR DO TEXTAREA ──────────────────────────────────────────────
function configurarContador() {
  const textarea = document.getElementById('textSugestao');
  const contador = document.getElementById('contador');
  if (!textarea || !contador) return;

  textarea.addEventListener('input', () => {
    const len = textarea.value.length;
    contador.textContent = `${len}/300`;
    if (len > 280) contador.style.color = '#f87171';
    else contador.style.color = '';
    if (len > 300) textarea.value = textarea.value.slice(0, 300);
  });
}


// ── TOAST ────────────────────────────────────────────────────────────
function mostrarToast(msg, tipo = 'sucesso') {
  const toast = document.getElementById('toast');
  const icone = document.getElementById('toastIcone');
  const msgEl = document.getElementById('toastMsg');

  msgEl.textContent = msg;
  icone.className   = tipo === 'erro' ? 'fas fa-exclamation-circle' : 'fas fa-check-circle';
  toast.classList.toggle('erro', tipo === 'erro');
  toast.classList.add('visivel');
  setTimeout(() => toast.classList.remove('visivel'), 3200);
}


// ── SAIR ─────────────────────────────────────────────────────────────
function confirmarSair() {
  localStorage.clear();
  sessionStorage.clear();
  window.location.href = 'login.html';
}