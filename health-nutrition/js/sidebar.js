// sidebar.js – injects sidebar HTML into .sidebar element
(function injectSidebar() {
  const el = document.querySelector('.sidebar');
  if (!el) return;
  const base = el.dataset.base || '';
  el.innerHTML = `
    <div class="sidebar-header">
      <a href="${base}index.html" class="sidebar-logo">VITA<span>CORE</span></a>
      <div class="sidebar-tagline">HEALTH INTELLIGENCE</div>
    </div>
    <div class="sidebar-body">
      <div class="sidebar-section">
        <div class="sidebar-section-title">Overview</div>
        <a href="${base}pages/dashboard.html" class="sidebar-link" data-page="dashboard.html">
          <span class="sidebar-icon">📊</span> Dashboard
        </a>
        <a href="${base}pages/analytics.html" class="sidebar-link" data-page="analytics.html">
          <span class="sidebar-icon">📈</span> Progress Analytics
        </a>
        <a href="${base}pages/notifications.html" class="sidebar-link" data-page="notifications.html">
          <span class="sidebar-icon">🔔</span> Notifications <span class="sidebar-badge">3</span>
        </a>
      </div>
      <div class="sidebar-section">
        <div class="sidebar-section-title">Nutrition</div>
        <a href="${base}pages/nutrition.html" class="sidebar-link" data-page="nutrition.html">
          <span class="sidebar-icon">🥗</span> Food & Meals
        </a>
        <a href="${base}pages/diet-plan.html" class="sidebar-link" data-page="diet-plan.html">
          <span class="sidebar-icon">📋</span> Diet Plans
        </a>
        <a href="${base}pages/hydration.html" class="sidebar-link" data-page="hydration.html">
          <span class="sidebar-icon">💧</span> Hydration
        </a>
      </div>
      <div class="sidebar-section">
        <div class="sidebar-section-title">Fitness</div>
        <a href="${base}pages/fitness.html" class="sidebar-link" data-page="fitness.html">
          <span class="sidebar-icon">💪</span> Workouts
        </a>
        <a href="${base}pages/sleep.html" class="sidebar-link" data-page="sleep.html">
          <span class="sidebar-icon">😴</span> Sleep Tracker
        </a>
        <a href="${base}pages/body-metrics.html" class="sidebar-link" data-page="body-metrics.html">
          <span class="sidebar-icon">⚖️</span> Body Metrics
        </a>
      </div>
      <div class="sidebar-section">
        <div class="sidebar-section-title">Professional</div>
        <a href="${base}pages/consultations.html" class="sidebar-link" data-page="consultations.html">
          <span class="sidebar-icon">🩺</span> Consultations
        </a>
        <a href="${base}pages/admin.html" class="sidebar-link" data-page="admin.html">
          <span class="sidebar-icon">🛡️</span> Admin Panel
        </a>
      </div>
      <div class="sidebar-section">
        <div class="sidebar-section-title">Account</div>
        <a href="${base}pages/profile.html" class="sidebar-link" data-page="profile.html">
          <span class="sidebar-icon">👤</span> My Profile
        </a>
        <a href="${base}pages/settings.html" class="sidebar-link" data-page="settings.html">
          <span class="sidebar-icon">⚙️</span> Settings
        </a>
        <a href="${base}pages/login.html" class="sidebar-link">
          <span class="sidebar-icon">🚪</span> Logout
        </a>
      </div>
    </div>
    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="sidebar-avatar">KK</div>
        <div>
          <div class="sidebar-user-name">Kiran Kumar</div>
          <div class="sidebar-user-role">BSc CS "A"</div>
        </div>
      </div>
    </div>
  `;

  // Set active based on current filename
  const current = location.pathname.split('/').pop() || 'index.html';
  el.querySelectorAll('.sidebar-link[data-page]').forEach(link => {
    if (link.dataset.page === current) link.classList.add('active');
  });
})();
