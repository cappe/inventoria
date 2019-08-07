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
        class="mb-4 mr-5"
      />

      <v-checkbox
        v-if="enableRowSelection"
        v-model="onlySelectedArticles"
      >
        <template v-slot:label>
          <span
            class="caption"
          >
            Näytä vain valitut
          </span>
        </template>
      </v-checkbox>

      <v-spacer />

      <v-btn
        v-if="showRestore"
        :disabled="$wait.is('updating selected articles')"
        flat
        color="error"
        @click="restore"
      >
        Palauta
      </v-btn>

      <v-btn
        v-if="showSave"
        :disabled="$wait.is('updating selected articles')"
        :loading="$wait.is('updating selected articles')"
        :dark="!$wait.is('updating selected articles')"
        color="teal"
        class="mr-0"
        @click="save"
      >
        Tallenna
      </v-btn>
    </v-layout>

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
        <td
          v-if="showActions"
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
      enableRowSelection: {
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

      showActions: {
        type: Boolean,
        default: false,
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
    }),

    computed: {
      ...mapGetters({
        articles: 'articles/articles',
        selectedArticles: 'articles/selectedArticles',
      }),

      headers() {
        const headers = [
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
            text: 'Tuotenumero',
            value: 'pid',
          },
          {
            text: 'Tyyppi',
            value: 'unit',
          },
        ];

        if (this.showActions) {
          headers.push({
            text: 'Toiminnot',
            align: 'right',
            sortable: false,
          });
        }

        return headers;
      },

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
        updateSelectedArticles: 'updating selected articles',
        resetSelectedArticles: 'resetting selected articles',
      }),

      restore() {
        this.resetSelectedArticles();
      },

      save() {
        this.updateSelectedArticles();
      },

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
