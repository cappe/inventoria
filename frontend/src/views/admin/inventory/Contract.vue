<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
  <v-container
    fluid
  >
    <h1>
      Sopimus
    </h1>

    <v-subheader
      class="px-0"
    >
      Valitse tälle varastolle komissiosopimuksen mukaiset artikkelit.
    </v-subheader>

    <v-layout
      align-center
    >
      <v-text-field
        v-model="search"
        append-icon="search"
        label="Etsi artikkeleita..."
        single-line
        hide-details
        class="mb-4 mr-5"
      />

      <v-checkbox
        v-model="onlySelectedArticles"
      >
        <template v-slot:label>
          <span
            class="caption"
          >
            Näytä vain valitut
          </span>
        </template>
      </v-checkbox>

      <v-spacer />

      <v-btn
        flat
        color="error"
        @click="restore"
      >
        Palauta
      </v-btn>

      <v-btn
        :disabled="$wait.is('updating selected articles')"
        :loading="$wait.is('updating selected articles')"
        :dark="!$wait.is('updating selected articles')"
        color="teal"
        class="mr-0"
        @click="save"
      >
        Tallenna
      </v-btn>
    </v-layout>

    <article-list
      :search="search"
      :only-selected-articles="onlySelectedArticles"
      enable-row-selection
    />
  </v-container>
</template>

<script>
  import { mapWaitingActions } from 'vue-wait';

  export default {
    components: {
      ArticleList: () => import('../../../components/ArticleList'),
    },

    data: () => ({
      search: null,
      onlySelectedArticles: false,
    }),

    methods: {
      ...mapWaitingActions('articles', {
        updateSelectedArticles: 'updating selected articles',
        resetSelectedArticles: 'resetting selected articles',
      }),

      restore() {
        this.resetSelectedArticles();
      },

      save() {
        this.updateSelectedArticles();
      },
    },
  };
</script>
