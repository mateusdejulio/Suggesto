// ===== ESTADO GLOBAL =====
const SALDO_ATUAL = 20652;
let resgateAtual = { nome: '', custo: 0 };

// ===== NAVEGACAO LATERAL =====
document.querySelectorAll('.lateral-item').forEach(item => {
  item.addEventListener('click', (e) => {
    e.preventDefault();
    document.querySelectorAll('.lateral-item').forEach(i => i.classList.remove('lateral-item-ativo'));
    item.classList.add('lateral-item-ativo');
  });
});

// ===== FILTRO POR TEXTO =====
function filtrarRecompensas() {
  const busca = document.getElementById('campoBusca').value.toLowerCase();
  const cards = document.querySelectorAll('.recomp-card');
  const secoes = document.querySelectorAll('.recomp-secao');
  const vazio = document.getElementById('mercadoVazio');
  let totalVisivel = 0;

  secoes.forEach(secao => {
    let visivelNaSecao = 0;
    const cardsSecao = secao.querySelectorAll('.recomp-card');

    cardsSecao.forEach(card => {
      const nome = card.querySelector('.recomp-nome').textContent.toLowerCase();
      const estabelecimento = card.querySelector('.recomp-estabelecimento').textContent.toLowerCase();
      const desc = card.querySelector('.recomp-desc').textContent.toLowerCase();
      const visivel = nome.includes(busca) || estabelecimento.includes(busca) || desc.includes(busca);

      card.style.display = visivel ? '' : 'none';
      if (visivel) visivelNaSecao++;
    });

    secao.style.display = visivelNaSecao === 0 ? 'none' : '';
    totalVisivel += visivelNaSecao;
  });

  vazio.classList.toggle('visivel', totalVisivel === 0);
}

// ===== FILTRO POR FAIXA DE PONTOS =====
function filtrarFaixa(botao, limite) {
  // Atualiza chips
  document.querySelectorAll('.faixa-btn').forEach(b => b.classList.remove('faixa-btn-ativa'));
  botao.classList.add('faixa-btn-ativa');

  const secoes = document.querySelectorAll('.recomp-secao');
  const vazio = document.getElementById('mercadoVazio');
  let totalVisivel = 0;

  secoes.forEach(secao => {
    const faixaSecao = parseInt(secao.dataset.faixa);
    const mostrar = faixaSecao <= limite;

    secao.style.display = mostrar ? '' : 'none';
    if (mostrar) {
      const cards = secao.querySelectorAll('.recomp-card');
      cards.forEach(card => { card.style.display = ''; });
      totalVisivel += cards.length;
    }
  });

  // Limpa busca ao trocar faixa
  document.getElementById('campoBusca').value = '';
  vazio.classList.toggle('visivel', totalVisivel === 0);
}

// ===== SALVAR RECOMPENSA =====
function salvarRecomp(botao) {
  const salvo = botao.classList.toggle('salvo');
  botao.innerHTML = salvo
    ? '<i class="fas fa-heart"></i>'
    : '<i class="far fa-heart"></i>';
  mostrarToast(salvo ? 'Recompensa salva nos favoritos!' : 'Removida dos favoritos');
}

// ===== MODAL DE RESGATE =====
function abrirResgate(nome, custo) {
  // Verifica se tem saldo suficiente
  if (custo > SALDO_ATUAL) {
    mostrarToast('Pontos insuficientes para este resgate');
    return;
  }

  resgateAtual = { nome, custo };

  const saldoFinal = SALDO_ATUAL - custo;

  document.getElementById('modalRecompNome').textContent = nome;
  document.getElementById('modalRecompCusto').textContent = formatarPontos(custo) + ' pts';
  document.getElementById('modalCustoValor').textContent = '- ' + formatarPontos(custo) + ' pts';
  document.getElementById('modalSaldoFinal').textContent = formatarPontos(saldoFinal) + ' pts';

  document.getElementById('modalResgate').classList.add('aberto');
}

function fecharModal() {
  document.getElementById('modalResgate').classList.remove('aberto');
}

// Fecha ao clicar no fundo
document.getElementById('modalResgate').addEventListener('click', (e) => {
  if (e.target === e.currentTarget) fecharModal();
});

// Fecha com Escape
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') fecharModal();
});

// ===== CONFIRMAR RESGATE =====
function confirmarResgate() {
  fecharModal();

  // Atualiza saldo visual
  const novoSaldo = SALDO_ATUAL - resgateAtual.custo;
  const elemSaldo = document.getElementById('saldoPontos');
  animarContador(elemSaldo, SALDO_ATUAL, novoSaldo, 800);

  mostrarToast(`Resgate de "${resgateAtual.nome}" realizado! Verifique seu e-mail.`);
}

// ===== TROCAR LOCALIZACAO =====
function trocarLocalizacao() {
  const enderecos = [
    'Rua Assis, Vila Lemos, Nº 40 — Campinas',
    'Av. Norte Sul, Centro, Nº 120 — Campinas',
    'R. Padre Vieira, Cambuí, Nº 88 — Campinas',
  ];
  const atual = document.getElementById('enderecoUsuario').textContent;
  const proximo = enderecos[(enderecos.indexOf(atual) + 1) % enderecos.length];
  document.getElementById('enderecoUsuario').textContent = proximo;
  mostrarToast('Localização atualizada!');
}

// ===== TOAST =====
function mostrarToast(mensagem) {
  const toast = document.getElementById('toast');
  document.getElementById('toastMsg').textContent = mensagem;
  toast.classList.add('visivel');
  setTimeout(() => toast.classList.remove('visivel'), 3200);
}

// ===== UTILITARIOS =====
function formatarPontos(valor) {
  return valor.toLocaleString('pt-BR');
}

function animarContador(el, de, ate, duracao) {
  const inicio = performance.now();
  function passo(agora) {
    const progresso = Math.min((agora - inicio) / duracao, 1);
    const easeOut = 1 - Math.pow(1 - progresso, 3);
    const atual = Math.round(de + (ate - de) * easeOut);
    el.textContent = formatarPontos(atual);
    if (progresso < 1) requestAnimationFrame(passo);
  }
  requestAnimationFrame(passo);
}

// ===== ANIMACAO DE ENTRADA DAS SECOES =====
const observador = new IntersectionObserver((entradas) => {
  entradas.forEach(entrada => {
    if (entrada.isIntersecting) {
      entrada.target.style.opacity = '1';
      entrada.target.style.transform = 'translateY(0)';
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.recomp-secao').forEach((secao, i) => {
  secao.style.opacity = '0';
  secao.style.transform = 'translateY(20px)';
  secao.style.transition = `opacity 0.5s ease ${i * 0.1}s, transform 0.5s ease ${i * 0.1}s`;
  observador.observe(secao);
});