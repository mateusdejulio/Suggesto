// ===== ESTADO =====
let categoriaAtiva = 'todos';
let statusAtivo    = 'todos';
let notaSelecionada = 0;

// ===== DADOS DAS SUGESTOES =====
// Usados para detalhes e recriar cards ao adicionar nova sugestão
const dadosSugestoes = {
  1: {
    estabelecimento: 'Café da Praça',
    categoria: 'Atendimento',
    status: 'resolvida',
    nota: 5,
    data: '10 de abril de 2025',
    texto: 'Gostei muito da educação dos funcionários, me senti bem acolhida! Essa equipe de funcionários está funcionando muito bem.',
    resposta: 'Obrigado pelo feedback! Ficamos felizes em saber que nossa equipe está fazendo um ótimo trabalho.',
    pontos: '+300 pts ganhos',
  },
  2: {
    estabelecimento: 'Hospital Mário Gatti',
    categoria: 'Estrutura',
    status: 'analise',
    nota: 3,
    data: '05 de abril de 2025',
    texto: 'Poderiam melhorar a sinalização nos corredores, às vezes é difícil se localizar, algumas salas de atendimento não têm placa de identificação.',
    resposta: null,
    pontos: null,
  },
  3: {
    estabelecimento: 'Restaurante Dona Maria Bistrô',
    categoria: 'Serviço',
    status: 'analise',
    nota: 3,
    data: '28 de março de 2025',
    texto: 'Gostei que o cardápio tem uns pratos bem diferentes, mas meu irmão tem restrição alimentar e não consigo achar nenhum prato mais simples para pedir para ele.',
    resposta: null,
    pontos: null,
  },
  4: {
    estabelecimento: 'SkiFit Academia',
    categoria: 'Atendimento',
    status: 'recusada',
    nota: 3,
    data: '15 de março de 2025',
    texto: 'Os instrutores são muito atenciosos, mas às vezes há poucos disponíveis nos horários de pico.',
    resposta: 'Contratamos novos instrutores para os horários de maior movimento. Agradecemos o retorno!',
    pontos: null,
  },
};

// ===== NAVEGACAO LATERAL =====
document.querySelectorAll('.lateral-item').forEach(item => {
  item.addEventListener('click', e => {
    e.preventDefault();
    document.querySelectorAll('.lateral-item').forEach(i => i.classList.remove('lateral-item-ativo'));
    item.classList.add('lateral-item-ativo');
  });
});

// ===== FECHAR MENUS AO CLICAR FORA =====
document.addEventListener('click', e => {
  if (!e.target.closest('.card-acoes-menu')) {
    document.querySelectorAll('.card-dropdown.aberto').forEach(d => d.classList.remove('aberto'));
  }
});

// ===== TOGGLE MENU DO CARD =====
function toggleMenu(btn) {
  const dropdown = btn.nextElementSibling;
  const estaAberto = dropdown.classList.contains('aberto');
  // Fecha todos
  document.querySelectorAll('.card-dropdown.aberto').forEach(d => d.classList.remove('aberto'));
  if (!estaAberto) dropdown.classList.add('aberto');
}

// ===== FILTRAR (busca + categoria + status + data + ordem) =====
function aplicarFiltros() {
  const busca  = document.getElementById('campoBusca').value.toLowerCase().trim();
  const data   = document.getElementById('filtroData').value;   // '2025-04-10'
  const ordem  = document.getElementById('filtroOrdem').value;

  // Mostra/oculta botão limpar busca
  document.getElementById('btnLimparBusca').classList.toggle('visivel', busca.length > 0);
  document.getElementById('btnLimparData').classList.toggle('visivel', data.length > 0);

  const cards = Array.from(document.querySelectorAll('.sugestao-card'));
  let visiveis = [];

  cards.forEach(card => {
    const nome      = card.dataset.estabelecimento.toLowerCase();
    const texto     = card.querySelector('.card-texto').textContent.toLowerCase();
    const cat       = card.dataset.categoria;
    const stat      = card.dataset.status;
    const cardData  = card.dataset.data; // '2025-04-10'

    const passaBusca    = !busca || nome.includes(busca) || texto.includes(busca);
    const passaCategoria= categoriaAtiva === 'todos' || cat === categoriaAtiva;
    const passaStatus   = statusAtivo === 'todos' || stat === statusAtivo;
    const passaData     = !data || cardData === data;

    const mostrar = passaBusca && passaCategoria && passaStatus && passaData;
    card.style.display = mostrar ? '' : 'none';
    if (mostrar) visiveis.push(card);
  });

  // Ordenação
  const lista = document.getElementById('sugestoesList');
  visiveis.sort((a, b) => {
    if (ordem === 'recente')    return b.dataset.data.localeCompare(a.dataset.data);
    if (ordem === 'antigo')     return a.dataset.data.localeCompare(b.dataset.data);
    if (ordem === 'nota-alta')  return parseInt(b.dataset.nota) - parseInt(a.dataset.nota);
    if (ordem === 'nota-baixa') return parseInt(a.dataset.nota) - parseInt(b.dataset.nota);
    return 0;
  });
  visiveis.forEach(c => lista.appendChild(c));

  // Atualiza contador
  atualizarContador(visiveis.length);

  // Estado vazio
  const temFiltro = busca || data || categoriaAtiva !== 'todos' || statusAtivo !== 'todos';
  document.getElementById('listaVazia').classList.toggle('visivel', visiveis.length === 0);
  document.getElementById('btnLimparTudo').style.display = temFiltro ? 'flex' : 'none';
}

function atualizarContador(n) {
  document.getElementById('resultadosTexto').textContent =
    `${n} sugestão${n !== 1 ? 'ões' : ''} encontrada${n !== 1 ? 's' : ''}`;
}

// ===== FILTRAR CATEGORIA =====
function filtrarCategoria(btn, cat) {
  document.querySelectorAll('.filtros-chips:first-of-type .chip').forEach(b => b.classList.remove('chip-ativo'));
  btn.classList.add('chip-ativo');
  categoriaAtiva = cat;
  aplicarFiltros();
}

// ===== FILTRAR STATUS =====
function filtrarStatus(btn, stat) {
  document.querySelectorAll('.chip-status').forEach(b => b.classList.remove('chip-ativo'));
  btn.classList.add('chip-ativo');
  statusAtivo = stat;
  aplicarFiltros();
}

// ===== LIMPAR =====
function limparBusca() {
  document.getElementById('campoBusca').value = '';
  aplicarFiltros();
}
function limparData() {
  document.getElementById('filtroData').value = '';
  aplicarFiltros();
}
function limparTudo() {
  document.getElementById('campoBusca').value = '';
  document.getElementById('filtroData').value = '';
  document.getElementById('filtroOrdem').value = 'recente';
  categoriaAtiva = 'todos';
  statusAtivo = 'todos';
  // Reset chips
  document.querySelectorAll('.filtros-chips').forEach(grupo => {
    grupo.querySelectorAll('.chip').forEach((b, i) => b.classList.toggle('chip-ativo', i === 0));
  });
  aplicarFiltros();
}

// ===== MODAIS =====
function abrirModal(id) {
  document.getElementById(id).classList.add('aberto');
}
function fecharModal(id) {
  document.getElementById(id).classList.remove('aberto');
}

// Fecha modal ao clicar fora
document.querySelectorAll('.modal-fundo').forEach(fundo => {
  fundo.addEventListener('click', e => {
    if (e.target === fundo) fundo.classList.remove('aberto');
  });
});

// Fecha com Escape
document.addEventListener('keydown', e => {
  if (e.key === 'Escape') {
    document.querySelectorAll('.modal-fundo').forEach(m => m.classList.remove('aberto'));
  }
});

// ===== ESTRELAS DO MODAL =====
function definirNota(n) {
  notaSelecionada = n;
  document.querySelectorAll('.estrela-btn').forEach((s, i) => {
    s.className = i < n ? 'fas fa-star estrela-btn ativa' : 'far fa-star estrela-btn';
  });
}

// Hover nas estrelas
document.querySelectorAll('.estrela-btn').forEach(btn => {
  btn.addEventListener('mouseenter', () => {
    const n = parseInt(btn.dataset.nota);
    document.querySelectorAll('.estrela-btn').forEach((s, i) => {
      s.className = i < n ? 'fas fa-star estrela-btn ativa' : 'far fa-star estrela-btn';
    });
  });
  btn.addEventListener('mouseleave', () => definirNota(notaSelecionada));
});

// ===== ENVIAR SUGESTÃO =====
function enviarSugestao() {
  const estab    = document.getElementById('selectEstabelecimento').value;
  const textarea = document.getElementById('textareaSugestao');

  if (!estab) {
    document.getElementById('selectEstabelecimento').style.borderColor = 'rgba(239,68,68,0.5)';
    setTimeout(() => document.getElementById('selectEstabelecimento').style.borderColor = '', 1500);
    return;
  }
  if (!textarea.value.trim()) {
    textarea.style.borderColor = 'rgba(239,68,68,0.5)';
    setTimeout(() => textarea.style.borderColor = '', 1500);
    return;
  }

  fecharModal('modalSugestao');
  // Reseta
  document.getElementById('selectEstabelecimento').value = '';
  textarea.value = '';
  notaSelecionada = 0;
  document.querySelectorAll('.estrela-btn').forEach(s => s.className = 'far fa-star estrela-btn');

  mostrarToast('Sugestão enviada com sucesso! +300 pts');
  atualizarResumo();
}

// ===== APAGAR SUGESTÃO =====
function apagarSugestao(btn) {
  const card = btn.closest('.sugestao-card');
  card.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
  card.style.opacity = '0';
  card.style.transform = 'translateX(-20px)';

  setTimeout(() => {
    card.remove();
    aplicarFiltros();
    atualizarResumo();
    mostrarToast('Sugestão apagada.');
  }, 300);
}

// ===== EDITAR (placeholder) =====
function editarSugestao(id) {
  document.querySelectorAll('.card-dropdown').forEach(d => d.classList.remove('aberto'));
  mostrarToast('Edição de sugestões em breve!');
}

// ===== VER DETALHES =====
function verDetalhes(id) {
  const d = dadosSugestoes[id];
  if (!d) return;

  document.getElementById('detalheTitulo').textContent = d.estabelecimento;

  const statusTexto = { resolvida: 'Resolvida', analise: 'Em análise', recusada: 'Recusada' };
  const statusCor   = { resolvida: 'status-resolvida', analise: 'status-analise', recusada: 'status-recusada' };
  const statusIco   = { resolvida: 'fa-check-circle', analise: 'fa-clock', recusada: 'fa-times-circle' };

  const estrelas = Array.from({ length: 5 }, (_, i) =>
    `<i class="${i < d.nota ? 'fas' : 'far'} fa-star" style="color:#fbbf24;font-size:16px"></i>`
  ).join('');

  const respostaHtml = d.resposta ? `
    <div class="detalhe-secao">
      <span class="detalhe-label">${d.status === 'recusada' ? 'Motivo da recusa' : 'Resposta do estabelecimento'}</span>
      <div class="card-resposta ${d.status === 'recusada' ? 'card-resposta-recusada' : ''}" style="margin-top:4px">
        <div class="resposta-icone"><i class="fas fa-store"></i></div>
        <div><p class="resposta-texto">${d.resposta}</p></div>
      </div>
    </div>` : '';

  document.getElementById('detalheCorpo').innerHTML = `
    <div class="detalhe-linha">
      <div class="detalhe-secao">
        <span class="detalhe-label">Status</span>
        <span class="card-status ${statusCor[d.status]}" style="width:fit-content;margin-top:4px">
          <i class="fas ${statusIco[d.status]}"></i> ${statusTexto[d.status]}
        </span>
      </div>
      <div class="detalhe-secao">
        <span class="detalhe-label">Categoria</span>
        <span class="detalhe-valor">${d.categoria}</span>
      </div>
      <div class="detalhe-secao">
        <span class="detalhe-label">Data</span>
        <span class="detalhe-valor">${d.data}</span>
      </div>
    </div>
    <div class="detalhe-secao">
      <span class="detalhe-label">Avaliação</span>
      <div style="display:flex;gap:4px;margin-top:4px">${estrelas}</div>
    </div>
    <div class="detalhe-secao">
      <span class="detalhe-label">Sugestão enviada</span>
      <p class="detalhe-valor">${d.texto}</p>
    </div>
    ${respostaHtml}
    ${d.pontos ? `<div class="card-pontos" style="font-size:14px"><i class="fas fa-star"></i> ${d.pontos}</div>` : ''}
  `;

  abrirModal('modalDetalhes');
}

// ===== ATUALIZAR RESUMO =====
function atualizarResumo() {
  const cards = document.querySelectorAll('.sugestao-card');
  const total = cards.length;
  const resolvidas = [...cards].filter(c => c.dataset.status === 'resolvida').length;
  const pendentes  = [...cards].filter(c => c.dataset.status === 'analise').length;

  document.getElementById('totalSugestoes').textContent = total;
  document.getElementById('totalResolvidas').textContent = resolvidas;
  document.getElementById('totalPendentes').textContent = pendentes;
}

// ===== TOAST =====
function mostrarToast(msg) {
  const toast = document.getElementById('toast');
  document.getElementById('toastMsg').textContent = msg;
  toast.classList.add('visivel');
  setTimeout(() => toast.classList.remove('visivel'), 3200);
}

// ===== INIT =====
atualizarContador(document.querySelectorAll('.sugestao-card').length);