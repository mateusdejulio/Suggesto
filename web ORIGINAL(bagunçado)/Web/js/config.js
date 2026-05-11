function voltarPerfil() {
    window.location.href = "perfil.html";
}

function sair() {
    if(confirm("Deseja realmente sair?")) {
        window.location.href = "login.html";
    }
}

function excluirConta() {
    alert("Para excluir sua conta, entre em contato com o suporte.");
}

function irPara(pagina) {
    console.log("Navegando para: " + pagina);
    window.location.href = pagina + ".html";
}