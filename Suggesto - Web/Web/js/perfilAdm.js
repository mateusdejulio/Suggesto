function abrirModal(id) {
      document.getElementById(id).classList.add('aberto');
    }
    function fecharModal(id) {
      document.getElementById(id).classList.remove('aberto');
    }
    function abrirModalSair() { abrirModal('modalSaida'); }
    function mostrarToast(msg) {
      const t = document.getElementById('toast');
      document.getElementById('toastMsg').textContent = msg;
      t.classList.add('visivel');
      setTimeout(() => t.classList.remove('visivel'), 3000);
    }
    // Fecha modal ao clicar fora
    document.querySelectorAll('.modal-fundo').forEach(fundo => {
      fundo.addEventListener('click', e => {
        if (e.target === fundo) fundo.classList.remove('aberto');
      });
    });