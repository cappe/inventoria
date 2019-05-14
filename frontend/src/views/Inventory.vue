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
            {{ product.label }}
          </div>
        </template>
        <v-card>
          <v-card-text>
            <p>
              Kenttä 1
            </p>
            <p>
              Kenttä 2
            </p>
            <p>
              Kenttä 3
            </p>
          </v-card-text>
        </v-card>
      </v-expansion-panel-content>
    </v-expansion-panel>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex';
import { mapWaitingActions } from 'vue-wait';

export default {
  computed: {
    ...mapGetters({
      products: 'inventory/products',
    }),
  },

  async mounted() {
    this.loadProducts();
  },

  methods: {
    ...mapWaitingActions('inventory', {
      loadProducts: 'loading products',
    }),
  },
};
</script>
