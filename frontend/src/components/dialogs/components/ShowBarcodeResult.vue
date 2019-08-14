<template>
  <v-card>
    <v-form
      v-model="formValidation"
      @submit.prevent="submit"
    >
      <v-card-title
        class="title"
      >
        {{ title }}
      </v-card-title>

      <v-card-text>
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
      </v-card-text>

      <v-card-actions>
        <v-spacer />

        <v-btn
          :disabled="processing"
          color="error"
          flat
          @click="cancel"
        >
          Peruuta
        </v-btn>

        <v-btn
          :disabled="processing"
          :loading="processing"
          color="teal"
          :dark="!processing"
          type="submit"
        >
          {{ actionButtonText }}
        </v-btn>
      </v-card-actions>
    </v-form>
  </v-card>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex';

  export default {
    data: () => ({
      formValidation: false,
      processing: false,
    }),

    computed: {
      ...mapGetters({
        dialogProps: 'dialog/dialogProps',
      }),

      title() {
        if (this.isPlacingProduct) {
          return 'Lisäätkö tuotteen varastoon?';
        }

        return 'Käytätkö tuotteen?';
      },

      actionButtonText() {
        if (this.isPlacingProduct) {
          return 'Lisää varastoon';
        }

        return 'Käytä tuote';
      },

      isPlacingProduct() {
        return this.dialogProps.isPlacingProduct;
      },

      isUsingProduct() {
        return this.dialogProps.isUsingProduct;
      },

      product() {
        return this.dialogProps.product;
      },

      article() {
        return this.dialogProps.article;
      },

      items() {
        return [
          {
            label: 'Tuotteen nimi',
            value: this.article.name,
          },
          {
            label: 'Valmistettu',
            value: this.$dayjs(this.product.manufactureDate).format('DD.MM.YYYY'),
          },
          {
            label: 'Viimeinen käyttöpäivä',
            value: this.$dayjs(this.product.expiryDate).format('DD.MM.YYYY'),
          },
          {
            label: 'LOT',
            value: this.product.lot,
          },
          {
            label: 'GTIN',
            value: this.product.gtin,
          },
          {
            label: 'Tuotenumero',
            value: this.article.pid,
          },
          {
            label: 'Tyyppi',
            value: this.article.unit,
          },
        ];
      },
    },

    methods: {
      ...mapActions({
        closeDialog: 'dialog/closeDialog',
        placeProduct: 'inventory/placeProduct',
        useProduct: 'inventory/useProduct',
      }),

      cancel() {
        this.closeDialog();
      },

      async submit() {
        this.processing = true;

        const params = {
          payload: {
            product: this.product,
          },
        };

        if (this.isPlacingProduct) {
          await this.placeProduct(params);
        } else if (this.isUsingProduct) {
          await this.useProduct(params);
        }

        this.closeDialog();
        this.processing = false;
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
