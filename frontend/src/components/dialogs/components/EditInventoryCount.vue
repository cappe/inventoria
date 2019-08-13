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
      </v-card-title>

      <v-card-text>
        <v-text-field
          ref="inventoryArticleCountRef"
          v-model="inventoryArticle.count"
          :rules="[
            v => !!v || 'Tuotteen lukumäärä on pakollinen',
            v => v && v <= 255 || 'Tuotteen lukumäärä saa olla enintään 255',
            v => v && v >= 0 || 'Tuotteen lukumäärä on oltava vähintään 0',
          ]"
          label="Tuotteen lukumäärä"
          required
          type="number"
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
          :loading="$wait.is('saving inventory article')"
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
      inventoryArticle: {},
      formValidation: false,
    }),

    computed: {
      ...mapGetters({
        dialogProps: 'dialog/dialogProps',
        inventoryArticleById: 'admin/inventoryArticles/inventoryArticleById',
      }),

      isNew() {
        return !Object.keys(this.inventoryArticle).includes('id');
      },

      title() {
        return 'Muokkaa tuotteen lukumäärää';
      },

      disableActions() {
        return this.$wait.is([
          'saving inventory article',
        ]);
      },

      article() {
        return this.dialogProps.article;
      },
    },

    created() {
      const ia = this.inventoryArticleById(this.article.id);

      if (ia) {
        this.inventoryArticle = cloneDeep(ia);
      }

      this.$nextTick(() => {
        this.$refs.inventoryArticleCountRef.focus();
      });
    },

    methods: {
      ...mapActions({
        closeDialog: 'dialog/closeDialog',
      }),

      ...mapWaitingActions('admin/inventoryArticles', {
        createInventoryArticle: 'saving inventory article',
        updateInventoryArticle: 'saving inventory article',
        destroyInventoryArticle: 'saving inventory article',
      }),

      cancel() {
        this.closeDialog();
      },

      async submit() {
        if (!this.formValidation) return;

        const params = {
          id: this.inventoryArticle.id,
          payload: {
            inventoryArticle: {
              articleId: this.article.id,
              count: this.inventoryArticle.count,
            },
          },
        };

        if (this.isNew) {
          await this.createInventoryArticle(params);
        } else if (this.inventoryArticle.count > 0) {
          await this.updateInventoryArticle(params);
        } else {
          await this.destroyInventoryArticle({
            id: this.inventoryArticle.id,
          });
        }

        this.closeDialog();
      },
    },
  };
</script>
