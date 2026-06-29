<script setup>
import { ref, computed, onMounted, onUnmounted, provide, nextTick } from 'vue'
import { RouterView, useRouter } from 'vue-router'

if (typeof window !== 'undefined' && 'scrollRestoration' in history) {
  history.scrollRestoration = 'manual'
}

const router = useRouter()

const isScrolled = ref(false)
const isNavbarVisible = ref(true)
const isHeroVisible = ref(true)
const parallaxOffset = ref(0)

const mobileMenuOpen = ref(false)

const hideNavLogo = computed(() => {
  if (router.currentRoute.value.path !== '/') return false
  return isHeroVisible.value || parallaxOffset.value < 200
})

let lastScrollY = typeof window !== 'undefined' ? window.scrollY : 0
let ticking = false

const handleScroll = () => {
  const currentScrollY = window.scrollY
  if (!ticking) {
    window.requestAnimationFrame(() => {
      isScrolled.value = currentScrollY > 50
      parallaxOffset.value = currentScrollY
      isNavbarVisible.value = !(currentScrollY > lastScrollY && currentScrollY > 100)
      lastScrollY = currentScrollY
      ticking = false
    })
    ticking = true
  }
}

const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value
  if (mobileMenuOpen.value) {
    document.body.style.overflow = 'hidden'
  } else {
    document.body.style.overflow = ''
  }
}

const closeMobileMenu = () => {
  mobileMenuOpen.value = false
  document.body.style.overflow = ''
}

router.beforeEach((to, from, next) => {
  if (to.path === '/') {
    isHeroVisible.value = true
    parallaxOffset.value = 0
  }
  next()
})

const saveScrollOnRefresh = () => {
  sessionStorage.setItem('refreshScrollPosition', window.scrollY.toString())
  sessionStorage.setItem('refreshPath', window.location.pathname + window.location.search + window.location.hash)
}

const restoreScrollOnLoad = () => {
  const savedPosition = sessionStorage.getItem('refreshScrollPosition')
  const savedPath = sessionStorage.getItem('refreshPath')
  const currentPath = window.location.pathname + window.location.search + window.location.hash

  if (savedPosition && savedPath === currentPath) {
    const pos = parseInt(savedPosition, 10)

    if (pos > 0) {
      window.scrollTo({ top: pos, behavior: 'auto' })
      parallaxOffset.value = pos

      let attempts = 0
      const checkAndScroll = setInterval(() => {
        attempts++
        if (document.documentElement.scrollHeight >= pos + window.innerHeight) {
          window.scrollTo({ top: pos, behavior: 'auto' })
          parallaxOffset.value = pos
          clearInterval(checkAndScroll)
        }
        if (attempts > 15) clearInterval(checkAndScroll)
      }, 100)
    } else {
      window.scrollTo({ top: 0, behavior: 'auto' })
      parallaxOffset.value = 0
    }
  } else if (window.location.hash) {
    let attempts = 0
    const hashScroll = setInterval(() => {
      attempts++
      const el = document.getElementById(window.location.hash.substring(1))
      if (el) {
        el.scrollIntoView({ behavior: 'auto', block: 'start' })
        clearInterval(hashScroll)
      }
      if (attempts > 15) clearInterval(hashScroll)
    }, 100)
  }

  sessionStorage.removeItem('refreshScrollPosition')
  sessionStorage.removeItem('refreshPath')
}

router.afterEach(async (to, from) => {
  closeMobileMenu()
  await nextTick()

  if (from.name !== undefined) {
    if (to.hash) {
      setTimeout(() => {
        const targetId = to.hash.substring(1)
        const element = document.getElementById(targetId)
        if (element) {
          element.scrollIntoView({ behavior: 'smooth', block: 'start' })
        }
      }, 300)
    } else if (to.path !== from.path) {
      window.scrollTo({ top: 0, behavior: 'auto' })
      parallaxOffset.value = 0
    }
  }
})

const scrollToSection = async (sectionId) => {
  closeMobileMenu()
  const currentPath = router.currentRoute.value.path
  await nextTick()

  if (currentPath === '/' || currentPath === '') {
    const element = document.getElementById(sectionId)
    if (element) {
      element.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }
  } else {
    router.push({ path: '/', hash: '#' + sectionId })
  }
}

const handleResize = () => {
  if (window.innerWidth > 768 && mobileMenuOpen.value) {
    closeMobileMenu()
  }
}

onMounted(() => {
  lastScrollY = window.scrollY
  parallaxOffset.value = window.scrollY

  window.addEventListener('scroll', handleScroll, { passive: true })
  window.addEventListener('resize', handleResize, { passive: true })
  window.addEventListener('beforeunload', saveScrollOnRefresh)

  restoreScrollOnLoad()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  window.removeEventListener('resize', handleResize)
  window.removeEventListener('beforeunload', saveScrollOnRefresh)
  document.body.style.overflow = ''
})

provide('parallaxOffset', parallaxOffset)
provide('setHeroVisible', (val) => { isHeroVisible.value = val })
</script>

<template>
  <div class="layout">

    <div class="grain-overlay" aria-hidden="true" />

    <nav class="nav" :class="{ scrolled: isScrolled, hidden: !isNavbarVisible || mobileMenuOpen }">
      <div class="nav-container">

        <router-link to="/" class="nav-logo" :class="{ 'logo-hidden': hideNavLogo }">
          <span class="logo-rapid">RAPID</span>
          <span class="logo-motors">MOTORS</span>
        </router-link>

        <div class="nav-links">
          <router-link to="/" class="nav-link">
            <span class="link-text">Home</span>
            <span class="link-line"></span>
          </router-link>

          <router-link to="/cars" class="nav-link">
            <span class="link-text">Vehicles</span>
            <span class="link-line"></span>
          </router-link>

          <router-link to="/services" class="nav-link">
            <span class="link-text">Services</span>
            <span class="link-line"></span>
          </router-link>

          <a href="javascript:void(0)" @click.prevent="scrollToSection('about')" class="nav-link">
            <span class="link-text">About us</span>
            <span class="link-line"></span>
          </a>

          <a href="javascript:void(0)" @click.prevent="scrollToSection('contact')" class="nav-link">
            <span class="link-text">Contact</span>
            <span class="link-line"></span>
          </a>
        </div>

        <button
          class="hamburger"
          :class="{ active: mobileMenuOpen }"
          @click="toggleMobileMenu"
          aria-label="Toggle menu"
        >
          <span class="hamburger-line"></span>
          <span class="hamburger-line"></span>
          <span class="hamburger-line"></span>
        </button>

      </div>
    </nav>

    <div
      class="menu-backdrop"
      :class="{ active: mobileMenuOpen }"
      @click="closeMobileMenu"
    ></div>

    <div class="mobile-menu" :class="{ active: mobileMenuOpen }">
      <nav class="mobile-nav-links">
        <router-link to="/" class="mobile-nav-link" @click="closeMobileMenu">
          <span class="mobile-link-text">Home</span>
        </router-link>

        <router-link to="/cars" class="mobile-nav-link" @click="closeMobileMenu">
          <span class="mobile-link-text">Vehicles</span>
        </router-link>

        <router-link to="/services" class="mobile-nav-link" @click="closeMobileMenu">
          <span class="mobile-link-text">Services</span>
        </router-link>

        <a href="javascript:void(0)" @click.prevent="scrollToSection('about')" class="mobile-nav-link">
          <span class="mobile-link-text">About us</span>
        </a>

        <a href="javascript:void(0)" @click.prevent="scrollToSection('contact')" class="mobile-nav-link">
          <span class="mobile-link-text">Contact</span>
        </a>
      </nav>
    </div>

    <main>
      <RouterView />
    </main>

    <footer class="footer">
      <div class="footer-content">
        <div class="footer-logo">
          <span class="logo-rapid">RAPID</span>
          <span class="logo-motors">MOTORS</span>
        </div>
        <p class="footer-text">© 2026 Rapid Motors. All rights reserved.</p>
      </div>
    </footer>

  </div>
</template>

<style>
@import '@/assets/css/mainLayout.css';
</style>