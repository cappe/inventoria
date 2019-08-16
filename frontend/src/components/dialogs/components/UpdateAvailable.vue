<template>
  <v-card class="pa-4">
    <v-card-title
      class="title text-xs-center d-block full-width"
    >
      Päivitys saatavilla
    </v-card-title>

    <v-card-text
      class="text-xs-center"
    >
      Sinun tulee päivittää sivusto voidaksesi jatkaa käyttöä
    </v-card-text>

    <v-card-actions class="mt-3">
      <v-btn
        :disabled="refreshing"
        :loading="refreshing"
        depressed
        block
        large
        style="height: 48px;"
        color="success"
        @click="refresh"
      >
        Päivitä
        <v-icon
          right
        >refresh</v-icon>
      </v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
  import { mapGetters } from 'vuex';

  export default {
    data: () => ({
      refreshing: false,
    }),

    computed: {
      ...mapGetters({
        reg: 'sw/reg',
      }),
    },

    methods: {
      refresh() {
        this.refreshing = true;

        if (this.reg.waiting && 'postMessage' in this.reg.waiting) {
          this.reg.waiting.postMessage({ action: 'skip-waiting' });
        }

        window.location.reload();
      },
    },
  };
</script>
