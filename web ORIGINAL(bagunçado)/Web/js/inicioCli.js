// js/inicioCli.js

document.addEventListener("DOMContentLoaded", () => {
    carregarDadosUsuario();
    carregarEstabelecimentos();
});

// Redirecionamento principal do Banner (Geral)
function abrirSugestao() {
    window.location.href = './fazerSugestao.html';
}

// Função que leva para a página de sugestão com os dados certos
function irParaPaginaSugestao(nome, id) {
    if (!id) {
        console.error("Erro: ID do estabelecimento não encontrado.");
        return;
    }
    window.location.href = `./fazerSugestao.html?id=${id}&nome=${encodeURIComponent(nome)}`;
}

async function carregarEstabelecimentos() {
    const grade = document.getElementById('locaisGrade');
    if (!grade) return;

    try {
        const resposta = await fetch("http://localhost:8080/api/estabelecimentos");
        const estabelecimentos = await resposta.json();
        
        grade.innerHTML = "";

        estabelecimentos.forEach(estab => {
            const card = document.createElement('div');
            card.className = 'local-card';
            
            // Tratamento de categoria
            const categoriaCard = estab.categoria ? estab.categoria.toLowerCase() : 'outros';
            card.dataset.categoria = categoriaCard;

            // Define a imagem (usando o campo fotoPath que vem do Java)
            const imagemURL = estab.fotoPath 
                ? `http://localhost:8080/uploads/${estab.fotoPath}` 
                : 'imagens/placeholder-local.png';

            // --- AQUI ESTÁ A CORREÇÃO FINAL ---
            // 1. No seu Java é 'private String nome', então usamos estab.nome
            // 2. No ID, tentamos 'id' e depois 'idEstabelecimento' por segurança
            const nomeCerto = estab.nome || "Nome Indisponível";
            const idCerto = estab.id || estab.idEstabelecimento;

            card.innerHTML = `
                <div class="local-imagem" style="background-image: url('${imagemURL}')" 
                     onclick="window.location.href='mapaCli.html?id=${idCerto}'">
                    <span class="local-categoria">${estab.categoria || 'Local'}</span>
                </div>
                <div class="local-info">
                    <div class="local-info-topo">
                        <div>
                            <h3 class="local-nome">${nomeCerto}</h3>
                            <p class="local-endereco">
                                <i class="fas fa-map-marker-alt"></i> ${estab.endereco || 'Endereço não informado'}
                            </p>
                        </div>
                        <div class="local-nota">
                            <i class="fas fa-star"></i>
                            <span>${estab.nota ? estab.nota.toFixed(1) : '5.0'}</span>
                        </div>
                    </div>
                    <div class="local-rodape">
                        <span class="local-tag">#${estab.categoria || 'Sugestão'}</span>
                        <button class="local-btn-sugestao" 
                                onclick="irParaPaginaSugestao('${nomeCerto}', ${idCerto})">
                            <i class="fas fa-comment-alt"></i> Sugerir
                        </button>
                    </div>
                </div>
            `;
            grade.appendChild(card);
        });

    } catch (error) {
        console.error("Erro ao carregar estabelecimentos:", error);
        grade.innerHTML = `<p style="color: white; text-align: center; grid-column: 1/-1;">Não foi possível carregar os dados do servidor.</p>`;
    }
}

function carregarDadosUsuario() {
    const nome = localStorage.getItem('nomeUsuario') || 'Usuário';
    const elementoSaudacao = document.getElementById('saudacaoNome');
    const elementoSidebar = document.getElementById('sidebarNome');
    const elementoAvatar = document.getElementById('sidebarAvatar');

    if(elementoSaudacao) elementoSaudacao.innerText = `Olá, ${nome.split(' ')[0]} 👋`;
    if(elementoSidebar) elementoSidebar.innerText = nome;
    if(elementoAvatar) elementoAvatar.innerText = nome.substring(0,2).toUpperCase();
}

function filtrarLocais() {
    const busca = document.getElementById('campoBusca').value.toLowerCase();
    const cards = document.querySelectorAll('.local-card');
    cards.forEach(card => {
        const nomeElemento = card.querySelector('.local-nome');
        if (nomeElemento) {
            const nome = nomeElemento.textContent.toLowerCase();
            card.style.display = nome.includes(busca) ? '' : 'none';
        }
    });
}

function filtrarCategoria(botao, categoria) {
    document.querySelectorAll('.filtro-chip').forEach(b => b.classList.remove('filtro-chip-ativo'));
    botao.classList.add('filtro-chip-ativo');
    const cards = document.querySelectorAll('.local-card');
    cards.forEach(card => {
        card.style.display = (categoria === 'todos' || card.dataset.categoria === categoria) ? '' : 'none';
    });
}

function abrirModalSair() { 
    const modal = document.getElementById('modalSair');
    if(modal) modal.classList.add('aberto'); 
}

function fecharModal(id) { 
    const modal = document.getElementById(id);
    if(modal) modal.classList.remove('aberto'); 
}

function confirmarSair() { 
    localStorage.clear(); 
    window.location.href = 'login.html'; 
}