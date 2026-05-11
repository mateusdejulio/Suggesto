function voltarIndex() {
    window.location.href = "index.html";
}

function camposAdm() {
    const adminRadio = document.querySelector('input[value="Administrador"]');
    const camposAdmin = document.getElementById('camposAdministrador');
    const imgCliente = document.querySelector('.imagemFodonaManuela1')
    const imgAdm = document.querySelector('.imagemFodonaManuela2')

    if (adminRadio.checked) {
        camposAdmin.style.display = 'flex';
        imgCliente.style.display = 'none'
        imgAdm.style.display = 'flex' 
    } else {
        camposAdmin.style.display = 'none';
        imgAdm.style.display = 'none'
        imgCliente.style.display = 'flex' 
    }
}

const formCadastro = document.querySelector('.formCadastro');

formCadastro.addEventListener('submit', async (event) => {
    
    //impedir a página de recarregar e os dados não ir pra api
    event.preventDefault();

    const email = document.getElementById("emailUser").value
    const senha1 = document.getElementById("senhaUser1").value
    const senha2 = document.getElementById("senhaUser2").value
    const nome = document.getElementById("nomeUser").value

    //pega o tipo de usuario através do que estar checado no radio button
    const inputTipo = document.querySelector('input[name="tipo"]:checked');
    const tipo = inputTipo ? inputTipo.value : "Cliente";

    if (senha1 != senha2) {
        alert("As senhas não coincidem! Tente novamente")
        return;
    }

    // o java espera um objeto com as mesmas classes que criamos na api
    const dadosParaEnviar = {
        nome : nome,
        senha : senha1,
        tipo : tipo,
        //se os campos de adm estiver vazio salva como NULL
        cargo : document.getElementById("cargoUser").value || null,
        cpf: document.getElementById("cpfUser").value || null,
        telefone : document.getElementById("telefoneUser").value || null
    }

try {
    const resposta = await fetch ("http://localhost:8080/api/usuarios/cadastrar", {
        method : "POST",
        headers : {
            "Content-Type" : "application/json"
        },
        body: JSON.stringify(dadosParaEnviar)
    })
    const resultado = await resposta.json()

    if(resultado.sucess) {
        alert("Sucesso:" + resultado.message);
        window.location.href = "login.html"
    } else {
        alert("Atenção: " + resultado.message)
    }
} catch (error) {
    console.error("Erro de conexão", error)
    alert("Não foi possível conectar")
}
})