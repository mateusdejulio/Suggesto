// ===== CARREGAR DADOS DO USUÁRIO (localStorage) =====
document.addEventListener('DOMContentLoaded', () => {
  carregarDadosUsuario();
  atualizarContador();
});

function carregarDadosUsuario() {
  const nomeCompleto = localStorage.getItem('nomeUsuario') || 'Cliente';
  const primeiroNome = nomeCompleto.split(' ')[0];

  const partes = nomeCompleto.split(' ');
  let iniciais = partes[0].charAt(0).toUpperCase();
  if (partes.length > 1) {
    iniciais += partes[partes.length - 1].charAt(0).toUpperCase();
  }

  const elNome = document.getElementById('sidebarNome');
  const elAvatar = document.getElementById('sidebarAvatar');
  if (elNome) elNome.innerText = nomeCompleto;
  if (elAvatar) elAvatar.innerText = iniciais;
}


// ===== FILTRO DE BUSCA =====
function filtrarLocais() {
  const busca = document.getElementById('campoBusca').value.toLowerCase();
  const cards = document.querySelectorAll('#locaisGrade .local-card');
  const vazio = document.getElementById('locaisVazio');
  let visiveis = 0;

  cards.forEach(card => {
    const nome = card.querySelector('.local-nome').textContent.toLowerCase();
    const endereco = card.querySelector('.local-endereco').textContent.toLowerCase();
    const visivel = nome.includes(busca) || endereco.includes(busca);
    card.style.display = visivel ? '' : 'none';
    if (visivel) visiveis++;
  });

  vazio.classList.toggle('visivel', visiveis === 0);
  atualizarContador();
}


// ===== FILTRO POR CATEGORIA =====
function filtrarCategoria(botao, categoria) {
  document.querySelectorAll('.filtro-chip').forEach(b => b.classList.remove('filtro-chip-ativo'));
  botao.classList.add('filtro-chip-ativo');

  const cards = document.querySelectorAll('#locaisGrade .local-card');
  const vazio = document.getElementById('locaisVazio');
  let visiveis = 0;

  cards.forEach(card => {
    const cat = card.dataset.categoria;
    const visivel = categoria === 'todos' || cat === categoria;
    card.style.display = visivel ? '' : 'none';
    if (visivel) visiveis++;
  });

  vazio.classList.toggle('visivel', visiveis === 0);
  atualizarContador();
}


// ===== LIMPAR FILTROS =====
function limparFiltros() {
  document.getElementById('campoBusca').value = '';
  const chips = document.querySelectorAll('.filtro-chip');
  chips.forEach(c => c.classList.remove('filtro-chip-ativo'));
  chips[0].classList.add('filtro-chip-ativo');

  document.querySelectorAll('#locaisGrade .local-card').forEach(c => c.style.display = '');
  document.getElementById('locaisVazio').classList.remove('visivel');
  atualizarContador();
}


// ===== ORDENAÇÃO =====
function ordenarLocais() {
  const criterio = document.getElementById('selectOrdenacao').value;
  const grade = document.getElementById('locaisGrade');
  const cards = Array.from(grade.querySelectorAll('.local-card'));

  cards.sort((a, b) => {
    if (criterio === 'nome') {
      return a.dataset.nome.localeCompare(b.dataset.nome);
    } else if (criterio === 'avaliacao') {
      return parseFloat(b.dataset.avaliacao) - parseFloat(a.dataset.avaliacao);
    }
    return 0; // 'recente': ordem original
  });

  cards.forEach(card => grade.appendChild(card));
}


// ===== REMOVER LOCAL =====
let cardParaRemover = null;

function confirmarRemover(botao) {
  cardParaRemover = botao.closest('.local-card');
  const nome = cardParaRemover.querySelector('.local-nome').textContent;
  document.getElementById('modalRemoverNome').textContent =
    `"${nome}" será removido da sua lista de salvos.`;

  abrirModal('modalRemover');

  document.getElementById('btnConfirmarRemover').onclick = () => {
    if (!cardParaRemover) return;
    const nomeLocal = cardParaRemover.querySelector('.local-nome').textContent;

    cardParaRemover.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
    cardParaRemover.style.opacity = '0';
    cardParaRemover.style.transform = 'scale(0.95)';

    setTimeout(() => {
      cardParaRemover.remove();
      cardParaRemover = null;
      fecharModal('modalRemover');
      atualizarContador();
      mostrarToast(`"${nomeLocal}" removido dos salvos.`);

      const cards = document.querySelectorAll('#locaisGrade .local-card');
      if (cards.length === 0) {
        document.getElementById('locaisVazio').classList.add('visivel');
      }
    }, 300);
  };
}


// ===== ATUALIZAR CONTADOR DE SALVOS =====
function atualizarContador() {
  const total = document.querySelectorAll('#locaisGrade .local-card').length;
  const el = document.getElementById('totalSalvos');
  if (el) el.textContent = total;
}


// ===== MODAL DE SUGESTÃO =====
function abrirSugestaoLocal(nomeLocal) {
  document.getElementById('modalLocalNome').textContent = nomeLocal;

  const select = document.querySelector('#modalSugestao select');
  for (let opt of select.options) {
    if (opt.text === nomeLocal) { select.value = opt.value; break; }
  }

  abrirModal('modalSugestao');
}

function enviarSugestao() {
  const textarea = document.querySelector('#modalSugestao .campo-textarea');
  if (!textarea.value.trim()) {
    textarea.style.borderColor = 'rgba(239,68,68,0.5)';
    setTimeout(() => textarea.style.borderColor = '', 1500);
    return;
  }
  fecharModal('modalSugestao');
  textarea.value = '';
  mostrarToast('Sugestão enviada com sucesso!');
}


// ===== MODAIS GENÉRICOS =====
function abrirModal(id) {
  document.getElementById(id).classList.add('aberto');
}

function fecharModal(id) {
  document.getElementById(id).classList.remove('aberto');
  document.getElementById(id).style.display = '';
}

document.querySelectorAll('.modal-fundo').forEach(fundo => {
  fundo.addEventListener('click', (e) => {
    if (e.target === fundo) fundo.classList.remove('aberto');
  });
});

document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    document.querySelectorAll('.modal-fundo').forEach(m => m.classList.remove('aberto'));
  }
});


// ===== MODAL SAIR =====
function abrirModalSair() {
  abrirModal('modalSair');
}

function confirmarSair() {
  localStorage.clear();
  sessionStorage.clear();
  window.location.href = 'login.html';
}


// ===== TOAST =====
let toastTimeout;

function mostrarToast(mensagem) {
  clearTimeout(toastTimeout);
  const toast = document.getElementById('toast');
  document.getElementById('toastMsg').textContent = mensagem;
  toast.classList.add('visivel');
  toastTimeout = setTimeout(() => toast.classList.remove('visivel'), 3000);
};


function abrirLocal(estab) {
  sessionStorage.setItem('loc_nome', estab.nome);
  sessionStorage.setItem('loc_endereco', estab.endereco);
  sessionStorage.setItem('loc_telefone', estab.telefone);
  sessionStorage.setItem('loc_horario', estab.horario);
  sessionStorage.setItem('loc_fecha', estab.fecha);
  sessionStorage.setItem('loc_nota', estab.nota);
  sessionStorage.setItem('loc_avaliacoes', estab.avaliacoes);
  sessionStorage.setItem('loc_logo', estab.logo);

  window.location.href = 'estabelecimentoCli.html';
}

function abrirLocalCard(card) {
  sessionStorage.setItem('loc_nome', card.dataset.nome);
  sessionStorage.setItem('loc_endereco', card.dataset.endereco);
  sessionStorage.setItem('loc_telefone', card.dataset.telefone);
  sessionStorage.setItem('loc_horario', card.dataset.horario);
  sessionStorage.setItem('loc_fecha', card.dataset.fecha);
  sessionStorage.setItem('loc_nota', card.dataset.nota);
  sessionStorage.setItem('loc_avaliacoes', card.dataset.avaliacoes);
  sessionStorage.setItem('loc_logo', card.dataset.logo);

  window.location.href = 'mapaCli.html';
}

function salvarRecomp(event, btn) {
  event.stopPropagation(); // 🔥 impede o redirecionamento

  // sua lógica de salvar
  btn.classList.toggle("ativo");
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