<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
  <div>
    <v-layout
      align-center
    >
      <v-text-field
        v-model="search"
        append-icon="search"
        label="Etsi artikkeleita..."
        single-line
        hide-details
        class="mb-4"
      />

      <v-layout
        justify-end
      >
        <div>
          <v-checkbox
            v-if="showInventoryActions"
            v-model="onlySelectedArticles"
            class="right"
          >
            <template v-slot:label>
              <span
                class="caption"
              >
                Näytä vain valitut
              </span>
            </template>
          </v-checkbox>
        </div>
      </v-layout>
    </v-layout>

    <v-data-table
      :loading="$wait.is('loading articles')"
      :headers="headers"
      :items="__articles__"
      :pagination.sync="pagination"
      :search="search"
      no-data-text="Ei artikkeleita"
      class="elevation-2"
    >
      <template
        v-slot:items="props"
      >
        <td
          v-if="renderHeader('id')"
        >
          {{ props.item.id }}
        </td>
        <td
          v-if="renderHeader('name')"
        >
          {{ props.item.name }}
        </td>
        <td
          v-if="renderHeader('gtin')"
        >
          {{ props.item.gtin }}
        </td>
        <td
          v-if="renderHeader('pid')"
        >
          {{ props.item.pid }}
        </td>
        <td
          v-if="renderHeader('unit')"
        >
          {{ props.item.unit }}
        </td>
        <td
          v-if="showInventoryActions"
          class="text-xs-right"
        >
          {{ inventoryCount(props.item) }}
        </td>
        <td
          v-if="showInventoryActions"
          class="text-xs-right"
        >
          <v-btn
            small
            flat
            icon
            color="info"
            class="ma-0"
            @click="editInventoryCount(props.item)"
          >
            <v-icon
              small
            >
              edit
            </v-icon>
          </v-btn>
        </td>
        <td
          v-if="showArticleActions"
          class="text-xs-right"
        >
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

        <td
          v-if="showRowSelection"
          class="text-xs-right"
        >
          <v-btn
            v-if="selectedArticle === props.item"
            flat
            color="error"
            class="ma-0"
            @click="selectRow(props.item)"
          >
            <v-icon>
              cancel
            </v-icon>
          </v-btn>

          <v-btn
            v-else
            flat
            color="info"
            class="ma-0"
            @click="selectRow(props.item)"
          >
            Valitse
          </v-btn>
        </td>
      </template>

      <template v-slot:no-results>
        Haulla ei löytynyt artikkeleita
      </template>
    </v-data-table>
  </div>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex';
  import { mapWaitingActions } from 'vue-wait';

  export default {
    props: {
      showInventoryActions: {
        type: Boolean,
        default: false,
      },

      showSave: {
        type: Boolean,
        default: false,
      },

      showRestore: {
        type: Boolean,
        default: false,
      },

      showArticleActions: {
        type: Boolean,
        default: false,
      },

      showRowSelection: {
        type: Boolean,
        default: false,
      },

      tableHeaders: {
        type: Array,
        default: () => ([
          {
            text: 'ID',
            value: 'id',
          },
          {
            text: 'Nimi',
            value: 'name',
          },
          {
            text: 'GTIN',
            value: 'gtin',
          },
          {
            text: 'Tuotenumero',
            value: 'pid',
          },
          {
            text: 'Tyyppi',
            value: 'unit',
          },
        ]),
      },
    },

    data: () => ({
      search: '',
      onlySelectedArticles: false,
      pagination: {
        sortBy: 'id',
        descending: true,
        rowsPerPage: 10,
      },
      selectedArticle: null,
    }),

    computed: {
      ...mapGetters({
        articles: 'articles/articles',
        inventoryArticleById: 'admin/inventoryArticles/inventoryArticleById',
      }),

      headers() {
        const headers = this.tableHeaders;

        if (this.showInventoryActions) {
          headers.push({
            text: 'Määrä',
            align: 'right',
            sortable: false,
          });

          headers.push({
            text: 'Muokkaa',
            align: 'right',
            sortable: false,
          });
        }

        if (this.showArticleActions) {
          headers.push({
            text: 'Toiminnot',
            align: 'right',
            sortable: false,
          });
        }

        if (this.showRowSelection) {
          headers.push({
            text: 'Rivivalinta',
            align: 'right',
            sortable: false,
          });
        }

        return headers;
      },

      renderHeader() {
        return (header) => {
          return this.headers.some(h => h.value === header);
        };
      },

      __articles__() {
        if (this.onlySelectedArticles) {
          const selectedArticles = this.articles.reduce((acc, article) => {
            const ia = this.inventoryArticleById(article.id);

            if (ia) {
              acc.push(article);
            }

            return acc;
          }, []);

          return selectedArticles;
        }

        return this.articles;
      },

      inventoryCount() {
        return ({ id }) => {
          const ia = this.inventoryArticleById(id);

          if (!ia) return '—';

          return `${ia.count} kpl`;
        };
      },
    },

    async mounted() {
      const promises = [];

      promises.push(this.loadArticles());

      if (this.showInventoryActions) {
        promises.push(this.loadInventoryArticles());
      }

      await Promise.all(promises);
    },

    methods: {
      ...mapActions({
        openDialog: 'dialog/openDialog',
      }),

      ...mapWaitingActions('articles', {
        loadArticles: 'loading articles',
      }),

      ...mapWaitingActions('admin/inventoryArticles', {
        loadInventoryArticles: 'loading inventory articles',
      }),

      editArticle(article = null) {
        this.openDialog({
          dialogComponent: 'edit-article',
          dialogProps: {
            article,
          },
        });
      },

      editInventoryCount(article) {
        this.openDialog({
          dialogComponent: 'edit-inventory-count',
          dialogProps: {
            article,
          },
        });
      },

      selectRow(article) {
        if (this.selectedArticle === article) {
          this.selectedArticle = null;
        } else {
          this.selectedArticle = article;
        }

        this.$emit('on-article-change', this.selectedArticle);
      },
    },
  };
</script>
