<template>
  <v-container>
    <h1>
      Varasto
    </h1>

    <v-expansion-panel>
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
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex';
import { mapWaitingActions } from 'vue-wait';
import ProductDetails from '../components/ProductDetails';

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
