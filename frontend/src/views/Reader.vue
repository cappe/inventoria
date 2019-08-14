<template>
  <v-container>
    <h1>
      Reader
    </h1>

    <v-layout
      justify-center
    >
      <v-btn-toggle
        v-model="action"
        mandatory
        class="elevation-0 transparent mb-4"
      >
        <v-btn
          flat
          large
          class="px-5"
          :active-class="activeClasses"
        >
          Lue varastoon
        </v-btn>

        <v-btn
          flat
          large
          class="px-5"
          :active-class="activeClasses"
        >
          Käytä tuote
        </v-btn>
      </v-btn-toggle>
    </v-layout>

    <video
      id="video"
      width="100%"
      height="100%"
      style="border: 1px solid gray"
    />

    <v-btn
      @click="create"
    >
      Lue varastoon
    </v-btn>

    <v-btn
      @click="update"
    >
      Käytä tuote
    </v-btn>

  </v-container>
</template>

<script>
import {
  BrowserDatamatrixCodeReader,
} from '@zxing/library';
import { mapActions } from 'vuex';

export default {
  data: () => ({
    codeReader: new BrowserDatamatrixCodeReader(),
    action: 0,
  }),

  computed: {
    isPlacingProduct() {
      return this.action === 0;
    },

    isUsingProduct() {
      return this.action === 1;
    },

    activeClasses() {
      let classes = 'white--text elevation-12 v-btn--active ';

      if (this.isPlacingProduct) {
        classes += 'teal';
      } else if (this.isUsingProduct) {
        classes += 'info';
      }

      return classes;
    },
  },

  mounted() {
    this.readBarcode();
  },

  methods: {
    ...mapActions({
      placeProduct: 'inventory/placeProduct',
      useProduct: 'inventory/useProduct',
    }),

    async readBarcode() {
      try {
        const deviceId = await this.getDeviceId();

        if (!deviceId) return;

        const {
          text: barcode,
        } = await this.readFromCamera(deviceId);

        const params = {
          barcode,
        };

        if (this.isPlacingProduct) {
          await this.placeProduct(params);
        } else if (this.isUsingProduct) {
          await this.useProduct(params);
        }

        this.readBarcode();
      } catch (e) {
        console.error(e);
      }
    },

    async getDeviceId() {
      const videoInputDevices = await this.codeReader.getVideoInputDevices();

      if (videoInputDevices.length <= 0) {
        return null;
      }

      if (videoInputDevices.length === 1) {
        return videoInputDevices[0].deviceId; // The only available camera
      }

      return videoInputDevices[1].deviceId; // Rear camera
    },

    async readFromCamera(deviceId) {
      const result = await this.codeReader.decodeFromInputVideoDevice(deviceId, 'video');

      return result;
    },

    create() {
      this.placeProduct({
        barcode: '0107392532132612111606161721061610189264',
      });
    },

    update() {
      this.useProduct({
        barcode: '0107392532132612111606161721061610189264',
      });
    },
  },
};
</script>
