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

    <v-tabs
      v-model="activeTab"
      exact
      color="transparent"
    >
      <v-tab
        v-for="(tab, i) of tabs"
        :key="i"
        :to="tab.route"
        exact
      >
        {{ tab.name }}
      </v-tab>
    </v-tabs>

    <router-view />
  </v-container>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex';
  import { mapWaitingActions } from 'vue-wait';

  export default {
    data: vm => ({
      activeTab: vm.$route.path,
      tabs: [
        {
          name: 'Tuotteet',
          route: {
            name: 'adminInventoryProducts',
          },
        },
        {
          name: 'Tapahtumat',
          route: {
            name: 'adminInventoryEventLogs',
          },
        },
        {
          name: 'Käyttäjät',
          route: {
            name: 'adminInventoryUsers',
          },
        },
      ],
    }),

    computed: {
      ...mapGetters({
        inventory: 'admin/inventories/inventory',
      }),
    },

    mounted() {
      this.loadInventory();
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
