<template>
  <v-container>
    <h1>
      Reader
    </h1>

    <v-btn
      @click="create"
    >
      Create product
    </v-btn>

    <video
      id="video"
      width="100%"
      height="100%"
      style="border: 1px solid gray"
    />
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
  }),

  mounted() {
    // this.readBarcode();
  },

  methods: {
    ...mapActions({
      placeProduct: 'inventory/placeProduct',
    }),

    async readBarcode() {
      try {
        const deviceId = await this.getDeviceId();

        const {
          text: barcode,
        } = await this.readFromCamera(deviceId);

        await this.placeProduct({
          barcode,
        });

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
  },
};
</script>
