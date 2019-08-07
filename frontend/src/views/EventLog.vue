<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
  <v-container
    fluid
  >
    <h1>Tapahtumat</h1>

    <v-data-table
      :loading="$wait.is('loading event logs')"
      :headers="headers"
      :items="eventLogs"
      :pagination.sync="pagination"
      no-data-text="Ei tapahtumia"
      class="elevation-2"
    >
      <template
        v-slot:items="props"
      >
        <td>{{ props.item.id }}</td>
        <td>{{ $dayjs(props.item.createdAt).format('DD.MM.YYYY HH:mm:ss') }}</td>
        <td>{{ props.item.article.name }}</td>
        <td>{{ props.item.product.gtin }}</td>
        <td>{{ props.item.product.lot }}</td>
        <td>{{ $dayjs(props.item.product.manufactureDate).format('DD.MM.YYYY') }}</td>
        <td>{{ $dayjs(props.item.product.expiryDate).format('DD.MM.YYYY') }}</td>
        <td>{{ props.item.user.email }}</td>
        <td>{{ props.item.comment }}</td>
      </template>
    </v-data-table>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex';
import { mapWaitingActions } from 'vue-wait';

export default {
  data: () => ({
    pagination: {
      sortBy: 'createdAt',
      descending: true,
      rowsPerPage: 10,
    },
  }),

  computed: {
    ...mapGetters({
      eventLogs: 'eventLogs/eventLogs',
    }),

    headers() {
      return [
        {
          text: 'ID',
          value: 'id',
        },
        {
          text: 'Aikaleima',
          value: 'createdAt',
        },
        {
          text: 'Tuote',
          value: 'article.name',
        },
        {
          text: 'GTIN',
          value: 'product.gtin',
        },
        {
          text: 'LOT',
          value: 'product.lot',
        },
        {
          text: 'Valmistettu',
          value: 'product.manufactureDate',
        },
        {
          text: 'Viimeinen käyttöpäivä',
          value: 'product.expiryDate',
        },
        {
          text: 'Käyttäjä',
          value: 'user.email',
        },
        {
          text: 'Kommentti',
          value: 'comment',
        },
      ];
    },
  },

  mounted() {
    this.loadEventLogs();
  },

  methods: {
    ...mapWaitingActions('eventLogs', {
      loadEventLogs: 'loading event logs',
    }),
  },
};
</script>
