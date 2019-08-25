<template>
  <v-container>
    <h1
      class="text-xs-center"
    >
      Kirjaudu Inventoriaan
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
            ref="loginInput"
            v-model="user.email"
            label="Sähköposti"
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
            :loading="$wait.is('logging user in')"
            :disabled="$wait.is('logging user in')"
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
  import { mapWaitingActions } from 'vue-wait';

export default {
  data: () => ({
    user: {
      email: '',
      password: '',
    },
  }),

  mounted() {
    this.$nextTick(() => {
      this.$refs.loginInput.focus();
    });
  },

  methods: {
    ...mapWaitingActions('currentUser', {
      login: 'logging user in',
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

      const {
        isAdmin,
        isSuperadmin,
      } = this.$currentUser;

      let to = null;

      if (isAdmin) {
        to = '/admin/varastot';
      } else if (isSuperadmin) {
        to = '/superadmin/kayttajat';
      } else {
        to = '/lukija';
      }

      if (redirect) {
        to = redirect;
      }

      this.$router.push(to);
    },
  },
};
</script>
