import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router';
import { useAuthStore } from '../stores/auth';

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    component: () => import('../layouts/MainLayout.vue'), // Közös elrendezés (Layout) a publikus oldalaknak
    children: [
      {
        path: '',
        name: 'Home',
        component: () => import('../views/Home.vue'), // Főoldal
      },
      {
        path: 'cars',
        name: 'Cars',
        component: () => import('../views/Cars.vue'), // Autókatalógus
      },
      {
        path: 'cars/:id', // Dinamikus útvonal egy adott autó részleteihez
        name: 'CarDetail',
        component: () => import('../views/CarDetail.vue'),
      },
      {
        path: 'services', // Szolgáltatások
        name: 'Services',
        component: () => import('../views/Services.vue'),
      },
    ],
  },
  {
    path: '/admin/login', // Admin bejelentkezés
    name: 'AdminLogin',
    component: () => import('../views/admin/Login.vue'),
  },
  {
    path: '/admin', // Admin dashboard
    name: 'AdminDashboard',
    component: () => import('../views/admin/Dashboard.vue'),
    meta: { requiresAuth: true }, // Védett útvonal jelölése
  },
  {
    path: '/:pathMatch(.*)*', // 404-es hibakezelés minden ismeretlen útvonalra
    name: 'NotFound',
    component: () => import('../views/404.vue'),
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
  // Az oldal korábbi görgetési pozícióját állítja vissza
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) return savedPosition;

    // Sima görgetés kezelése hash (pl. #section1) esetén
    if (to.hash) {
      return new Promise((resolve) => {
        setTimeout(() => {
          const el = document.querySelector(to.hash) as HTMLElement | null;
          if (el) {
            el.scrollIntoView({ behavior: 'smooth' });
          }
          resolve({ left: 0, top: 0 });
        }, 200);
      });
    }

    return { left: 0, top: 0, behavior: 'smooth' };
  },
});

// Navigációs őr az autentikáció ellenőrzéséhez
router.beforeEach((to, from, next) => {
  const authStore = useAuthStore();

  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    next('/admin/login'); // Átirányítás, ha nincs bejelentkezve
  } else {
    next(); // Továbbengedés
  }
});

export default router;