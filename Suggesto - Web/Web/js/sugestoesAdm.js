 // ── FILTRO POR STATUS ──
  let statusAtivo = 'todos';
  let catAtiva = 'todas';

  function filtrarStatus(btn, status) {
    statusAtivo = status;
    document.querySelectorAll('.filtro-chip').forEach(b => b.classList.remove('ativo'));
    btn.classList.add('ativo');
    aplicarFiltros();
  }

  // ── FILTRO POR CATEGORIA ──
  function filtrarCategoria(item, cat) {
    catAtiva = cat;
    document.querySelectorAll('.cat-item').forEach(i => i.classList.remove('ativo'));
    item.classList.add('ativo');
    aplicarFiltros();
  }

  // ── FILTRO POR BUSCA ──
  function filtrarBusca() { aplicarFiltros(); }

  // ── APLICAR TODOS OS FILTROS ──
  function aplicarFiltros() {
    const busca = document.getElementById('campoBusca').value.toLowerCase();
    const cards = document.querySelectorAll('.sugestao-card');
    const vazio = document.getElementById('listaVazia');
    let visiveis = 0;

    cards.forEach(card => {
      const status  = card.dataset.status;
      const cat     = card.dataset.cat;
      const titulo  = card.dataset.titulo.toLowerCase();

      const passaStatus = statusAtivo === 'todos' || status === statusAtivo;
      const passCat     = catAtiva === 'todas' || cat === catAtiva;
      const passBusca   = titulo.includes(busca);

      const visivel = passaStatus && passCat && passBusca;
      card.style.display = visivel ? '' : 'none';
      if (visivel) visiveis++;
    });

    vazio.classList.toggle('visivel', visiveis === 0);
  }

  // ── ORDENAR ──
  function ordenarLista(criterio) {
    const lista = document.getElementById('listaSugestoes');
    const cards = [...lista.querySelectorAll('.sugestao-card')];

    cards.sort((a, b) => {
      if (criterio === 'recente') return parseInt(a.dataset.tempo) - parseInt(b.dataset.tempo);
      if (criterio === 'antigo')  return parseInt(b.dataset.tempo) - parseInt(a.dataset.tempo);
      if (criterio === 'az')      return a.dataset.titulo.localeCompare(b.dataset.titulo);
    });

    cards.forEach(c => lista.appendChild(c));
  }

  // ── MUDAR STATUS DO CARD ──
  function mudarStatus(btn, novoStatus) {
    const card = btn.closest('.sugestao-card');
    const pill = card.querySelector('.pill');
    const acoes = card.querySelector('.sugestao-acoes');

    // Atualiza classes
    card.className = `sugestao-card ${novoStatus}`;
    card.dataset.status = novoStatus;

    // Atualiza pill
    const labels = { pendente: 'Pendente', analise: 'Em análise', implementado: 'Implementado', recusado: 'Recusado' };
    pill.className = `pill ${novoStatus}`;
    pill.textContent = labels[novoStatus];

    // Atualiza ações
    if (novoStatus === 'implementado') {
      acoes.innerHTML = '<span style="font-size:12px;color:var(--green);">✅ Concluído e implementado</span>';
    } else if (novoStatus === 'recusado') {
      acoes.innerHTML = '<span style="font-size:12px;color:var(--red);">❌ Sugestão não aprovada</span>';
    } else if (novoStatus === 'analise') {
      acoes.innerHTML = `
        <button class="btn-acao verde"    onclick="mudarStatus(this,'implementado')">✅ Implementar</button>
        <button class="btn-acao vermelho" onclick="mudarStatus(this,'recusado')">❌ Recusar</button>`;
    }

    mostrarToast(`Status atualizado para "${labels[novoStatus]}"`);
  }

  // ── MODAL ──
  function abrirModal() { document.getElementById('modalNova').classList.add('aberto'); }
  function fecharModal() { document.getElementById('modalNova').classList.remove('aberto'); }

  document.getElementById('modalNova').addEventListener('click', (e) => {
    if (e.target === document.getElementById('modalNova')) fecharModal();
  });

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') fecharModal();
  });

  function salvarSugestao() {
    const titulo = document.getElementById('novoTitulo').value.trim();
    const cat    = document.getElementById('novaCat').value;
    if (!titulo) {
      document.getElementById('novoTitulo').style.borderColor = 'var(--red)';
      setTimeout(() => document.getElementById('novoTitulo').style.borderColor = '', 1500);
      return;
    }
    fecharModal();
    document.getElementById('novoTitulo').value = '';
    mostrarToast('Sugestão criada com sucesso!');
  }

  // ── TOAST ──
  function mostrarToast(msg) {
    const toast = document.getElementById('toast');
    document.getElementById('toastMsg').textContent = msg;
    toast.classList.add('visivel');
    setTimeout(() => toast.classList.remove('visivel'), 3000);
  }

  document.addEventListener("DOMContentLoaded", () => {
  const btnSair = document.querySelector(".user-sair");

  if (btnSair) {
    btnSair.addEventListener("click", () => {
      const confirmar = confirm("Tem certeza que deseja sair da sua conta?");

      if (!confirmar) return;

      localStorage.clear();
      window.location.href = "login.html";
    });
  }
});