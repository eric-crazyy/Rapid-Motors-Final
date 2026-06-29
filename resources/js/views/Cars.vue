<template>
  <div class="cars-page">

    <header class="cars-hero" :class="{ loaded: heroLoaded }">
      <div class="cars-hero-bg" />
      <div class="cars-hero-overlay" />
      <div class="cars-hero-content">
        <div class="hero-eyebrow">
          <span class="eyebrow-line" />
          <span class="eyebrow-text">VEHICLES</span>
          <span class="eyebrow-line right" />
        </div>
        <h1 class="cars-hero-title">
          <span class="title-word" style="--i:0">CAR</span>
          <span class="title-word italic" style="--i:1">CATALOGUE</span>
        </h1>
        <p class="cars-hero-subtitle">
          <span
            class="subtitle-char"
            v-for="(ch, i) in 'Discover our exclusive collection'"
            :key="i"
            :style="`--d:${i * 10}ms`"
          >{{ ch === ' ' ? '\u00A0' : ch }}</span>
        </p>
      </div>
      <div class="hero-corner-tl" />
      <div class="hero-corner-br" />
    </header>

    <div class="filters-bar">
      <div class="filters-inner">
        <div class="filters-left">
          <div class="filter-group">
            <button
              v-for="cat in [
                { id: 'all',      label: 'All'        },
                { id: 'oldtimer', label: 'Oldtimers'  },
                { id: 'supercar', label: 'Supercars'  },
                { id: 'luxury',   label: 'Luxury cars'}
              ]"
              :key="cat.id"
              :class="['filter-btn', { active: activeCategory === cat.id }]"
              @click="filterByCategory(cat.id)"
            >
              {{ cat.label }}
            </button>
          </div>
          <div class="filter-count" v-if="filteredCars.length">
            <span class="count-number">{{ filteredCars.length }}</span>
            <span class="count-label">vehicles</span>
          </div>
        </div>
        <div class="search-wrap">
          <svg class="search-icon" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
            <circle cx="8.5" cy="8.5" r="5.5" stroke="currentColor" stroke-width="1.5"/>
            <path d="M13 13L17 17" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search by make, model…"
            class="search-input"
          />
          <button v-if="searchQuery" @click="searchQuery = ''" class="search-clear">✕</button>
        </div>
      </div>
    </div>

    <div class="cars-container">
      <div class="cars-list">
        <div
          v-for="car in filteredCars"
          :key="car.id"
          class="car-item"
          @click="selectCar(car)"
          :class="{ selected: selectedCar?.id === car.id }"
        >
          <div class="car-thumb-wrap">
            <img
              v-if="!failedImages.has(car.id)"
              :src="getImagePath(car)"
              :alt="car.manufacturer + ' ' + car.name"
              class="car-thumbnail"
              @error="handleImageError(car.id)"
            />
            <div v-else class="car-thumb-fallback">
              <span>Image not available</span>
            </div>
          </div>
          <div class="car-info">
            <div class="car-category">{{
              car.category === 'oldtimer'  ? 'OLDTIMER'   :
              car.category === 'supercar'  ? 'SUPERCAR'   :
                                             'LUXURY CAR'
            }}</div>
            <h3 class="car-name">{{ car.manufacturer }} {{ car.name }}</h3>
            <div class="car-specs-mini">
              <span>{{ car.year }}</span>
              <span>•</span>
              <span>{{ car.horsepower }} HP</span>
            </div>
            <div class="car-price-mini">{{ formatPrice(car.price) }}</div>
          </div>
          <div class="model-badge" :class="hasModel(car) ? 'model-badge--on' : 'model-badge--off'">
            <span>{{ hasModel(car) ? '3D' : '–' }}</span>
          </div>
        </div>
      </div>

      <div class="car-viewer" v-if="selectedCar">
        <div class="viewer-header">
          <h2 class="viewer-title">{{ selectedCar.manufacturer }} {{ selectedCar.name }}</h2>
          <router-link :to="`/cars/${selectedCar.id}`" class="view-full-btn">
            Full view →
          </router-link>
        </div>

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

          <div v-if="viewerState === 'loading'" class="viewer-state-overlay">
            <div class="spinner"></div>
            <p class="state-text">Loading 3D model...</p>
          </div>

          <div v-else-if="viewerState === 'unavailable'" class="viewer-state-overlay">
            <div class="no-model-icon">
              <svg viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="8" y="20" width="48" height="28" rx="3" stroke="currentColor" stroke-width="1.5" stroke-dasharray="4 3"/>
                <path d="M20 20V16a4 4 0 014-4h16a4 4 0 014 4v4" stroke="currentColor" stroke-width="1.5"/>
                <path d="M24 32l16 8M40 32l-16 8" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                <circle cx="52" cy="12" r="8" fill="#0f0f0f" stroke="currentColor" stroke-width="1.5"/>
                <path d="M49 12h6M52 9v6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" transform="rotate(45 52 12)"/>
              </svg>
            </div>
            <p class="state-title">No 3D model available</p>
            <p class="state-sub">No 3D file is available for the <em>{{ selectedCar.manufacturer }} {{ selectedCar.name }}</em>.</p>
          </div>
        </div>

        <div class="viewer-info">
          <div class="info-grid">
            <div class="info-item">
              <div class="info-label">Power</div>
              <div class="info-value">{{ selectedCar.horsepower }} HP</div>
            </div>
            <div class="info-item">
              <div class="info-label">Top speed</div>
              <div class="info-value">{{ selectedCar.top_speed }} km/h</div>
            </div>
            <div class="info-item">
              <div class="info-label">Acceleration</div>
              <div class="info-value">{{ selectedCar.acceleration }}s</div>
            </div>
            <div class="info-item">
              <div class="info-label">Price</div>
              <div class="info-value">{{ formatPrice(selectedCar.price) }}</div>
            </div>
          </div>
        </div>
      </div>

      <div v-else class="no-selection">
        <div class="no-selection-icon">🏎️</div>
        <p>Select a car to view the details</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, nextTick, onMounted, onUnmounted } from 'vue';
import { useRoute } from 'vue-router';
import { use3DViewer } from '../assets/js/3DViewer.js';
import { MODEL_MAP, getImagePath } from '../assets/js/CarData.js';
import axios from 'axios';

const route         = useRoute();
const allCars       = ref([]);
const selectedCar   = ref(null);
const activeCategory = ref('all');
const searchQuery   = ref('');
const heroLoaded    = ref(false);
const failedImages  = ref(new Set());

const viewerContainer = ref(null);

const {
  viewerState, isHoveringViewer, cursorX, cursorY,
  cursorDirection, showRotateHint,
  init3DViewer, destroyViewer, showHintSoon,
  handleViewerMouseMove, onRotateStart, onRotateEnd, onViewerMouseLeave,
} = use3DViewer(viewerContainer);

watch(viewerState, (state) => {
  if (state === 'loaded') {
    showHintSoon(800);
  } else {
    showRotateHint.value = false;
  }
});

const VALID_CATEGORIES = ['oldtimer', 'supercar', 'luxury'];

const filteredCars = computed(() => {
  let cars = allCars.value;
  if (activeCategory.value !== 'all') {
    cars = cars.filter(c => c.category === activeCategory.value);
  }
  const q = searchQuery.value.trim().toLowerCase();
  if (q) {
    cars = cars.filter(c =>
      c.manufacturer.toLowerCase().includes(q) ||
      c.name.toLowerCase().includes(q)
    );
  }
  return cars;
});

const selectFirstFiltered = async () => {
  destroyViewer();
  selectedCar.value = null;
  if (filteredCars.value.length) {
    await selectCar(filteredCars.value[0]);
  }
};

const filterByCategory = (id) => {
  activeCategory.value = id;
  selectFirstFiltered();
};

const selectCar = async (car) => {
  selectedCar.value = car;
  await nextTick();
  init3DViewer(car.name);
};

const hasModel = (car) => Boolean(MODEL_MAP[car.name]);

const handleImageError = (id) => {
  failedImages.value = new Set([...failedImages.value, id]);
};

const formatPrice = (price) =>
  new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 0,
  }).format(price);

watch(() => route.query.category, (newCat) => {
  const resolved = VALID_CATEGORIES.includes(newCat) ? newCat : 'all';
  if (resolved !== activeCategory.value) {
    activeCategory.value = resolved;
    selectFirstFiltered();
  }
});

onMounted(async () => {
  heroLoaded.value = true;

  const urlCategory = route.query.category;
  if (VALID_CATEGORIES.includes(urlCategory)) {
    activeCategory.value = urlCategory;
  }

  try {
    const { data } = await axios.get('/api/cars');
    allCars.value = data;
    if (filteredCars.value.length) {
      await selectCar(filteredCars.value[0]);
    }
  } catch (e) {
    console.error('Error fetching cars:', e);
  }
});

onUnmounted(() => {
  destroyViewer();
});
</script>

<style>
@import '@/assets/css/cars.css';
</style>