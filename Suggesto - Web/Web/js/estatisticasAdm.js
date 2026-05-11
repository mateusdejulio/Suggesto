/* ═══════════════════════════════════════════
   ESTATÍSTICAS — Cotil
   estatisticas.js
════════════════════════════════════════════ */

'use strict';

// ── DADOS ─────────────────────────────────────────────────────────────────────

const DATA = {
  '6m': {
    meses:       ['Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov'],
    total:       [12, 18, 22, 30, 37, 44],
    implementadas:[5,  8,  9, 14, 17, 20],
    kpi: {
      total: 174, users: 85, impl: 42, avg: 29, rate: '58%', pend: 15,
      deltaTotal: '+12%', deltaUsers: '+8%', deltaImpl: '+24%', deltaPend: 'Aguardando'
    }
  },
  '3m': {
    meses:       ['Set', 'Out', 'Nov'],
    total:       [30, 37, 44],
    implementadas:[14, 17, 20],
    kpi: {
      total: 111, users: 72, impl: 51, avg: 37, rate: '46%', pend: 11,
      deltaTotal: '+19%', deltaUsers: '+5%', deltaImpl: '+18%', deltaPend: 'Aguardando'
    }
  },
  '1m': {
    meses:       ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4'],
    total:       [10, 12, 11, 11],
    implementadas:[4, 6, 5, 5],
    kpi: {
      total: 44, users: 38, impl: 20, avg: 11, rate: '45%', pend: 8,
      deltaTotal: '+8%', deltaUsers: '+3%', deltaImpl: '+14%', deltaPend: 'Aguardando'
    }
  }
};

const CATEGORIAS = [
  { nome: 'Estrutura',          qtd: 28, cor: '#7f6cff' },
  { nome: 'Atendimento',        qtd: 15, cor: '#60a5fa' },
  { nome: 'Produtos e Serviços',qtd: 12, cor: '#34d399' },
  { nome: 'Higiene',            qtd: 9,  cor: '#fbbf24' },
  { nome: 'Organização',        qtd: 8,  cor: '#fb7185' },
];

const DONUT_DATA = [
  { label: 'Implementados', val: 42, cor: '#34d399' },
  { label: 'Pendentes',     val: 15, cor: '#fbbf24' },
  { label: 'Em análise',    val: 9,  cor: '#60a5fa' },
  { label: 'Recusados',     val: 6,  cor: '#fb7185' },
];

let periodoAtivo = '6m';

// ── INIT ───────────────────────────────────────────────────────────────────────

document.addEventListener('DOMContentLoaded', () => {
  renderAll(periodoAtivo);
  bindPeriodSwitch();
  bindExport();
});

function renderAll(period) {
  const d = DATA[period];
  updateKPIs(d.kpi);
  renderBarChart(d);
  renderDonut();
  renderHBars();
  renderLineChart(d);
}

// ── PERIOD SWITCH ──────────────────────────────────────────────────────────────

function bindPeriodSwitch() {
  document.querySelectorAll('.period-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.period-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      periodoAtivo = btn.dataset.period;
      renderAll(periodoAtivo);
    });
  });
}

// ── KPIs ───────────────────────────────────────────────────────────────────────

function updateKPIs(kpi) {
  animCount('kpiTotal', kpi.total);
  animCount('kpiUsers', kpi.users);
  animCount('kpiImpl',  kpi.impl);
  animCount('kpiAvg',   kpi.avg);
  animCount('kpiPend',  kpi.pend);
  document.getElementById('kpiRate').textContent = kpi.rate;
}

function animCount(id, target) {
  const el = document.getElementById(id);
  if (!el) return;
  const start = parseInt(el.textContent) || 0;
  const dur = 600;
  const t0 = performance.now();

  function step(now) {
    const p = Math.min((now - t0) / dur, 1);
    const ease = 1 - Math.pow(1 - p, 3);
    el.textContent = Math.round(start + (target - start) * ease);
    if (p < 1) requestAnimationFrame(step);
  }

  requestAnimationFrame(step);
}

// ── BAR CHART ──────────────────────────────────────────────────────────────────

function renderBarChart(d) {
  const chart   = document.getElementById('barChart');
  const yAxis   = document.getElementById('barYAxis');
  const maxVal  = Math.max(...d.total);
  const maxY    = Math.ceil(maxVal / 10) * 10;
  const steps   = 5;

  // Y axis
  yAxis.innerHTML = '';
  for (let i = steps; i >= 0; i--) {
    const lbl = document.createElement('span');
    lbl.textContent = Math.round((maxY / steps) * i);
    yAxis.appendChild(lbl);
  }

  // Bars
  chart.innerHTML = '';

  d.meses.forEach((mes, i) => {
    const pctTotal = (d.total[i] / maxY) * 100;
    const pctImpl  = (d.implementadas[i] / maxY) * 100;

    const group = document.createElement('div');
    group.className = 'bar-group';

    group.innerHTML = `
      <div class="bar-group-bars">
        <div class="bar bar-total"
             style="height:${pctTotal}%; animation-delay:${i * 0.08}s;"
             title="${mes}: ${d.total[i]} sugestões"></div>
        <div class="bar bar-impl"
             style="height:${pctImpl}%; animation-delay:${i * 0.08 + 0.05}s;"
             title="${mes}: ${d.implementadas[i]} implementadas"></div>
      </div>
      <div class="bar-label">${mes}</div>
      <div class="bar-val">${d.total[i]}</div>
    `;

    chart.appendChild(group);
  });
}

// ── DONUT CANVAS ───────────────────────────────────────────────────────────────

function renderDonut() {
  const canvas = document.getElementById('donutCanvas');
  if (!canvas) return;
  const ctx    = canvas.getContext('2d');
  const W = canvas.width;
  const H = canvas.height;
  const cx = W / 2, cy = H / 2;
  const R = 62, r = 42;
  const gap = 0.025; // radians gap between segments

  const total = DONUT_DATA.reduce((a, b) => a + b.val, 0);
  let angles = DONUT_DATA.map(d => (d.val / total) * (Math.PI * 2));

  ctx.clearRect(0, 0, W, H);

  let current = -Math.PI / 2;
  angles.forEach((angle, i) => {
    const startA = current + gap / 2;
    const endA   = current + angle - gap / 2;

    ctx.beginPath();
    ctx.arc(cx, cy, R, startA, endA);
    ctx.arc(cx, cy, r, endA, startA, true);
    ctx.closePath();
    ctx.fillStyle = DONUT_DATA[i].cor;
    ctx.fill();

    current += angle;
  });
}

// ── HORIZONTAL BAR CHART ───────────────────────────────────────────────────────

function renderHBars() {
  const container = document.getElementById('hbarList');
  if (!container) return;
  const maxQtd = Math.max(...CATEGORIAS.map(c => c.qtd));
  const total  = CATEGORIAS.reduce((a, c) => a + c.qtd, 0);

  container.innerHTML = '';

  CATEGORIAS.forEach((cat, i) => {
    const pct = ((cat.qtd / total) * 100).toFixed(1);
    const barW = (cat.qtd / maxQtd) * 100;

    const item = document.createElement('div');
    item.className = 'hbar-item';
    item.style.animationDelay = `${0.2 + i * 0.07}s`;
    item.innerHTML = `
      <div class="hbar-head">
        <span class="hbar-name">${cat.nome}</span>
        <span class="hbar-nums"><strong>${cat.qtd}</strong> sugestões &nbsp;·&nbsp; ${pct}%</span>
      </div>
      <div class="hbar-track">
        <div class="hbar-fill" style="width:${barW}%; background:${cat.cor};"></div>
      </div>
    `;
    container.appendChild(item);
  });
}

// ── LINE CHART ─────────────────────────────────────────────────────────────────

function renderLineChart(d) {
  const canvas = document.getElementById('lineCanvas');
  if (!canvas) return;

  // Set real pixel width
  canvas.width  = canvas.offsetWidth || 260;
  canvas.height = 100;

  const ctx  = canvas.getContext('2d');
  const vals = d.total;
  const W    = canvas.width;
  const H    = canvas.height;
  const PAD  = 8;
  const maxV = Math.max(...vals);

  const pts = vals.map((v, i) => ({
    x: PAD + (i / (vals.length - 1)) * (W - PAD * 2),
    y: H - PAD - (v / maxV) * (H - PAD * 2)
  }));

  ctx.clearRect(0, 0, W, H);

  // Grid lines
  ctx.strokeStyle = 'rgba(255,255,255,0.04)';
  ctx.lineWidth = 1;
  [0.25, 0.5, 0.75].forEach(frac => {
    const y = PAD + frac * (H - PAD * 2);
    ctx.beginPath();
    ctx.moveTo(PAD, y);
    ctx.lineTo(W - PAD, y);
    ctx.stroke();
  });

  // Gradient fill
  const grad = ctx.createLinearGradient(0, 0, 0, H);
  grad.addColorStop(0, 'rgba(127,108,255,0.3)');
  grad.addColorStop(1, 'rgba(127,108,255,0)');

  ctx.beginPath();
  ctx.moveTo(pts[0].x, H);
  pts.forEach(p => ctx.lineTo(p.x, p.y));
  ctx.lineTo(pts[pts.length - 1].x, H);
  ctx.closePath();
  ctx.fillStyle = grad;
  ctx.fill();

  // Line
  ctx.beginPath();
  pts.forEach((p, i) => i === 0 ? ctx.moveTo(p.x, p.y) : ctx.lineTo(p.x, p.y));
  ctx.strokeStyle = '#7f6cff';
  ctx.lineWidth = 2;
  ctx.lineJoin = 'round';
  ctx.stroke();

  // Dots
  pts.forEach(p => {
    ctx.beginPath();
    ctx.arc(p.x, p.y, 3, 0, Math.PI * 2);
    ctx.fillStyle = '#7f6cff';
    ctx.fill();
    ctx.beginPath();
    ctx.arc(p.x, p.y, 1.5, 0, Math.PI * 2);
    ctx.fillStyle = '#fff';
    ctx.fill();
  });

  // Month labels
  const trendMonths = document.getElementById('trendMonths');
  if (trendMonths) {
    trendMonths.innerHTML = '';
    d.meses.forEach(m => {
      const span = document.createElement('span');
      span.textContent = m;
      trendMonths.appendChild(span);
    });
  }
}

// ── EXPORT ─────────────────────────────────────────────────────────────────────

function bindExport() {
  document.getElementById('btnExport')?.addEventListener('click', () => {
    const d = DATA[periodoAtivo];
    const rows = [
      ['Mês', 'Total', 'Implementadas'],
      ...d.meses.map((m, i) => [m, d.total[i], d.implementadas[i]])
    ];

    const csv = rows.map(r => r.join(',')).join('\n');
    const blob = new Blob([csv], { type: 'text/csv' });
    const url  = URL.createObjectURL(blob);
    const a    = document.createElement('a');
    a.href     = url;
    a.download = `cotil-estatisticas-${periodoAtivo}.csv`;
    a.click();
    URL.revokeObjectURL(url);

    showToast('CSV exportado com sucesso!');
  });
}

// ── TOAST ──────────────────────────────────────────────────────────────────────

function showToast(msg) {
  const toast = document.getElementById('toast');
  document.getElementById('toastMsg').textContent = msg;
  toast.classList.add('visible');
  setTimeout(() => toast.classList.remove('visible'), 3000);
}

// ── RESIZE: re-render line chart on window resize ──────────────────────────────

window.addEventListener('resize', () => {
  renderLineChart(DATA[periodoAtivo]);
});


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