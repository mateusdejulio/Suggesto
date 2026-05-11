// ===== NAVBAR: scroll effect + mobile toggle =====
const sgNav = document.getElementById('sgNav');
const navToggle = document.getElementById('navToggle');

window.addEventListener('scroll', () => {
  if (window.scrollY > 40) {
    sgNav.classList.add('scrolled');
  } else {
    sgNav.classList.remove('scrolled');
  }
});

navToggle.addEventListener('click', () => {
  sgNav.classList.toggle('open');
});

// Fechar menu ao clicar em link
document.querySelectorAll('.sg-nav__links a').forEach(link => {
  link.addEventListener('click', () => {
    sgNav.classList.remove('open');
  });
});


// ===== SHOWCASE CAROUSEL =====
const showcaseSlides = document.querySelectorAll('.sg-showcase__slide');
const showcaseDots = document.querySelectorAll('.sg-showcase__dot');
const showcaseNext = document.getElementById('showcaseNext');
const showcasePrev = document.getElementById('showcasePrev');
let showcaseCurrent = 0;

function goToSlide(index) {
  showcaseSlides[showcaseCurrent].classList.remove('sg-showcase__slide--active');
  showcaseDots[showcaseCurrent].classList.remove('sg-showcase__dot--active');

  showcaseCurrent = (index + showcaseSlides.length) % showcaseSlides.length;

  showcaseSlides[showcaseCurrent].classList.add('sg-showcase__slide--active');
  showcaseDots[showcaseCurrent].classList.add('sg-showcase__dot--active');
}

showcaseNext.addEventListener('click', () => goToSlide(showcaseCurrent + 1));
showcasePrev.addEventListener('click', () => goToSlide(showcaseCurrent - 1));

// Auto-play carousel
let showcaseTimer = setInterval(() => goToSlide(showcaseCurrent + 1), 5000);

document.querySelector('.sg-showcase').addEventListener('mouseenter', () => clearInterval(showcaseTimer));
document.querySelector('.sg-showcase').addEventListener('mouseleave', () => {
  showcaseTimer = setInterval(() => goToSlide(showcaseCurrent + 1), 5000);
});


// ===== ENTRANCE ANIMATIONS =====
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.style.opacity = '1';
      entry.target.style.transform = 'translateY(0)';
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.sg-feature-card, .sg-role-card, .sg-box').forEach(el => {
  el.style.opacity = '0';
  el.style.transform = 'translateY(24px)';
  el.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
  observer.observe(el);
});


// ===== NAVIGATION =====
function abrirCadastro() {
  window.location.href = "cadastro.html";
}

function abrirEntrar() {
  window.location.href = "login.html";
}