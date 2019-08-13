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
    </v-subheader>

    <article-list
      show-inventory-actions
      show-restore
      show-save
    />
  </v-container>
</template>

<script>
  export default {
    components: {
      ArticleList: () => import('../../../components/ArticleList'),
    },
  };
</script>
