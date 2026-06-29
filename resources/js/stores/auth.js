import { defineStore } from 'pinia';
import axios from 'axios';

// Az 'auth' nevű Pinia store definiálása
export const useAuthStore = defineStore('auth', {

  state: () => ({
    // A bejelentkezett felhasználó adatai. Alapértelmezésben null.
    user: null,
    // A hozzáférési token. Indításkor megpróbálja kiolvasni a böngésző helyi tárolójából (localStorage).
    token: localStorage.getItem('token') || null,
  }),

  getters: {
    // Visszaadja (igaz/hamis), hogy a felhasználó be van-e jelentkezve (van-e érvényes token).
    isAuthenticated: (state) => !!state.token,
    // Visszaadja, hogy a felhasználó adminisztrátor-e.
    isAdmin: (state) => state.user?.is_admin || false,
  },

  actions: {
    // Bejelentkezési folyamat
    async login(email, password) {
      try {
        // POST kérés küldése a backend bejelentkezési végpontjára a hitelesítő adatokkal
        const response = await axios.post('/api/login', { email, password });
        
        // A state frissítése a szervertől kapott token-nel és felhasználói adatokkal
        this.token = response.data.access_token;
        this.user = response.data.user;
        
        // A token elmentése a localStorage-ba, hogy az oldal frissítése után is megmaradjon a bejelentkezés
        localStorage.setItem('token', this.token);
        
        // Az Axios alapértelmezett Authorization fejlécének beállítása
        axios.defaults.headers.common['Authorization'] = `Bearer ${this.token}`;
        
        return true;

      } catch (error) {
        console.error('Login error:', error);
        throw error; 
      }
    },

    // Kijelentkezési folyamat
    async logout() {
      try {
        // Értesítjük a szervert a kijelentkezésről (pl. token érvénytelenítése szerveroldalon)
        await axios.post('/api/logout');
      } catch (error) {
        console.error('Logout error:', error);
      } finally {
        // Kitöröljük a felhasználói adatokat és a tokent a state-ből
        this.user = null;
        this.token = null;
        
        // Töröljük a tokent a helyi tárolóból is
        localStorage.removeItem('token');
        
        // Eltávolítjuk a hitelesítési fejlécet az Axios alapértelmezett beállításai közül
        delete axios.defaults.headers.common['Authorization'];
      }
    },

    // Lekéri az éppen bejelentkezett felhasználó friss adatait a szerverről
    async fetchUser() {
      // Ha nincs token, meg sem próbáljuk a lekérést
      if (!this.token) return;

      try {
        // GET kérés küldése az aktuális felhasználó adataiért
        const response = await axios.get('/api/me');
        this.user = response.data; // Állapot frissítése az adatokkal
      } catch (error) {
        console.error('Fetch user error:', error);
        // Ha hiba történik (pl. lejárt vagy érvénytelen a token), automatikusan kijelentkeztetjük a felhasználót
        this.logout();
      }
    },

    initAuth() {
      // Megnézi, hogy volt-e token a localStorage-ban (amit a state betöltött)
      if (this.token) {
        // Ha igen, beállítja az Axios fejlécet a jövőbeli kérésekhez
        axios.defaults.headers.common['Authorization'] = `Bearer ${this.token}`;
        
        // És megpróbálja lekérni a felhasználó aktuális adatait
        this.fetchUser();
      }
    },
  },
});