<template>
  <div class="admin-login">
    <div class="login-container">
      <div class="login-header">
        <div class="logo shiftedLogo">
          <span class="login-logo-rapid">RAPID</span>
          <span class="login-logo-motors">MOTORS</span>
        </div>
      </div>

      <form @submit.prevent="handleLogin" class="login-form">
        <div class="form-group">
          <label for="email" class="form-label">Email address</label>
          <input
            id="email"
            v-model="email"
            type="email"
            required
            class="form-input"
            placeholder="admin@rapidmotors.com"
          />
        </div>

        <div class="form-group">
          <label for="password" class="form-label">Password</label>
          <input
            id="password"
            v-model="password"
            type="password"
            required
            class="form-input"
            placeholder="••••••••"
          />
        </div>

        <div v-if="error" class="error-message">
          {{ error }}
        </div>

        <button type="submit" class="login-btn" :disabled="loading">
          <span v-if="!loading">Log in</span>
          <span v-else>Logging in...</span>
        </button>
      </form>

      <router-link to="/" class="back-link">← Back to home</router-link>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '../../stores/auth';

const router = useRouter();
const authStore = useAuthStore();

const email = ref('');
const password = ref('');
const loading = ref(false);
const error = ref('');

const handleLogin = async () => {
  loading.value = true;
  error.value = '';

  try {
    await authStore.login(email.value, password.value);
    router.push('/admin');
  } catch (err) {
    error.value = err.response?.data?.message || 'Login failed';
  } finally {
    loading.value = false;
  }
};
</script>

<style>
@import '@/assets/css/admin/login.css';
</style>