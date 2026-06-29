<template>
  <div class="not-found">
    <div class="content">
      <div class="error-code">404</div>
      <h1 class="error-title">Page not found</h1>
      <p class="error-sub">The page you are looking for does not exist or has been removed.</p>
      <router-link to="/" class="error-home-btn">← Back to home</router-link>
    </div>
  </div>
</template>

<script setup>
</script>

<style>
@import '@/assets/css/404.css';
</style>