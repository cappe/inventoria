<template>
  <v-container>
    <h1
      class="text-xs-center"
    >
      Kirjaudu
    </h1>

    <v-form
      @submit.prevent="submit"
    >
      <v-card
        max-width="500px"
        style="margin: 0 auto;"
      >
        <v-card-text>
          <v-text-field
            v-model="user.email"
            label="Sähköpostiosoite"
            type="email"
          />

          <v-text-field
            v-model="user.password"
            label="salasana"
            type="password"
          />
        </v-card-text>

        <v-card-actions>
          <v-btn
            block
            color="success"
            type="submit"
          >
            Kirjaudu
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-form>
  </v-container>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  data: () => ({
    user: {
      email: '',
      password: '',
    },
  }),

  methods: {
    ...mapActions({
      login: 'currentUser/login',
    }),

    async submit() {
      const success = await this.login({
        session: {
          email: this.user.email,
          password: this.user.password,
        },
      });

      if (!success) return;

      const {
        redirect,
      } = this.$route.query;

      let to = '/lukija';

      if (redirect) {
        to = redirect;
      }

      this.$router.push(to);
    },
  },
};
</script>
