<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
  <div>

    <v-data-table
      :headers="headers"
      :items="products"
      :pagination.sync="pagination"
      no-data-text="Ei tuotteita"
      hide-actions
      class="elevation-2 blue"
    >
      <template
        v-slot:items="props"
      >
        <td>{{ $dayjs(props.item.expiryDate).format('DD.MM.YYYY') }}</td>
        <td>{{ $dayjs(props.item.manufactureDate).format('DD.MM.YYYY') }}</td>
        <td>{{ props.item.gtin }}</td>
        <td>{{ props.item.lot }}</td>
      </template>
    </v-data-table>
  </div>
</template>

<script>
  export default {
    props: {
      products: {
        type: Array,
        required: true,
      },
    },

    data: () => ({
      pagination: {
        sortBy: 'expiryDate',
        rowsPerPage: 10,
      },

      headers: [
        {
          text: 'Viimeinen käyttöpäivä',
          value: 'expiryDate',
        },
        {
          text: 'Valmistettu',
          value: 'manufactureDate',
        },
        {
          text: 'GTIN',
          value: 'gtin',
        },
        {
          text: 'LOT',
          value: 'lot',
        },
      ],
    }),

    computed: {

    },
  };
</script>
