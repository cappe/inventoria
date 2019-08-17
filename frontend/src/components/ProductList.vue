<template>
  <div>
    <p
      v-if="articlesWithProducts.length <= 0"
      class="font-italic"
    >
      Ei tuotteita varastossa
    </p>

    <v-expansion-panel
      v-else
    >
      <v-expansion-panel-content
        v-for="(article, i) in articlesWithProducts"
        :key="i"
        :class="{
          'deep-orange lighten-5': !article.isCommissionProduct,
        }"
      >
        <template slot="header">
          <v-layout
            align-space-between
          >
            <v-layout
              align-center
            >
              <div
                class="text-xs-center"
              >
                <v-icon
                  :color="vIcon(article).color"
                >
                  {{ vIcon(article).icon }}
                </v-icon>

                <span
                  v-if="article.saldo > article.saldoTotal"
                  class="caption d-block"
                >
                  +{{ article.saldo - article.saldoTotal }}
                </span>
              </div>

              <div
                class="ml-4"
              >
                <div
                  class="subheading"
                >
                  {{ article.name }}
                </div>

                <div
                  class="grey--text text--darken-1"
                >
                  Saldo {{ article.saldo }} / {{ article.saldoTotal }}
                </div>
              </div>
            </v-layout>

            <v-layout
              v-if="!article.isCommissionProduct"
              justify-end
              align-center
              class="pr-4"
            >
              Tuotetta ei ole merkitty komissiosopimukseen
            </v-layout>
          </v-layout>
        </template>
        <v-card>
          <v-card-text>
            <product-details
              :products="article.products"
            />
          </v-card-text>
        </v-card>
      </v-expansion-panel-content>
    </v-expansion-panel>
  </div>
</template>

<script>
  import { mapGetters } from 'vuex';
  import { mapWaitingActions } from 'vue-wait';
  import ProductDetails from './ProductDetails';

  export default {
    components: {
      ProductDetails,
    },

    computed: {
      ...mapGetters({
        articlesWithProducts: 'inventory/articlesWithProducts',
      }),

      vIcon() {
        return (article) => {
          const icon = {
            color: '',
            icon: '',
          };

          const {
            saldo,
            saldoTotal,
          } = article;

          if (saldo <= 0) {
            icon.color = 'error';
            icon.icon = 'error';
          } else if (saldo > 0 && saldo < saldoTotal) {
            icon.color = 'orange';
            icon.icon = 'warning';
          } else {
            icon.color = 'teal';
            icon.icon = 'check';
          }

          return icon;
        };
      },
    },

    async mounted() {
      this.loadArticlesWithProducts();
    },

    methods: {
      ...mapWaitingActions('inventory', {
        loadArticlesWithProducts: 'loading articles with products',
      }),
    },
  };
</script>
