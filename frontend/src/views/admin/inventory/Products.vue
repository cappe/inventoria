<template>
  <v-container
    fluid
  >
    <h1>
      Tuotteet
    </h1>

    <loader-circular
      v-if="$wait.any"
      column
    />

    <product-list
      v-show="!$wait.any"
    />
  </v-container>
</template>

<script>
  export default {
    components: {
      ProductList: () => import('../../../components/ProductList'),
    },
  };
</script>
