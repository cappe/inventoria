<template>
  <v-container>
    <h1>
      Käyttäjä
    </h1>

    <v-btn
      @click="onLogout"
    >
      Kirjaudu ulos
    </v-btn>
  </v-container>
</template>

<script>
  import { mapActions } from 'vuex';

  export default {
    methods: {
      ...mapActions({
        logout: 'currentUser/logout',
      }),

      async onLogout() {
        await this.logout();

        this.$router.replace('/');
      },
    },
  };
</script>
