<template>
  <!-- A router-view jeleníti meg az aktuális route-hoz tartozó komponenst -->
  <router-view />
</template>

<script setup>
import { onMounted } from 'vue'

onMounted(() => {
  // Beállítjuk az egész oldalra a smooth (finom) görgetést
  document.documentElement.style.scrollBehavior = 'smooth'
})
</script>
