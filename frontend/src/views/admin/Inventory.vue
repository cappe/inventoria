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
      ProductList: () => import('../../components/ProductList'),
    },

    computed: {
      ...mapGetters({
        inventory: 'admin/inventories/inventory',
      }),
    },

    mounted() {
      this.loadInventory({ id: this.$route.params.id });
    },

    methods: {
      ...mapWaitingActions('admin/inventories', {
        loadInventory: 'loading inventory',
      }),
    },
  };
</script>
