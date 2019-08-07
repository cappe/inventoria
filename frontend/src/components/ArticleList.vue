<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
  <v-data-table
    v-model="__selectedArticles__"
    :loading="$wait.is('loading articles')"
    :headers="headers"
    :items="__articles__"
    :pagination.sync="pagination"
    :select-all="enableRowSelection"
    :search="search"
    no-data-text="Ei artikkeleita"
    class="elevation-2"
  >
    <template
      v-slot:items="props"
    >
      <td
        v-if="enableRowSelection"
      >
        <v-checkbox
          v-model="props.selected"
          primary
          hide-details
        />
      </td>
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
</template>

<script>
  import { mapGetters, mapActions } from 'vuex';
  import { mapWaitingActions } from 'vue-wait';

  export default {
    props: {
      enableRowSelection: {
        type: Boolean,
        default: false,
      },

      search: {
        type: String,
        default: '',
      },

      onlySelectedArticles: {
        type: Boolean,
        default: false,
      },
    },

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
        selectedArticles: 'articles/selectedArticles',
      }),

      __articles__() {
        if (this.onlySelectedArticles) {
          return this.selectedArticles;
        }

        return this.articles;
      },

      __selectedArticles__: {
        get() {
          return this.selectedArticles;
        },

        set(newVal) {
          this.setSelectedArticles({
            selectedArticles: newVal,
          });
        },
      },
    },

    async mounted() {
      await this.loadArticles({
        getParams: [
          {
            key: 'belongs_to_inventory',
            value: this.$currentInventoryId,
          },
        ],
      });
    },

    methods: {
      ...mapActions({
        openDialog: 'dialog/openDialog',
        setSelectedArticles: 'articles/setSelectedArticles',
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
