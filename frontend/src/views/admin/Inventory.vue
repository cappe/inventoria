<template>
  <v-container>
    <h1>
      Varasto {{ inventory.name }}

      <v-btn
        flat
        icon
        small
        color="teal"
        @click="editInventory"
      >
        <v-icon
          small
        >
          edit
        </v-icon>
      </v-btn>
    </h1>

    <product-list />
  </v-container>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex';
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
      ...mapActions({
        openDialog: 'dialog/openDialog',
      }),

      ...mapWaitingActions('admin/inventories', {
        loadInventory: 'loading inventory',
      }),

      editInventory() {
        this.openDialog({
          dialogComponent: 'edit-inventory',
          dialogProps: {
            inventory: this.inventory,
          },
        });
      },
    },
  };
</script>
