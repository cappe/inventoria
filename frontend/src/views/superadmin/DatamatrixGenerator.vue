<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
  <v-container
    fluid
    grid-list-xl
  >
    <h1>
      Datamatriisi-generaattori
    </h1>

    <v-layout
      row
      wrap
    >
      <v-flex
        xs12
        lg5
      >
        <article-list
          :table-headers="tableHeaders"
          show-row-selection
          @on-article-change="onArticleChange"
        />
      </v-flex>

      <v-flex
        xs12
        lg5
      >
        <h2>
          Valittu artikkeli
        </h2>

        <template
          v-if="selectedArticle"
        >
          <table
            class="result-table"
          >
            <tr
              v-for="(item, i) in items"
              :key="i"
            >
              <th
                class="text-xs-left pa-2"
                style="width: 50%"
              >
                {{ item.label }}
              </th>

              <td
                class="pa-2"
                style="width: 50%"
              >
                {{ item.value }}
              </td>
            </tr>
          </table>

          <v-menu
            v-model="manufactureDateMenu"
            :close-on-content-click="false"
            :nudge-right="40"
            lazy
            transition="scale-transition"
            offset-y
            full-width
            min-width="290px"
          >
            <template
              v-slot:activator="{ on }"
            >
              <v-text-field
                :value="formattedManufactureDate"
                label="Valmistettu"
                readonly
                v-on="on"
                style="max-width: 300px;"
              />
            </template>

            <v-date-picker
              landscape
              v-model="manufactureDate"
              @input="manufactureDateMenu = false"
            />
          </v-menu>

          <v-menu
            v-model="expiryDateMenu"
            :close-on-content-click="false"
            :nudge-right="40"
            lazy
            transition="scale-transition"
            offset-y
            full-width
            min-width="290px"
          >
            <template
              v-slot:activator="{ on }"
            >
              <v-text-field
                :value="formattedExpiryDate"
                label="Viimeinen käyttöpäivä"
                readonly
                v-on="on"
                style="max-width: 300px;"
              />
            </template>

            <v-date-picker
              v-model="expiryDate"
              landscape
              @input="expiryDateMenu = false"
            />
          </v-menu>

          <v-text-field
            v-model="lot"
            label="LOT"
            style="max-width: 300px;"
          />

          <v-subheader
            class="pl-0"
          >
            Datamatriisi
          </v-subheader>

          <p
            class="mb-0"
          >
            {{ rawDatamatrixCode }}
          </p>

          <canvas
            id="datamatrix-canvas"
            class="mt-4"
          />
        </template>

        <p
          v-else
          class="font-italic mb-0"
        >
          Valitse artikkeli listalta
        </p>
      </v-flex>
    </v-layout>

  </v-container>
</template>

<script>
  import bwipjs from 'bwip-js';

  export default {
    components: {
      ArticleList: () => import('../../components/ArticleList.vue'),
    },

    computed: {
      items() {
        if (!this.selectedArticle) return [];

        return [
          {
            label: 'Tuotteen nimi',
            value: this.selectedArticle.name,
          },
          {
            label: 'GTIN',
            value: this.selectedArticle.gtin,
          },
        ];
      },

      formattedManufactureDate() {
        return this.$dayjs(this.manufactureDate).format('DD.MM.YYYY');
      },

      formattedExpiryDate() {
        return this.$dayjs(this.expiryDate).format('DD.MM.YYYY');
      },

      rawDatamatrixCode() {
        const gtin = `(01)${this.selectedArticle.gtin}`;
        const manufactureDate = `11${this.$dayjs(this.manufactureDate).format('YYMMDD')}`;
        const expiryDate = `17${this.$dayjs(this.expiryDate).format('YYMMDD')}`;
        const lot = `10${this.lot}`;

        return `${gtin}${manufactureDate}${expiryDate}${lot}`;
      },
    },

    watch: {
      expiryDate(newVal) {
        if (!newVal) return;

        this.generateDatamatrix();
      },

      manufactureDate(newVal) {
        if (!newVal) return;

        this.generateDatamatrix();
      },

      lot(newVal) {
        if (!newVal) return;

        this.generateDatamatrix();
      },

      selectedArticle(newVal) {
        if (!newVal) return;

        this.randomizeLotNumber();
        this.generateDatamatrix();
      },
    },

    data: vm => ({
      manufactureDateMenu: false,
      expiryDateMenu: false,
      selectedArticle: null,
      manufactureDate: vm.$dayjs().subtract(2, 'year').format('YYYY-MM-DD'),
      expiryDate: vm.$dayjs().add(3, 'year').format('YYYY-MM-DD'),
      lot: null,
      tableHeaders: [
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
      ],
    }),

    methods: {
      onArticleChange(article) {
        this.selectedArticle = article;
      },

      randomizeLotNumber() {
        const min = 111111;
        const max = 999999;

        this.lot = Math.floor(Math.random() * (max - min + 1)) + min;
      },

      generateDatamatrix() {
        this.$nextTick(() => {
          bwipjs('datamatrix-canvas', {
            bcid: 'gs1datamatrix',
            text: this.rawDatamatrixCode,
          }, (err) => {
            if (err) {
              alert(err);
            }
          });
        });
      },
    },
  };
</script>

<style lang="scss" scoped>
  .result-table {
    width: 100%;

    tr:nth-child(odd){
      background: rgba(0, 0, 0, 0.1);
    }

    tr:nth-child(even){
      background: rgba(0, 0, 0, 0.025);
    }
  }
</style>
