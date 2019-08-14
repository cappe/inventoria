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
          Lisää varastoon
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
      @click="simulateCameraAction"
    >
      Lue tuote
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
      processBarcode: 'inventory/processBarcode',
    }),

    async readBarcode() {
      try {
        const deviceId = await this.getDeviceId();

        if (!deviceId) return;

        const {
          text: barcode,
        } = await this.readFromCamera(deviceId);

        this.process(barcode);

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

    simulateCameraAction() {
      const barcode = '0107392532132612111606161721061610189264';

      this.process(barcode);
    },

    async process(barcode) {
      const params = {
        barcode,
        isPlacingProduct: this.isPlacingProduct,
        isUsingProduct: this.isUsingProduct,
      };

      await this.processBarcode(params);
    },
  },
};
</script>
