// ===== ELEMENTOS DO TOAST =====
const toastErro = document.getElementById('toastErro');
const toastMsgErro = document.getElementById('toastMsgErro');

// ===== MOSTRAR / ESCONDER CAMPOS =====
document.addEventListener("DOMContentLoaded", function () {
    const camposAdmin = document.getElementById("campos-admin");

    function atualizarCampos() {
        const selecionado = document.querySelector('input[name="role"]:checked');
        if (!selecionado) return;

        if (selecionado.value === "admin") {
            camposAdmin.style.display = "block";
        } else {
            camposAdmin.style.display = "none";
        }
        
        // Limpa os erros ao trocar de tipo de conta
        limparErros();
    }

    document.body.addEventListener("change", function (e) {
        if (e.target.name === "role") atualizarCampos();
    });

    atualizarCampos();
});

// ===== FUNÇÕES VISUAIS (ERROS E SUCESSO) =====
function mostrarMensagem(mensagem, tipo = 'erro') {
    toastMsgErro.textContent = mensagem;
    
    if (tipo === 'sucesso') {
        toastErro.classList.add('sucesso');
    } else {
        toastErro.classList.remove('sucesso');
    }

    toastErro.classList.add('visivel');
    
    setTimeout(() => {
        toastErro.classList.remove('visivel');
    }, 3500);
}

// Limpa as bordas vermelhas de todos os inputs e selects
function limparErros() {
    document.querySelectorAll('.form input, .form select').forEach(elemento => {
        elemento.classList.remove('input-erro');
    });
}

// Limpa o erro do elemento específico quando o usuário começa a interagir
document.querySelectorAll('.form input, .form select').forEach(elemento => {
    elemento.addEventListener('input', () => elemento.classList.remove('input-erro'));
    elemento.addEventListener('change', () => elemento.classList.remove('input-erro'));
});

// ===== VALIDAÇÃO =====
function validarCampos() {
    limparErros(); // Limpa erros anteriores

    const usuario = document.getElementById('usuario');
    const email = document.getElementById('email');
    const senha = document.getElementById('senha');
    const confirmarSenha = document.getElementById('confirmarSenha');
    
    const roleElement = document.querySelector('input[name="role"]:checked');
    const role = roleElement ? roleElement.value : "";

    // Validação campos básicos
    if (!usuario.value.trim() || !email.value.trim() || !senha.value.trim() || !confirmarSenha.value.trim()) {
        if (!usuario.value.trim()) usuario.classList.add('input-erro');
        if (!email.value.trim()) email.classList.add('input-erro');
        if (!senha.value.trim()) senha.classList.add('input-erro');
        if (!confirmarSenha.value.trim()) confirmarSenha.classList.add('input-erro');
        
        mostrarMensagem("Preencha todos os campos obrigatórios.");
        return false;
    }

    if (!email.value.includes("@") || !email.value.includes(".")) {
        email.classList.add('input-erro');
        mostrarMensagem("Digite um endereço de e-mail válido.");
        return false;
    }

    if (senha.value.length < 4) {
        senha.classList.add('input-erro');
        mostrarMensagem("A senha deve ter pelo menos 4 caracteres.");
        return false;
    }

    if (senha.value !== confirmarSenha.value) {
        senha.classList.add('input-erro');
        confirmarSenha.classList.add('input-erro');
        mostrarMensagem("As senhas não coincidem.");
        return false;
    }

    // Validação específica para Admin
    if (role === 'admin') {
        const nome = document.getElementById('nomeCompleto');
        const cpf = document.getElementById('cpf');
        const telefone = document.getElementById('telefone');
        const cargo = document.getElementById('cargo');

        if (!nome.value.trim() || !cpf.value.trim() || !telefone.value.trim() || !cargo.value) {
            if (!nome.value.trim()) nome.classList.add('input-erro');
            if (!cpf.value.trim()) cpf.classList.add('input-erro');
            if (!telefone.value.trim()) telefone.classList.add('input-erro');
            if (!cargo.value) cargo.classList.add('input-erro');
            
            mostrarMensagem("Preencha todos os campos de administrador.");
            return false;
        }

        if (cpf.value.trim().length < 11) {
            cpf.classList.add('input-erro');
            mostrarMensagem("Digite um CPF válido.");
            return false;
        }
    }

    return true;
}

// ===== CADASTRO REAL CONECTADO À API =====
async function cadastrar() {
    if (!validarCampos()) return;

    const botao = document.querySelector('.form button');
    const textoOriginal = botao.innerText;
    
    botao.innerText = "Processando...";
    botao.disabled = true;

    const roleSelecionada = document.querySelector('input[name="role"]:checked').value;
    
    // Objeto base
    const novoUsuario = {
        nome: document.getElementById('usuario').value.trim(),
        email: document.getElementById('email').value.trim(),
        senha: document.getElementById('senha').value.trim(),
        tipoUsuario: roleSelecionada === "admin" ? "Administrador" : "Cliente"
    };

    // Adiciona os campos extras se for Admin
    if (roleSelecionada === "admin") {
        novoUsuario.nome = document.getElementById('nomeCompleto').value.trim(); // Substitui o apelido pelo nome completo
        novoUsuario.cpf = document.getElementById('cpf').value.trim();
        novoUsuario.telefone = document.getElementById('telefone').value.trim();
        novoUsuario.cargo = document.getElementById('cargo').value;
    }

    try {
        const resposta = await fetch("http://localhost:8080/api/cadastro", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(novoUsuario)
        });

        const resultado = await resposta.json();

        if (resposta.ok) {
            mostrarMensagem("Cadastro realizado com sucesso! Redirecionando...", "sucesso");
            
            // Aguarda 2 segundos para o usuário ler a mensagem verde e manda para o login
            setTimeout(() => {
                window.location.href = "login.html";
            }, 2000);
        } else {
            // Mostra o erro do backend (ex: E-mail já em uso)
            mostrarMensagem(resultado.message || "Erro ao cadastrar. Verifique os dados.");
            botao.innerText = textoOriginal;
            botao.disabled = false;
        }

    } catch (error) {
        console.error("Erro:", error);
        mostrarMensagem("Servidor offline. Verifique se a sua API Java está rodando.");
        botao.innerText = textoOriginal;
        botao.disabled = false;
    }
}