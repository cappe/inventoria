<template>
  <v-container
    fluid
  >
    <h1>
      Artikkelit

      <v-btn
        flat
        icon
        small
        color="teal"
        @click="editArticle"
      >
        <v-icon>
          add
        </v-icon>
      </v-btn>
    </h1>

    <v-layout>
      <v-text-field
        v-model="search"
        append-icon="search"
        label="Etsi artikkeleita..."
        single-line
        hide-details
        class="mb-4 mr-5"
      />

      <v-spacer />
    </v-layout>

    <article-list
      :search="search"
    />
  </v-container>
</template>

<script>
  import { mapActions } from 'vuex';

  export default {
    components: {
      ArticleList: () => import('../../components/ArticleList'),
    },

    data: () => ({
      search: '',
    }),

    methods: {
      ...mapActions({
        openDialog: 'dialog/openDialog',
      }),

      editArticle(article = null) {
        this.openDialog({
          dialogComponent: 'edit-article',
          dialogProps: {
            article,
          },
        });
      },
    },
  };
</script>
