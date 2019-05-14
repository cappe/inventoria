<template>
  <v-container>
    <h1>
      CurrentUser
    </h1>

    <v-btn
      @click="logout"
    >
      Kirjaudu ulos
    </v-btn>
  </v-container>
</template>

<script>
export default {
  methods: {
    logout() {
      this.$router.replace('/');
    },
  },
};
</script>
