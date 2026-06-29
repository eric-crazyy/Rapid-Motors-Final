<template>
  <div class="car-detail-root">

    <nav class="navbar" :class="{ scrolled: isScrolled }">
      <div class="nav-inner">
        <router-link to="/" class="nav-logo">
          <span class="logo-rapid">RAPID</span>
          <span class="logo-motors">MOTORS</span>
        </router-link>

        <router-link to="/cars" class="back-btn" aria-label="Back to catalogue">
          <span class="back-label">Back to catalogue</span>
          <span class="back-arrow">
            <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
              <path d="M6.5 3.5L12 9l-5.5 5.5" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </span>
        </router-link>
      </div>
    </nav>

    <div v-if="car" class="car-detail">
      <div class="detail-body">

        <div class="viewer-section">
          <div
            class="viewer-3d"
            ref="viewerContainer"
            :class="{ 'viewer-3d--interactive': viewerState === 'loaded' }"
            @mousemove="handleViewerMouseMove"
            @mousedown="onRotateStart"
            @mouseup="onRotateEnd"
            @mouseenter="isHoveringViewer = true"
            @mouseleave="onViewerMouseLeave"
          >

            <Transition name="cursor-fade">
              <div
                v-if="isHoveringViewer && viewerState === 'loaded'"
                class="viewer-cursor"
                :class="`cursor-dir-${cursorDirection}`"
                :style="{ transform: `translate(${cursorX}px, ${cursorY}px)` }"
              >
                <svg viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg" class="cursor-svg">
                  <circle cx="32" cy="32" r="24" stroke="rgba(201,169,97,0.1)" stroke-width="1" fill="none"/>
                  <circle
                    cx="32" cy="32" r="24"
                    stroke="rgba(201,169,97,0.7)" stroke-width="2"
                    stroke-dasharray="46 29"
                    stroke-linecap="round"
                    fill="none"
                    class="idle-arcs"
                  />
                  <g class="arrow-h">
                    <path d="M58 32 L51 26 M58 32 L51 38"
                      stroke="#c9a961" stroke-width="2.2" stroke-linecap="round" fill="none"/>
                    <line x1="42" y1="32" x2="55" y2="32"
                      stroke="#c9a961" stroke-width="1.5" stroke-linecap="round"/>
                    <path d="M6 32 L13 26 M6 32 L13 38"
                      stroke="#c9a961" stroke-width="2.2" stroke-linecap="round" fill="none"/>
                    <line x1="22" y1="32" x2="9" y2="32"
                      stroke="#c9a961" stroke-width="1.5" stroke-linecap="round"/>
                  </g>
                  <g class="arrow-v">
                    <path d="M32 6 L26 13 M32 6 L38 13"
                      stroke="#c9a961" stroke-width="2.2" stroke-linecap="round" fill="none"/>
                    <line x1="32" y1="22" x2="32" y2="9"
                      stroke="#c9a961" stroke-width="1.5" stroke-linecap="round"/>
                    <path d="M32 58 L26 51 M32 58 L38 51"
                      stroke="#c9a961" stroke-width="2.2" stroke-linecap="round" fill="none"/>
                    <line x1="32" y1="42" x2="32" y2="55"
                      stroke="#c9a961" stroke-width="1.5" stroke-linecap="round"/>
                  </g>
                  <circle cx="32" cy="32" r="2.5" fill="#c9a961" opacity="0.9"/>
                </svg>
              </div>
            </Transition>

            <Transition name="hint-fade">
              <div v-if="showRotateHint" class="rotate-hint">
                <svg class="hint-icon" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M15 9A6 6 0 1 1 9 3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                  <path d="M9 3 L13 3 L13 7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <span>Drag to rotate</span>
              </div>
            </Transition>

            <div v-if="viewerState === 'loading'" class="viewer-overlay">
              <div class="spinner"></div>
              <p class="overlay-text">Loading 3D model…</p>
            </div>

            <div v-else-if="viewerState === 'unavailable'" class="viewer-overlay no-model">
              <div class="no-model-graphic">
                <svg viewBox="0 0 80 80" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path
                    d="M40 10L68 24V56L40 70L12 56V24L40 10Z"
                    stroke="currentColor" stroke-width="1.2" stroke-dasharray="5 4"
                    stroke-linejoin="round"
                  />
                  <line x1="30" y1="34" x2="50" y2="46" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                  <line x1="50" y1="34" x2="30" y2="46" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                  <path d="M40 10L68 24L40 38L12 24L40 10Z" stroke="currentColor" stroke-width="1.2" stroke-linejoin="round" opacity="0.35"/>
                </svg>
              </div>
              <p class="no-model-title">No 3D model available</p>
              <p class="no-model-sub">
                No 3D file is available for the<br>
                <em>{{ car.manufacturer }} {{ car.name }}</em>.
              </p>
            </div>

          </div>

          <div class="controls-hint-spacer"></div>
        </div>

        <div class="info-section">

          <div class="car-header">
            <span class="car-badge">
              <span class="badge-dot"></span>
              {{ huCategoryMap.get(car.category) }}
            </span>
            <div class="title-block">
              <h1 class="car-manufacturer">{{ car.manufacturer }}</h1>
              <h2 class="car-model">{{ car.name }}</h2>
            </div>
            <span class="car-year">{{ car.year }}</span>
            <div class="header-rule"></div>
          </div>

          <p class="car-description">{{ car.description }}</p>

          <div class="specs-grid">
            <div class="spec-card" v-for="spec in specs" :key="spec.label">
              <div class="spec-icon-wrap">
                <span class="spec-icon">{{ spec.icon }}</span>
              </div>
              <div>
                <div class="spec-label">{{ spec.label }}</div>
                <div class="spec-value">{{ spec.value }}</div>
              </div>
            </div>
          </div>

          <div class="price-actions-block">
            <div class="price-row">
              <div class="price-block">
                <span class="price-label">List price</span>
                <span class="price-value">{{ formatPrice(car.price) }}</span>
              </div>
            </div>

            <div class="actions">
              <div class="btn-wrap" data-tooltip="This feature will be available soon.">
                <button class="btn-primary" disabled>
                  <span class="btn-icon">✉</span>
                  Enquire
                </button>
              </div>
              <div class="btn-wrap" data-tooltip="Saving favourites is under development.">
                <button class="btn-secondary" disabled>
                  <span class="btn-icon">♡</span>
                  Add to favourites
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-else class="page-loading">
      <div class="spinner large"></div>
      <p class="loading-label">Loading…</p>
    </div>

  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import axios from 'axios';
import { huCategoryMap } from '../assets/js/CarData.js';
import { use3DViewer } from '../assets/js/3DViewer.js';

const route  = useRoute();
const router = useRouter();

const car        = ref(null);
const isScrolled = ref(false);

const viewerContainer = ref(null);

const {
  viewerState, isHoveringViewer, cursorX, cursorY,
  cursorDirection, showRotateHint,
  init3DViewer, destroyViewer,
  handleViewerMouseMove, onRotateStart, onRotateEnd, onViewerMouseLeave,
} = use3DViewer(viewerContainer);

const specs = computed(() => car.value ? [
  { icon: '⚡', label: 'Power',        value: `${car.value.horsepower} HP`  },
  { icon: '🏁', label: 'Top speed',    value: `${car.value.top_speed} km/h` },
  { icon: '🚀', label: '0–100 km/h',   value: `${car.value.acceleration}s`  },
  { icon: '🔧', label: 'Engine',       value: car.value.engine              },
] : []);

const formatPrice = (price) =>
  new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 0,
  }).format(price);

const fetchCar = async () => {
  try {
    const { data } = await axios.get(`/api/cars/${route.params.id}`);
    car.value = data;

    await new Promise(r => setTimeout(r, 80));
    init3DViewer(car.value.name);
  } catch (e) {
    console.error('Error fetching car:', e);
    router.push('/404');
  }
};

let __navHideStyle = null;

const handleNavScroll = () => { isScrolled.value = window.scrollY > 50; };

onMounted(() => {
  window.addEventListener('scroll', handleNavScroll, { passive: true });

  __navHideStyle = document.createElement('style');
  __navHideStyle.id = '__car-detail-hide-nav';
  __navHideStyle.textContent = `
    body > header, body > nav,
    #app > header, #app > nav,
    #app > div > header, #app > div > nav,
    .nav,
    .navbar:not(.car-detail-root .navbar),
    .nav-bar:not(.car-detail-root .nav-bar),
    .app-header, .app-navbar, .app-nav,
    .global-nav, .global-navbar, .global-header,
    .layout-nav, .layout-header,
    .site-header, .site-nav,
    .main-nav, .main-header,
    .top-nav, .top-bar,
    .header-wrapper, .nav-wrapper { display: none !important; }
  `;
  document.head.appendChild(__navHideStyle);

  fetchCar();
});

onUnmounted(() => {
  window.removeEventListener('scroll', handleNavScroll);
  __navHideStyle?.remove();
  __navHideStyle = null;
  destroyViewer();
});
</script>

<style>
@import '@/assets/css/carDetail.css';
</style>