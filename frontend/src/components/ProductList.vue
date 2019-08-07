<template>
  <div>
    <p
      v-if="products.length <= 0"
      class="font-italic"
    >
      Ei tuotteita varastossa
    </p>

    <v-expansion-panel
      v-else
    >
      <v-expansion-panel-content
        v-for="(product, i) in products"
        :key="i"
      >
        <template slot="header">
          <div>
            {{ product.article.name }}
          </div>
        </template>
        <v-card>
          <v-card-text
            class="pl-4"
          >
            <product-details
              :product="product"
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
        products: 'inventory/products',
      }),
    },

    async mounted() {
      this.loadProducts({
        include: ['article'],
      });
    },

    methods: {
      ...mapWaitingActions('inventory', {
        loadProducts: 'loading products',
      }),
    },
  };
</script>
