<template>
  <v-app>
    <v-content>
      <loader-circular
        v-if="$wait.any"
        fill-height
        column
        justify-center
        align-center
      />

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
    <base-dialog />

  </v-app>
</template>

<script>
  import Snackbar from '@/components/Snackbar';
  import BaseDialog from '@/components/dialogs/BaseDialog';

  export default {
    components: {
      Snackbar,
      BaseDialog,
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
