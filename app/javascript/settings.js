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

// window.openSettingsModal = function () {
//   if (document.getElementById('settings-modal')) return; // already open
//
//   const template = document.getElementById('settings-template');
//   if (!template) return;
//
//   const modal = document.createElement('ui-modal');
//   modal.id = 'settings-modal';
//   modal.appendChild(template.content.cloneNode(true));
//   document.body.appendChild(modal);
//
//   // Restore saved values in the selects
//   setSelectValue(modal, '#theme-selector', localStorage.getItem(THEME_KEY) || 'classic');
//   setSelectValue(modal, '#locale-selector', localStorage.getItem(LOCALE_KEY) || 'en');
//   setSelectValue(modal, '#weather-selector', localStorage.getItem(WEATHER_KEY) || 'cloudy');
//
//   modal.querySelector('#theme-selector')?.addEventListener('change', onThemeChange);
//   modal.querySelector('#locale-selector')?.addEventListener('change', onLocaleChange);
//   modal.querySelector('#weather-selector')?.addEventListener('change', onWeatherChange);
// };
//
// function setSelectValue(root, selector, value) {
//   const el = root.querySelector(selector);
//   if (el) el.value = value;
// }
//
// function onThemeChange(event) {
//   const theme = event.target.value;
//   applyTheme(theme);
//   localStorage.setItem(THEME_KEY, theme);
// }
//
// function onLocaleChange(event) {
//   const locale = event.target.value;
//   localStorage.setItem(LOCALE_KEY, locale);
//   document.dispatchEvent(new CustomEvent('locale-changed', { detail: { locale } }));
// }
//
// function onWeatherChange(event) {
//   const weather = event.target.value;
//   localStorage.setItem(WEATHER_KEY, weather);
//   document.dispatchEvent(new CustomEvent('weather-changed', { detail: { weather } }));
// }
