<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
  <v-container>
    <h1>
      Varastot

      <v-btn
        flat
        icon
        small
        color="teal"
        @click="createInventory"
      >
        <v-icon>
          add
        </v-icon>
      </v-btn>
    </h1>

    <v-data-table
      :headers="headers"
      :items="inventories"
      :pagination.sync="pagination"
      no-data-text="Ei asiakkaita"
      class="elevation-2"
      style="max-width: 700px;"
    >
      <template
        v-slot:items="props"
      >
        <td>{{ props.item.id }}</td>
        <td>{{ props.item.name }}</td>
        <td class="text-xs-right">
          <v-btn
            :to="{ name: 'adminInventory', params: { id: props.item.id } }"
            flat
            color="primary"
            class="ma-0"
          >
            Avaa
          </v-btn>
        </td>
      </template>
    </v-data-table>
  </v-container>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex';
  import { mapWaitingActions } from 'vue-wait';

  export default {
    data: () => ({
      pagination: {
        sortBy: 'createdAt',
        descending: true,
        rowsPerPage: 10,
      },
      headers: [
        {
          text: 'ID',
          value: 'id',
        },
        {
          text: 'Nimi',
          value: 'name',
        },
        {
          text: 'Toiminnot',
          align: 'right',
          sortable: false,
        },
      ],
    }),

    computed: {
      ...mapGetters({
        inventories: 'admin/inventories/inventories',
      }),
    },

    mounted() {
      this.loadInventories();
    },

    methods: {
      ...mapActions({
        openDialog: 'dialog/openDialog',
      }),

      ...mapWaitingActions('admin/inventories', {
        loadInventories: 'loading inventories',
      }),

      createInventory() {
        this.openDialog({
          dialogComponent: 'edit-inventory',
          dialogProps: {
            inventory: {},
          },
        });
      },
    },
  };
</script>
