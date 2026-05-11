function alternarAbas(aba) {
    // Pega as abas (botões)
    const btnMes = document.getElementById('tabMes');
    const btnGeral = document.getElementById('tabGeral');
    
    // Pega os containers de conteúdo
    const conteudoMes = document.getElementById('conteudoMes');
    const conteudoGeral = document.getElementById('conteudoGeral');

    if (aba === 'mes') {
        // Ativa mês, desativa geral
        btnMes.classList.add('ativo');
        btnGeral.classList.remove('ativo');
        conteudoMes.classList.add('ativo');
        conteudoGeral.classList.remove('ativo');
    } else {
        // Ativa geral, desativa mês
        btnGeral.classList.add('ativo');
        btnMes.classList.remove('ativo');
        conteudoGeral.classList.add('ativo');
        conteudoMes.classList.remove('ativo');
    }
}