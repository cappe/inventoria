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

    <article-list
      show-actions
    />
  </v-container>
</template>

<script>
  import { mapActions } from 'vuex';

  export default {
    components: {
      ArticleList: () => import('../../components/ArticleList'),
    },

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
