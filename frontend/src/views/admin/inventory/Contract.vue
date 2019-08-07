<template>
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
    </v-subheader>

    <article-list
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
