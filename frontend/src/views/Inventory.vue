<template>
  <v-container>
    <h1>
      Varasto
    </h1>

    <product-list />
  </v-container>
</template>

<script>
  export default {
    components: {
      ProductList: () => import('../components/ProductList'),
    },
  };
</script>
