/* ============================================================
   VITACORE – SHARED JAVASCRIPT
   Particles, Sidebar, Charts, Interactivity
   ============================================================ */

// ===== PARTICLE BACKGROUND =====
(function initCanvas() {
  const canvas = document.getElementById('bg-canvas');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  let particles = [];

  function resize() { canvas.width = innerWidth; canvas.height = innerHeight; }
  resize(); window.addEventListener('resize', resize);

  class Particle {
    constructor() { this.reset(true); }
    reset(init) {
      this.x = Math.random() * canvas.width;
      this.y = init ? Math.random() * canvas.height : Math.random() * canvas.height;
      this.vx = (Math.random() - .5) * .35;
      this.vy = (Math.random() - .5) * .35;
      this.r = Math.random() * 1.5 + .4;
      this.alpha = Math.random() * .35 + .05;
      this.color = Math.random() > .65 ? '#00f5a0' : '#00d4ff';
    }
    update() {
      this.x += this.vx; this.y += this.vy;
      if (this.x < 0||this.x > canvas.width||this.y < 0||this.y > canvas.height) this.reset(false);
    }
    draw() {
      ctx.beginPath(); ctx.arc(this.x, this.y, this.r, 0, Math.PI * 2);
      ctx.fillStyle = this.color; ctx.globalAlpha = this.alpha; ctx.fill();
    }
  }

  for (let i = 0; i < 90; i++) particles.push(new Particle());

  function drawLines() {
    for (let i = 0; i < particles.length; i++)
      for (let j = i + 1; j < particles.length; j++) {
        const dx = particles[i].x - particles[j].x, dy = particles[i].y - particles[j].y;
        const d = Math.sqrt(dx*dx+dy*dy);
        if (d < 110) {
          ctx.beginPath(); ctx.moveTo(particles[i].x, particles[i].y);
          ctx.lineTo(particles[j].x, particles[j].y);
          ctx.strokeStyle = '#00f5a0';
          ctx.globalAlpha = (1 - d/110) * 0.065;
          ctx.lineWidth = .5; ctx.stroke();
        }
      }
  }

  (function animate() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    particles.forEach(p => { p.update(); p.draw(); });
    drawLines(); ctx.globalAlpha = 1;
    requestAnimationFrame(animate);
  })();
})();

// ===== SIDEBAR TOGGLE =====
function toggleSidebar() {
  document.querySelector('.sidebar')?.classList.toggle('open');
}

// ===== ACTIVE SIDEBAR LINK =====
(function setActiveSidebarLink() {
  const links = document.querySelectorAll('.sidebar-link');
  const current = location.pathname.split('/').pop() || 'index.html';
  links.forEach(link => {
    const href = link.getAttribute('href')?.split('/').pop();
    if (href === current) { link.classList.add('active'); }
    else link.classList.remove('active');
  });
})();

// ===== ANIMATED PROGRESS BARS =====
function animateProgressBars() {
  document.querySelectorAll('.progress-fill[data-w]').forEach(bar => {
    setTimeout(() => { bar.style.width = bar.dataset.w + '%'; }, 100);
  });
}

// ===== ANIMATED BAR CHARTS =====
function animateBarCharts() {
  document.querySelectorAll('.bc-bar-fill[data-h]').forEach(bar => {
    setTimeout(() => { bar.style.height = bar.dataset.h + '%'; }, 150);
  });
}

// ===== INTERSECTION OBSERVER FOR ANIMATIONS =====
const revealObserver = new IntersectionObserver(entries => {
  entries.forEach(e => {
    if (e.isIntersecting) {
      e.target.style.animationPlayState = 'running';
      revealObserver.unobserve(e.target);
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('[data-reveal]').forEach(el => {
  el.style.animationPlayState = 'paused';
  revealObserver.observe(el);
});

// ===== TAB SWITCHER =====
function switchTab(tabName, group = 'default') {
  document.querySelectorAll(`.tab-item[data-group="${group}"]`).forEach(t => t.classList.remove('active'));
  document.querySelectorAll(`.tab-content[data-group="${group}"]`).forEach(t => t.classList.remove('active'));
  const tab = document.querySelector(`.tab-item[data-tab="${tabName}"][data-group="${group}"]`);
  const content = document.querySelector(`.tab-content[data-tab="${tabName}"][data-group="${group}"]`);
  if (tab) tab.classList.add('active');
  if (content) content.classList.add('active');
}

// ===== AUTH TABS =====
function switchAuthTab(name) {
  document.querySelectorAll('.auth-tab').forEach(t => t.classList.remove('active'));
  document.querySelectorAll('.auth-form').forEach(f => f.style.display = 'none');
  document.querySelector(`.auth-tab[data-tab="${name}"]`)?.classList.add('active');
  const el = document.getElementById('form-' + name);
  if (el) el.style.display = 'block';
}

// ===== NOTIFICATION TOAST =====
function showToast(msg, type = 'success') {
  const toast = document.createElement('div');
  const color = type === 'success' ? 'var(--green)' : type === 'error' ? 'var(--red)' : 'var(--cyan)';
  toast.style.cssText = `position:fixed;bottom:2rem;right:2rem;z-index:9999;background:var(--surface);border:1px solid ${color};
    color:var(--text);padding:.9rem 1.5rem;border-radius:12px;font-size:.88rem;font-family:var(--font-body);
    box-shadow:0 10px 40px rgba(0,0,0,.5);animation:fadeUp .3s ease;max-width:320px;display:flex;align-items:center;gap:.7rem`;
  const icon = type === 'success' ? '✅' : type === 'error' ? '❌' : 'ℹ️';
  toast.innerHTML = `<span>${icon}</span><span>${msg}</span>`;
  document.body.appendChild(toast);
  setTimeout(() => { toast.style.opacity = '0'; toast.style.transition = 'opacity .4s'; setTimeout(() => toast.remove(), 400); }, 3000);
}

// ===== FOOD DATABASE =====
const foodDB = [
  { id:1, name:'Grilled Chicken Breast', portion:'100g', kcal:165, protein:31, carbs:0, fat:3.6, category:'protein' },
  { id:2, name:'Brown Rice', portion:'1 cup cooked', kcal:216, protein:5, carbs:45, fat:1.8, category:'grain' },
  { id:3, name:'Broccoli', portion:'100g', kcal:55, protein:3.7, carbs:11, fat:0.6, category:'vegetable' },
  { id:4, name:'Banana', portion:'1 medium', kcal:89, protein:1.1, carbs:23, fat:0.3, category:'fruit' },
  { id:5, name:'Greek Yogurt', portion:'200g', kcal:130, protein:17, carbs:9, fat:3.5, category:'dairy' },
  { id:6, name:'Oats', portion:'100g dry', kcal:389, protein:17, carbs:66, fat:7, category:'grain' },
  { id:7, name:'Atlantic Salmon', portion:'150g', kcal:280, protein:39, carbs:0, fat:13, category:'protein' },
  { id:8, name:'Almonds', portion:'30g', kcal:173, protein:6, carbs:6, fat:15, category:'fat' },
  { id:9, name:'Sweet Potato', portion:'1 medium', kcal:103, protein:2.3, carbs:24, fat:0.1, category:'vegetable' },
  { id:10, name:'Whole Egg', portion:'1 large', kcal:72, protein:6, carbs:0.4, fat:5, category:'protein' },
  { id:11, name:'Spinach', portion:'100g', kcal:23, protein:2.9, carbs:3.6, fat:0.4, category:'vegetable' },
  { id:12, name:'Avocado', portion:'1 medium', kcal:234, protein:3, carbs:12, fat:21, category:'fat' },
  { id:13, name:'Whole Wheat Bread', portion:'1 slice', kcal:81, protein:4, carbs:15, fat:1, category:'grain' },
  { id:14, name:'Milk (2%)', portion:'1 cup', kcal:122, protein:8, carbs:12, fat:4.8, category:'dairy' },
  { id:15, name:'Lentils', portion:'1 cup cooked', kcal:230, protein:18, carbs:40, fat:0.8, category:'protein' },
  { id:16, name:'Quinoa', portion:'1 cup cooked', kcal:222, protein:8, carbs:39, fat:3.5, category:'grain' },
  { id:17, name:'Cottage Cheese', portion:'100g', kcal:98, protein:11, carbs:3.4, fat:4.3, category:'dairy' },
  { id:18, name:'Blueberries', portion:'100g', kcal:57, protein:0.7, carbs:14, fat:0.3, category:'fruit' },
  { id:19, name:'Peanut Butter', portion:'2 tbsp', kcal:188, protein:8, carbs:6, fat:16, category:'fat' },
  { id:20, name:'Tuna (canned)', portion:'100g', kcal:116, protein:26, carbs:0, fat:0.5, category:'protein' },
];

let mealLog = [
  { type:'BREAKFAST', name:'Omelette + Toast', kcal:385, icon:'🍳', bg:'rgba(0,245,160,.1)', time:'7:30 AM' },
  { type:'LUNCH',     name:'Grilled Chicken Salad', kcal:520, icon:'🥗', bg:'rgba(250,204,21,.1)', time:'12:45 PM' },
  { type:'SNACK',     name:'Banana + Almonds', kcal:260, icon:'🍌', bg:'rgba(0,212,255,.1)', time:'3:30 PM' },
  { type:'DINNER',    name:'Salmon + Brown Rice', kcal:675, icon:'🍚', bg:'rgba(239,68,68,.1)', time:'7:00 PM' },
];

function searchFood(inputId = 'food-search', listId = 'food-results') {
  const query = (document.getElementById(inputId)?.value || '').toLowerCase();
  const list = document.getElementById(listId);
  if (!list) return;
  const results = query ? foodDB.filter(f => f.name.toLowerCase().includes(query)) : foodDB;
  list.innerHTML = results.slice(0, 12).map(f => `
    <div class="log-item" style="cursor:pointer" onclick="addMealToLog('${f.name}', ${f.kcal}, '${f.icon||'🍽️'}')">
      <div class="log-icon" style="background:rgba(0,245,160,.08); font-size:1.1rem">${f.icon||'🍽️'}</div>
      <div class="log-info">
        <div class="log-name">${f.name}</div>
        <div class="log-meta">${f.portion} · P:${f.protein}g · C:${f.carbs}g · F:${f.fat}g</div>
      </div>
      <div style="display:flex;align-items:center;gap:.5rem">
        <div class="log-value">${f.kcal} kcal</div>
        <button class="btn btn-primary btn-sm" style="border-radius:8px;padding:.3rem .7rem">+</button>
      </div>
    </div>
  `).join('');
}

function addMealToLog(name, kcal, icon = '🍽️') {
  const types = ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK'];
  const type = types[Math.floor(Math.random() * types.length)];
  mealLog.unshift({ type, name, kcal, icon, bg:'rgba(0,245,160,.08)', time: 'Now' });
  renderMealLog();
  showToast(`${name} added to your meal log!`);
}

function renderMealLog(containerId = 'meal-log') {
  const container = document.getElementById(containerId);
  if (!container) return;
  container.innerHTML = mealLog.map(m => `
    <div class="log-item">
      <div class="log-icon" style="background:${m.bg}">${m.icon}</div>
      <div class="log-info">
        <div class="log-name">${m.name}</div>
        <div class="log-meta">${m.type} · ${m.time}</div>
      </div>
      <div class="log-value">${m.kcal} kcal</div>
    </div>
  `).join('');
}

// ===== WATER TRACKER =====
let waterGlasses = 6;
function toggleWater(idx) {
  const glasses = document.querySelectorAll('.water-glass');
  const filled = [...glasses].filter(g => g.classList.contains('filled')).length;
  if (idx < filled) {
    for (let i = idx; i < glasses.length; i++) glasses[i].classList.remove('filled');
  } else {
    for (let i = 0; i <= idx; i++) glasses[i].classList.add('filled');
  }
  const newFilled = [...glasses].filter(g => g.classList.contains('filled')).length;
  const display = document.getElementById('water-display');
  if (display) display.textContent = (newFilled * 250 / 1000).toFixed(2) + 'L';
  showToast(`Water updated: ${(newFilled * 0.25).toFixed(2)}L logged`, 'info');
}

// ===== INIT =====
window.addEventListener('DOMContentLoaded', () => {
  setTimeout(animateProgressBars, 200);
  setTimeout(animateBarCharts, 300);
  if (document.getElementById('food-results')) searchFood();
  if (document.getElementById('meal-log')) renderMealLog();
});
