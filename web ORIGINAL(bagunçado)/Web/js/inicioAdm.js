  // Spark bars
  const sparkData = [30,45,28,60,52,70,55,80,65,90,78,100];
  const spark = document.getElementById('spark');
  const max = Math.max(...sparkData);
  sparkData.forEach((v, i) => {
    const bar = document.createElement('div');
    bar.className = 'spark-bar' + (i === sparkData.length-1 ? ' hi' : '');
    bar.style.height = (v / max * 100) + '%';
    spark.appendChild(bar);
  });

  // Animate status bars on scroll
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => {
      if (e.isIntersecting) e.target.style.width = e.target.dataset.w;
    });
  }, { threshold: 0.3 });

  document.querySelectorAll('.status-bar-fill').forEach(el => observer.observe(el));