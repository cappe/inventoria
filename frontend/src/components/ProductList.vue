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
      >
        <template slot="header">
          <v-layout
            align-center
          >
            <v-icon
              v-if="article.saldo === article.saldoTotal"
              color="teal"
            >
              check
            </v-icon>

            <v-icon
              v-if="article.saldo > 0 && article.saldo < article.saldoTotal"
              color="orange"
            >
              warning
            </v-icon>

            <v-icon
              v-if="article.saldo <= 0"
              color="error"
            >
              error
            </v-icon>

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
                Tuotesaldo {{ article.saldo }} / {{ article.saldoTotal }}
              </div>
            </div>
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
