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
      :loading="$wait.is('loading users')"
      :headers="headers"
      :items="users"
      :pagination.sync="pagination"
      no-data-text="Ei käyttäjiä"
      class="elevation-2"
    >
      <template
        v-slot:items="props"
      >
        <td>{{ props.item.id }}</td>
        <td>{{ props.item.email }}</td>
        <td class="text-xs-right">
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
          text: 'Toiminnot',
          align: 'right',
          sortable: false,
        },
      ],
    }),

    computed: {
      ...mapGetters({
        users: 'admin/users/users',
      }),
    },

    async mounted() {
      await this.loadUsers();
    },

    methods: {
      ...mapActions({
        openDialog: 'dialog/openDialog',
      }),

      ...mapWaitingActions('admin/users', {
        loadUsers: 'loading users',
      }),

      editUser(user = null) {
        this.openDialog({
          dialogComponent: 'edit-user',
          dialogProps: {
            user,
          },
        });
      },
    },
  };
</script>
