const THEME_KEY = 'datafruits-theme';
const LOCALE_KEY = 'datafruits-locale';
const WEATHER_KEY = 'datafruits-weather';

// Apply saved theme on page load
(function initTheme() {
  const saved = localStorage.getItem(THEME_KEY) || 'classic';
  applyTheme(saved);
})();

function applyTheme(theme) {
  const html = document.documentElement;
  ['theme-classic', 'theme-blm', 'theme-trans'].forEach(c => html.classList.remove(c));
  html.classList.add(`theme-${theme}`);
}
