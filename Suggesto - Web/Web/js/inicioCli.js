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

            const categoriaCard = estab.categoria ? estab.categoria.toLowerCase() : 'outros';
            card.dataset.categoria = categoriaCard;

            const imagemURL = estab.fotoPath 
                ? `http://localhost:8080/uploads/${estab.fotoPath}` 
                : 'imagens/placeholder-local.png';

            const nomeCerto = estab.nome || "Nome Indisponível";
            const idCerto = estab.id || estab.idEstabelecimento;

            // ===== ELEMENTOS =====
            const imagemDiv = document.createElement('div');
            imagemDiv.className = 'local-imagem';
            imagemDiv.style.backgroundImage = `url('${imagemURL}')`;

            // Clique na imagem → mapa
            imagemDiv.addEventListener('click', () => {
                window.location.href = "estabelecimentoCli.html";
            });

            const categoriaSpan = document.createElement('span');
            categoriaSpan.className = 'local-categoria';
            categoriaSpan.textContent = estab.categoria || 'Local';

            imagemDiv.appendChild(categoriaSpan);

            const infoDiv = document.createElement('div');
            infoDiv.className = 'local-info';

            const topoDiv = document.createElement('div');
            topoDiv.className = 'local-info-topo';

            const nomeContainer = document.createElement('div');

            const nomeEl = document.createElement('h3');
            nomeEl.className = 'local-nome';
            nomeEl.textContent = nomeCerto;

            const enderecoEl = document.createElement('p');
            enderecoEl.className = 'local-endereco';
            enderecoEl.innerHTML = `<i class="fas fa-map-marker-alt"></i> ${estab.endereco || 'Endereço não informado'}`;

            nomeContainer.appendChild(nomeEl);
            nomeContainer.appendChild(enderecoEl);

            const notaDiv = document.createElement('div');
            notaDiv.className = 'local-nota';
            notaDiv.innerHTML = `
                <i class="fas fa-star"></i>
                <span>${estab.nota ? estab.nota.toFixed(1) : '5.0'}</span>
            `;

            topoDiv.appendChild(nomeContainer);
            topoDiv.appendChild(notaDiv);

            const rodapeDiv = document.createElement('div');
            rodapeDiv.className = 'local-rodape';

            const tagSpan = document.createElement('span');
            tagSpan.className = 'local-tag';
            tagSpan.textContent = `#${estab.categoria || 'Sugestão'}`;

            const botao = document.createElement('button');
            botao.className = 'local-btn-sugestao';
            botao.innerHTML = `<i class="fas fa-comment-alt"></i> Sugerir`;

            // Clique no botão → sugestão
            botao.addEventListener('click', () => {
                irParaPaginaSugestao(nomeCerto, idCerto);
            });

            rodapeDiv.appendChild(tagSpan);
            rodapeDiv.appendChild(botao);

            infoDiv.appendChild(topoDiv);
            infoDiv.appendChild(rodapeDiv);

            card.appendChild(imagemDiv);
            card.appendChild(infoDiv);

            grade.appendChild(card);
        });

    } catch (error) {
        console.error("Erro ao carregar estabelecimentos:", error);

        grade.innerHTML = `
            <p style="color: white; text-align: center; grid-column: 1/-1;">
                Não foi possível carregar os dados do servidor.
            </p>
        `;
    }
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
    document.querySelectorAll('.filtro-chip')
        .forEach(b => b.classList.remove('filtro-chip-ativo'));

    botao.classList.add('filtro-chip-ativo');

    const cards = document.querySelectorAll('.local-card');

    cards.forEach(card => {
        card.style.display =
            (categoria === 'todos' || card.dataset.categoria === categoria)
                ? ''
                : 'none';
    });
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