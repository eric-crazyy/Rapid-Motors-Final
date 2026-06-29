import { createApp } from 'vue';
import { createPinia } from 'pinia';
import { useAuthStore } from './stores/auth';
import router from './router/routes';
import App from './App.vue';


// Mainlayout CSS fájl beimportálása
import './assets/css/mainLayout.css';

const app = createApp(App);
const pinia = createPinia();

// Pinia store és router használása
app.use(pinia);
app.use(router);

// Auth store
const authStore = useAuthStore();
authStore.initAuth();

app.mount('#app');
