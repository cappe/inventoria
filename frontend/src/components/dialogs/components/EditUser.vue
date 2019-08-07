<template>
  <v-card>
    <v-form
      v-model="formValidation"
      @submit.prevent="submit"
    >
      <v-card-title
        class="title"
      >
        {{ title }}

        <v-btn
          v-if="!isNew"
          :disabled="disableActions"
          :loading="$wait.is('destroying user')"
          color="error"
          flat
          @click="destroy"
        >
          {{ destroyButtonText }}
        </v-btn>
      </v-card-title>

      <v-card-text>
        <v-text-field
          ref="userEmailRef"
          v-model="user.email"
          :rules="[
            v => !!v || 'Sähköposti on pakollinen',
            v => v && v.length <= 255 || 'Sähköposti saa olla enintään 255 merkkiä',
          ]"
          label="Sähköposti"
          type="email"
          required
        />
      </v-card-text>

      <v-card-actions>
        <v-spacer />

        <v-btn
          :disabled="disableActions"
          color="error"
          flat
          @click="cancel"
        >
          Peruuta
        </v-btn>

        <v-btn
          :disabled="disableActions"
          :loading="$wait.is('saving user')"
          color="success"
          type="submit"
        >
          Tallenna
        </v-btn>
      </v-card-actions>
    </v-form>
  </v-card>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex';
  import { mapWaitingActions } from 'vue-wait';
  import cloneDeep from 'lodash.clonedeep';

  export default {
    data: () => ({
      user: {},
      formValidation: false,
      confirmingDestroy: false,
    }),

    computed: {
      ...mapGetters({
        dialogProps: 'dialog/dialogProps',
      }),

      destroyButtonText() {
        if (this.confirmingDestroy) {
          return 'Varma?';
        }

        return 'Poista';
      },

      isNew() {
        return !Object.keys(this.user).includes('id');
      },

      title() {
        if (this.isNew) {
          return 'Luo uusi käyttäjä';
        }

        return 'Muokkaa käyttäjää';
      },

      disableActions() {
        return this.$wait.is([
          'saving user',
          'destroying user',
        ]);
      },
    },

    created() {
      this.user = cloneDeep(this.dialogProps.user);

      this.$nextTick(() => {
        this.$refs.userEmailRef.focus();
      });
    },

    methods: {
      ...mapActions({
        closeDialog: 'dialog/closeDialog',
      }),

      ...mapWaitingActions('admin/users', {
        createUser: 'saving user',
        updateUser: 'saving user',
        destroyUser: 'destroying user',
      }),

      cancel() {
        this.closeDialog();
      },

      async submit() {
        const params = {
          id: this.user.id,
          payload: {
            user: {
              email: this.user.email,
            },
          },
        };

        if (this.isNew) {
          await this.createUser(params);
        } else {
          await this.updateUser(params);
        }

        this.closeDialog();
      },

      async destroy() {
        if (!this.confirmingDestroy) {
          this.confirmingDestroy = true;
          return;
        }

        await this.destroyUser({
          id: this.user.id,
        });

        this.closeDialog();
        this.confirmingDestroy = false;
      },
    },
  };
</script>
