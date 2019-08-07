<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
  <v-container
    fluid
  >
    <h1>
      Artikkelit

      <v-btn
        flat
        icon
        small
        color="teal"
        @click="editArticle"
      >
        <v-icon>
          add
        </v-icon>
      </v-btn>
    </h1>

    <v-data-table
      :loading="$wait.is('loading articles')"
      :headers="headers"
      :items="articles"
      :pagination.sync="pagination"
      no-data-text="Ei artikkeleita"
      class="elevation-2"
    >
      <template
        v-slot:items="props"
      >
        <td>{{ props.item.id }}</td>
        <td>{{ props.item.name }}</td>
        <td>{{ props.item.gtin13 }}</td>
        <td>{{ props.item.gtin14 }}</td>
        <td>{{ props.item.pid }}</td>
        <td>{{ props.item.unit }}</td>
        <td class="text-xs-right">
          <v-btn
            flat
            icon
            color="primary"
            class="ma-0"
            @click="editArticle(props.item)"
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
          text: 'Nimi',
          value: 'name',
        },
        {
          text: 'GTIN13',
          value: 'gtin13',
        },
        {
          text: 'GTIN14',
          value: 'gtin14',
        },
        {
          text: 'PID',
          value: 'pid',
        },
        {
          text: 'Tyyppi',
          value: 'unit',
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
        articles: 'articles/articles',
      }),
    },

    async mounted() {
      await this.loadArticles();
    },

    methods: {
      ...mapActions({
        openDialog: 'dialog/openDialog',
      }),

      ...mapWaitingActions('articles', {
        loadArticles: 'loading articles',
      }),

      editArticle(article = null) {
        this.openDialog({
          dialogComponent: 'edit-article',
          dialogProps: {
            article,
          },
        });
      },
    },
  };
</script>
