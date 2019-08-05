<template>
  <v-app>
    <v-content>
      <v-layout
        v-if="$wait.any"
        fill-height
        column
        justify-center
        align-center
      >
        <v-progress-circular
          :size="50"
          color="primary"
          indeterminate
        />

        <span class="mt-4">
          Lataa sisältöä...
        </span>
      </v-layout>

      <router-view
        v-show="!$wait.any"
      />
    </v-content>

    <v-bottom-nav
      :active.sync="currentNavIndex"
      :value="true"
      fixed
      app
    >
      <v-btn
        v-for="(navItem, i) in navItems"
        :key="i"
        :color="navItem.color"
        :to="navItem.to"
        flat
      >
        <span>
          {{ navItem.label }}
        </span>
        <v-icon>
          {{ navItem.icon }}
        </v-icon>
      </v-btn>
    </v-bottom-nav>

    <snackbar />

  </v-app>
</template>

<script>
  import Snackbar from '@/components/Snackbar';

  export default {
    components: {
      Snackbar,
    },

    data: () => ({
      currentNavIndex: 0,
      navItems: [
        {
          label: 'Lukija',
          to: '/lukija',
          color: 'teal',
          icon: 'camera',
        },
        {
          label: 'Varasto',
          to: '/varasto',
          color: 'teal',
          icon: 'business',
        },
        {
          label: 'Tapahtumat',
          to: '/tapahtumat',
          color: 'teal',
          icon: 'history',
        },
        {
          label: 'Käyttäjä',
          to: '/kayttaja',
          color: 'teal',
          icon: 'face',
        },
      ],
    }),

    mounted() {
      const navIndex = this.navItems.findIndex(i => i.to === this.$route.path);

      if (navIndex > -1) this.currentNavIndex = navIndex;
    },
  };
</script>
