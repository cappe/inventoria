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

        <v-btn
          v-if="!isNew"
          color="error"
          flat
          @click="destroy"
        >
          {{ destroyButtonText }}
        </v-btn>
      </v-card-title>

      <v-card-text>
        <v-text-field
          ref="inventoryNameRef"
          v-model="inventory.name"
          :rules="[
            v => !!v || 'Nimi on pakollinen',
            v => v && v.length <= 255 || 'Nimi saa olla enintään 255 merkkiä',
          ]"
          label="Nimi"
          required
        />
      </v-card-text>

      <v-card-actions>
        <v-spacer />

        <v-btn
          :disabled="disableActions"
          color="error"
          flat
          @click="cancel"
        >
          Peruuta
        </v-btn>

        <v-btn
          :disabled="disableActions"
          :loading="$wait.is('saving inventory')"
          color="success"
          type="submit"
        >
          Tallenna
        </v-btn>
      </v-card-actions>
    </v-form>
  </v-card>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex';
  import { mapWaitingActions } from 'vue-wait';
  import cloneDeep from 'lodash.clonedeep';

  export default {
    data: () => ({
      inventory: {},
      formValidation: false,
      confirmingDestroy: false,
    }),

    computed: {
      ...mapGetters({
        dialogProps: 'dialog/dialogProps',
      }),

      destroyButtonText() {
        if (this.confirmingDestroy) {
          return 'Varma?';
        }

        return 'Poista';
      },

      isNew() {
        return !Object.keys(this.inventory).includes('id');
      },

      title() {
        if (this.isNew) {
          return 'Luo uusi varasto';
        }

        return 'Muokkaa varastoa';
      },

      disableActions() {
        return this.$wait.is([
          'saving inventory',
          'destroying inventory',
        ]);
      },
    },

    created() {
      this.inventory = cloneDeep(this.dialogProps.inventory);

      this.$nextTick(() => {
        this.$refs.inventoryNameRef.focus();
      });
    },

    methods: {
      ...mapActions({
        closeDialog: 'dialog/closeDialog',
      }),

      ...mapWaitingActions('admin/inventories', {
        createInventory: 'saving inventory',
        updateInventory: 'saving inventory',
        destroyInventory: 'destroying inventory',
      }),

      cancel() {
        this.closeDialog();
      },

      async submit() {
        const params = {
          id: this.inventory.id,
          payload: {
            inventory: {
              name: this.inventory.name,
            },
          },
        };

        if (this.isNew) {
          await this.createInventory(params);
        } else {
          await this.updateInventory(params);
        }

        this.closeDialog();
      },

      async destroy() {
        if (!this.confirmingDestroy) {
          this.confirmingDestroy = true;
          return;
        }

        await this.destroyInventory({
          id: this.inventory.id,
        });

        if (this.$route.name === 'adminInventory') {
          this.$router.replace({
            name: 'inventories',
          });
        }

        this.closeDialog();
        this.confirmingDestroy = false;
      },
    },
  };
</script>
