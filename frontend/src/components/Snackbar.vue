<template>
  <v-snackbar
    :value="showNotification"
    :color="currentNotification.type"
    :timeout="6000"
    bottom
    right
    @input="onValueChange"
  >
    {{ currentNotification.msg }}

    <v-btn
      dark
      flat
      @click.native="removeCurrentNotification"
    >
      Sulje
    </v-btn>

  </v-snackbar>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';

export default {
  computed: {
    ...mapGetters({
      showNotification: 'snackbar/showNotification',
      currentNotification: 'snackbar/currentNotification',
    }),
  },

  methods: {
    ...mapActions({
      removeCurrentNotification: 'snackbar/removeCurrentNotification',
    }),

    onValueChange(opening) {
      if (opening) return;

      this.removeCurrentNotification();
    },
  },
};
</script>
