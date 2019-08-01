<template>
  <v-app>
    <v-content>
      <router-view />
    </v-content>

    <snackbar />
  </v-app>
</template>

<script>
  import Snackbar from '@/components/Snackbar';

  export default {
    components: {
      Snackbar,
    },
  };
</script>
