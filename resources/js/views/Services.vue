<script setup>
import { ref, onMounted, onUnmounted, inject } from 'vue'

const hero = ref(null)
const heroLoaded = ref(false)
const ctaReady = ref(false)
const revealedSections = ref(new Set())
const selectedService = ref(null)
const activeAccordion = ref(null)

const parallaxOffset = inject('parallaxOffset', ref(0))
const setHeroVisible = inject('setHeroVisible', () => {})

const services = [
  {
    id: 1,
    icon: '🔧',
    title: 'Full maintenance',
    subtitle: 'Expert car care',
    description: 'We offer professional maintenance services for all premium and classic vehicles.',
    features: [
      'Regular servicing and diagnostics',
      'Sourcing original parts',
      'Engine and suspension overhaul',
      'Air conditioning and electronics service'
    ],
    price: 'Price: $690',
    image: 'images/services1.jpg'
  },
  {
    id: 2,
    icon: '🫧',
    title: 'Premium car wash',
    subtitle: 'Detailed cleaning',
    description: 'Luxury interior and exterior cleaning to the highest quality standards.',
    features: [
      'Hand car wash with premium products',
      'Full interior cleaning and conditioning',
      'Wax treatment and polishing',
      'Engine bay and wheel arch cleaning'
    ],
    price: 'Price: $275',
    image: 'images/services2.jpg'
  },
  {
    id: 3,
    icon: '⚒️',
    title: 'Partial restoration',
    subtitle: 'Expert recovery',
    description: 'Professional restoration of classic and veteran cars.',
    features: [
      'Paintwork and bodywork',
      'Chrome plating and nickel plating',
      'Interior upholstery restoration',
      'Returning to original condition'
    ],
    price: 'Custom quote',
    image: 'images/services3.jpg'
  },
  {
    id: 4,
    icon: '🛡️',
    title: 'Protective coating',
    subtitle: 'Ceramic coating and PPF',
    description: 'Long-lasting protection for painted surfaces and bodywork.',
    features: [
      'Ceramic coating application',
      'PPF wrapping (Paint Protection Film)',
      'Hydrophobic glass coating',
      '5–10 year warranty on coatings'
    ],
    price: 'Price: $415',
    image: 'images/services4.jpg'
  },
  {
    id: 5,
    icon: '🛒',
    title: 'Car dealership',
    subtitle: 'Buying and selling',
    description: 'We help you find your dream car or sell your current one.',
    features: [
      'Personalised car search',
      'Market valuation and consulting',
      'Consignment sales',
      'Full administrative handling'
    ],
    price: 'Custom agreement',
    image: 'images/services5.jpg'
  },
  {
    id: 6,
    icon: '📦',
    title: 'Storage',
    subtitle: 'Secure keeping',
    description: 'Climate-controlled storage facilities for luxury vehicles.',
    features: [
      'Climate-controlled dehumidified environment',
      '24/7 camera system and security guard',
      'Periodic starting and moving',
      'Maintenance package option'
    ],
    price: 'Price: $140/month',
    image: 'images/services6.jpg'
  }
]

const processSteps = [
  {
    number: '01',
    title: 'Consultation',
    description: 'Detailed needs assessment and personal consultation with our experts.'
  },
  {
    number: '02',
    title: 'Quote',
    description: 'A transparent, detailed quote covering every aspect of the service.'
  },
  {
    number: '03',
    title: 'Execution',
    description: 'Professional work carried out to the highest quality standards.'
  },
  {
    number: '04',
    title: 'Handover',
    description: 'Detailed handover, documentation, and explanation of warranty terms.'
  }
]

const faqs = [
  {
    question: 'What car brands do you service?',
    answer: 'We work with all premium and classic car brands, including Ferrari, Porsche, Lamborghini, Mercedes-Benz, Bentley, Rolls-Royce, and a wide range of veteran cars.'
  },
  {
    question: 'How long does a full maintenance service take?',
    answer: 'Depending on the complexity of the work, it takes 1–3 days. In urgent cases, an express service can also be arranged by appointment.'
  },
  {
    question: 'Do you use genuine parts?',
    answer: 'We use only genuine or OEM-quality parts. For veteran cars, we assist in sourcing original parts worldwide.'
  },
  {
    question: 'Do you offer a warranty on your work?',
    answer: 'Yes, we provide a 12-month warranty on all our services. Special coatings can carry a warranty of up to 5–10 years.'
  },
  {
    question: 'How can I make a booking?',
    answer: 'You can arrange an appointment by phone, email, or in person. We aim to respond to all enquiries within 48 hours.'
  }
]

const scrollToSection = (sectionId) => {
  const element = document.getElementById(sectionId)
  if (element) {
    element.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }
}

const openServiceModal = (service) => {
  selectedService.value = service
  document.body.style.overflow = 'hidden'
}

const closeServiceModal = () => {
  selectedService.value = null
  document.body.style.overflow = ''
}

const toggleAccordion = (index) => {
  activeAccordion.value = activeAccordion.value === index ? null : index
}

const initReveal = () => {
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        revealedSections.value.add(entry.target.dataset.reveal)
      }
    })
  }, {
    rootMargin: '0px 0px -15% 0px',
    threshold: 0.05
  })

  document.querySelectorAll('[data-reveal]').forEach(el => revealObserver.observe(el))

  const heroObserver = new IntersectionObserver(
    ([entry]) => { setHeroVisible(entry.isIntersecting) },
    { rootMargin: '-80px 0px 0px 0px', threshold: 0 }
  )
  if (hero.value) heroObserver.observe(hero.value)
}

onMounted(() => {
  setTimeout(() => { heroLoaded.value = true }, 50)
  setTimeout(() => { ctaReady.value = true }, 1000)
  initReveal()
})

onUnmounted(() => {
  document.body.style.overflow = ''
  setHeroVisible(false)
})
</script>

<template>
  <div class="services-page">

    <section class="services-hero" ref="hero" :class="{ loaded: heroLoaded }">
      <div
        class="hero-bg"
        :style="{ transform: `translateY(${parallaxOffset * 0.3}px)` }"
      />
      <div class="hero-overlay" />

      <div class="hero-orb orb-1" :style="{ transform: `translateY(${parallaxOffset * 0.15}px)` }" />
      <div class="hero-orb orb-2" :style="{ transform: `translateY(${parallaxOffset * 0.25}px)` }" />

      <div class="hero-content-wrapper">
        <div class="hero-badge">
          <span class="badge-line" />
          <span class="badge-text">SERVICES</span>
          <span class="badge-line right" />
        </div>

        <h1 class="hero-main-title">
          <span class="title-line" style="--i:0">Premium</span>
          <span class="title-line italic" style="--i:1">Vehicle Care</span>
        </h1>

        <p class="hero-description">
          <span
            class="subtitle-char"
            v-for="(ch, i) in 'Expert services for luxury and classic vehicles'"
            :key="i"
            :style="`--d:${i * 10}ms`"
          >{{ ch === ' ' ? '\u00A0' : ch }}</span>
        </p>

        <a
          href="#services-list"
          class="hero-cta-btn"
          :class="{ ready: ctaReady }"
          @click.prevent="scrollToSection('services-list')"
        >
          <span class="btn-text">Explore our services</span>
          <span class="btn-arrow">↓</span>
          <span class="cta-shimmer" />
        </a>
      </div>

      <div class="hero-scroll-hint">
        <div class="scroll-line"><div class="scroll-dot" /></div>
        <span class="scroll-label">SCROLL</span>
      </div>
    </section>

    <section
      class="services-grid-section"
      id="services-list"
      data-reveal="services"
      :class="{ revealed: revealedSections.has('services') }"
    >
      <div class="section-intro">
        <span class="section-label">SERVICES</span>
        <h2 class="section-title">What we offer</h2>
      </div>

      <div class="services-grid">
        <div
          v-for="(service, idx) in services"
          :key="service.id"
          class="service-card"
          :style="`--delay: ${idx * 40}ms`"
          @click="openServiceModal(service)"
        >
          <div class="service-image-wrapper">
            <img :src="service.image" :alt="service.title" class="service-image" loading="lazy" />
            <div class="service-overlay">
              <div class="service-icon">{{ service.icon }}</div>
            </div>
          </div>

          <div class="service-content">
            <div class="service-subtitle">{{ service.subtitle }}</div>
            <h3 class="service-title">{{ service.title }}</h3>
            <p class="service-description">{{ service.description }}</p>

            <div class="service-footer">
              <div class="service-price">{{ service.price }}</div>
              <div class="service-arrow">→</div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section
      class="process-section"
      data-reveal="process"
      :class="{ revealed: revealedSections.has('process') }"
    >
      <div class="process-bg-grid" />

      <div class="process-content">
        <div class="section-intro centered">
          <span class="section-label">PROCESS</span>
          <h2 class="section-title">How we work</h2>
        </div>

        <div class="process-steps">
          <div
            v-for="(step, idx) in processSteps"
            :key="idx"
            class="process-step"
            :style="`--step-delay: ${idx * 50}ms`"
          >
            <div class="step-number">{{ step.number }}</div>
            <div class="step-content">
              <h3 class="step-title">{{ step.title }}</h3>
              <p class="step-description">{{ step.description }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section
      class="faq-section"
      data-reveal="faq"
      :class="{ revealed: revealedSections.has('faq') }"
    >
      <div class="section-intro centered">
        <span class="section-label">FREQUENTLY ASKED QUESTIONS</span>
        <h2 class="section-title">Learn more</h2>
      </div>

      <div class="faq-list">
        <div
          v-for="(faq, idx) in faqs"
          :key="idx"
          class="faq-item"
          :class="{ active: activeAccordion === idx }"
          :style="`--faq-delay: ${idx * 30}ms`"
        >
          <button class="faq-question" @click="toggleAccordion(idx)">
            <span>{{ faq.question }}</span>
            <span class="faq-toggle">{{ activeAccordion === idx ? '−' : '+' }}</span>
          </button>
          <div class="faq-answer-wrapper">
            <div class="faq-answer">{{ faq.answer }}</div>
          </div>
        </div>
      </div>
    </section>

    <section
      class="cta-section"
      data-reveal="cta"
      :class="{ revealed: revealedSections.has('cta') }"
    >
      <div class="cta-bg-pattern" />
      <div class="cta-content">
        <h2 class="cta-title">Ready to take the next step?</h2>
        <p class="cta-text-service">
          Get in touch with us and let's start taking care of your car together
        </p>
        <div class="cta-buttons">
          <div class="btn-wrap" data-tooltip="This feature will be available soon.">
            <button class="cta-btn primary" disabled>
              <span>Call us</span>
            </button>
          </div>

          <router-link to="/" class="cta-btn secondary">
            <span>Back to home</span>
            <span class="btn-icon">→</span>
          </router-link>
        </div>
      </div>
    </section>

    <Transition name="modal">
      <div
        v-if="selectedService"
        class="service-modal-overlay"
        @click="closeServiceModal"
      >
        <div class="service-modal" @click.stop>
          <button class="modal-close" @click="closeServiceModal">×</button>

          <div class="modal-image">
            <img :src="selectedService.image" :alt="selectedService.title" />
            <div class="modal-icon">{{ selectedService.icon }}</div>
          </div>

          <div class="modal-content">
            <div class="modal-subtitle">{{ selectedService.subtitle }}</div>
            <h3 class="modal-title">{{ selectedService.title }}</h3>
            <p class="modal-description">{{ selectedService.description }}</p>

            <div class="modal-features">
              <h4 class="features-title">Service details:</h4>
              <ul class="features-list">
                <li v-for="(feature, idx) in selectedService.features" :key="idx">
                  <span class="feature-bullet">◆</span>
                  <span>{{ feature }}</span>
                </li>
              </ul>
            </div>

            <div class="modal-footer">
              <div class="modal-price">{{ selectedService.price }}</div>

              <div class="btn-wrap" data-tooltip="Appointment booking will be available soon.">
                <button class="modal-cta" disabled>
                  Book an appointment
                  <span class="cta-arrow">→</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Transition>

  </div>
</template>

<style>
@import '@/assets/css/services.css';
</style>