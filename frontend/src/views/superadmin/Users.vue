<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
  <v-container
    fluid
  >
    <h1>
      Käyttäjät

      <v-btn
        flat
        icon
        small
        color="teal"
        @click="editUser"
      >
        <v-icon>
          add
        </v-icon>
      </v-btn>
    </h1>

    <v-data-table
      :loading="$wait.is('loading admin users')"
      :headers="headers"
      :items="users"
      :pagination.sync="pagination"
      no-data-text="Ei käyttäjiä"
      class="elevation-2"
      style="max-width: 700px;"
    >
      <template
        v-slot:items="props"
      >
        <td>{{ props.item.id }}</td>
        <td>{{ props.item.email }}</td>
        <td>
          <v-icon
            v-if="props.item.receiveOrders"
          >
            check
          </v-icon>
        </td>
        <td
          class="text-xs-right"
        >
          <v-btn
            flat
            icon
            color="primary"
            class="ma-0"
            @click="editUser(props.item)"
          >
            <v-icon
              small
            >
              edit
            </v-icon>
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
        sortBy: 'id',
        descending: true,
        rowsPerPage: 10,
      },

      headers: [
        {
          text: 'ID',
          value: 'id',
        },
        {
          text: 'Sähköposti',
          value: 'email',
        },
        {
          text: 'Vastaanota tilauksia',
          value: 'receiveOrders',
          sortable: false,
        },
        {
          text: 'Toiminnot',
          sortable: false,
          align: 'right',
        },
      ],
    }),

    computed: {
      ...mapGetters({
        users: 'admin/users/users',
      }),
    },

    mounted() {
      this.loadAdmins();
    },

    methods: {
      ...mapActions({
        openDialog: 'dialog/openDialog',
      }),

      ...mapWaitingActions('superadmin/users', {
        loadAdmins: 'loading admin users',
      }),

      editUser(user = null) {
        this.openDialog({
          dialogComponent: 'edit-user',
          dialogProps: {
            user,
            superAdmin: true,
          },
        });
      },
    },
  };
</script>
