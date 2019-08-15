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
          :loading="$wait.is('destroying article')"
          color="error"
          flat
          @click="destroy"
        >
          {{ destroyButtonText }}
        </v-btn>
      </v-card-title>

      <v-card-text>
        <v-text-field
          ref="nameRef"
          v-model="article.name"
          :rules="[
            v => !!v || 'Nimi on pakollinen',
            v => v && v.length <= 255 || 'Nimi saa olla enintään 255 merkkiä',
          ]"
          label="Nimi"
          required
        />

        <v-text-field
          v-model="article.gtin"
          :rules="[
            v => !!v || 'GTIN on pakollinen',
            v => v && v.length <= 255 || 'GTIN saa olla enintään 255 merkkiä',
          ]"
          label="GTIN"
          required
        />

        <v-text-field
          v-model="article.pid"
          :rules="[
            v => !!v || 'Tuotenumero on pakollinen',
            v => v && v.length <= 255 || 'Tuotenumero saa olla enintään 255 merkkiä',
          ]"
          label="Tuotenumero"
          required
        />

        <v-text-field
          v-model="article.unit"
          :rules="[
            v => !!v || 'Tyyppi on pakollinen',
            v => v && v.length <= 255 || 'Tyyppi saa olla enintään 255 merkkiä',
          ]"
          label="Tyyppi"
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
          :loading="$wait.is('saving article')"
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
      article: {},
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
        return !Object.keys(this.article).includes('id');
      },

      title() {
        if (this.isNew) {
          return 'Luo uusi artikkeli';
        }

        return 'Muokkaa artikkelia';
      },

      disableActions() {
        return this.$wait.is([
          'saving article',
          'destroying article',
        ]);
      },
    },

    created() {
      this.article = cloneDeep(this.dialogProps.article);

      this.$nextTick(() => {
        this.$refs.nameRef.focus();
      });
    },

    methods: {
      ...mapActions({
        closeDialog: 'dialog/closeDialog',
      }),

      ...mapWaitingActions('articles', {
        createArticle: 'saving article',
        updateArticle: 'saving article',
        destroyArticle: 'destroying article',
      }),

      cancel() {
        this.closeDialog();
      },

      async submit() {
        const params = {
          id: this.article.id,
          payload: {
            article: {
              name: this.article.name,
              gtin: this.article.gtin,
              pid: this.article.pid,
              unit: this.article.unit,
            },
          },
        };

        if (this.isNew) {
          await this.createArticle(params);
        } else {
          await this.updateArticle(params);
        }

        this.closeDialog();
      },

      async destroy() {
        if (!this.confirmingDestroy) {
          this.confirmingDestroy = true;
          return;
        }

        await this.destroyArticle({
          id: this.article.id,
        });

        this.closeDialog();
        this.confirmingDestroy = false;
      },
    },
  };
</script>
