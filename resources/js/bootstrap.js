import axios from 'axios';

// Az Axios globálissá tétele, hogy bárhol elérhető legyen a projektben a 'window.axios' hivatkozással
window.axios = axios;

// Alapértelmezett fejléc beállítása: jelzi a szervernek, hogy az igény XMLHttpRequest (AJAX) típusú
// Ez segít a backendnek (pl. Laravel) felismerni a JavaScript alapú kéréseket
window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';