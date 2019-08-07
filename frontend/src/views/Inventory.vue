<template>
  <v-container>
    <h1>
      Varasto {{ inventory.name }}
    </h1>

    <product-list />
  </v-container>
</template>

<script>
  import { mapGetters } from 'vuex';
  import { mapWaitingActions } from 'vue-wait';

  export default {
    components: {
      ProductList: () => import('../components/ProductList'),
    },

    computed: {
      ...mapGetters({
        inventory: 'inventory/inventory',
      }),
    },

    mounted() {
      this.loadInventory();
    },

    methods: {
      ...mapWaitingActions('inventory', {
        loadInventory: 'loading inventory',
      }),
    },
  };
</script>
