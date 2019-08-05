<template>
  <div>
    <p
      v-for="(detail, i) in details"
      :key="i"
      class="mb-2"
    >
      <span
        class="d-block font-weight-bold"
      >
        {{ detail.label }}
      </span>

      <span>
        {{ detail.value }}
      </span>
    </p>
  </div>
</template>

<script>
  export default {
    props: {
      product: {
        type: Object,
        required: true,
      },
    },

    computed: {
      article() {
        return this.product.article;
      },

      details() {
        return [
          {
            label: 'Valmistettu',
            value: this.$dayjs(this.product.manufactureDate).format('DD.MM.YYYY'),
          },
          {
            label: 'Viimeinen käyttöpäivä',
            value: this.$dayjs(this.product.expiryDate).format('DD.MM.YYYY'),
          },
          {
            label: 'Tuotenumero',
            value: this.article.pid,
          },
          {
            label: 'LOT',
            value: this.product.lot,
          },
          {
            label: 'GTIN13',
            value: this.article.gtin13,
          },
          {
            label: 'GTIN14',
            value: this.article.gtin14,
          },
          {
            label: 'Tyyppi',
            value: this.article.unit,
          },
        ];
      },
    },
  };
</script>
