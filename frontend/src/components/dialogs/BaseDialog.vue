<template>
  <v-dialog
    v-model="showDialog"
    :max-width="maxWidth"
    :scrollable="scrollable"
    persistent
    @keydown.esc="closeDialog"
  >
    <component :is="dialogComponent" />
  </v-dialog>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex';
  import dialogComponents from './components';

  export default {
    components: dialogComponents,

    computed: {
      ...mapGetters({
        dialogComponent: 'dialog/dialogComponent',
        showDialog: 'dialog/showDialog',
        maxWidth: 'dialog/maxWidth',
        scrollable: 'dialog/scrollable',
      }),
    },

    methods: {
      ...mapActions({
        closeDialog: 'dialog/closeDialog',
      }),
    },
  };
</script>
