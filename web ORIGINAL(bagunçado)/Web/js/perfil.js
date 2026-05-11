const itens = document.querySelectorAll(".itemSanfona");

itens.forEach(item => {
  const header = item.querySelector(".tituloSanfona");

  header.addEventListener("click", () => {
    item.classList.toggle("ativo");
  });
});

function entrarConfig() {
     window.location.href = "config.html";
}