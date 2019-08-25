<template>
  <v-container
    fill-height
    class="pa-0"
  >
    <v-layout
      justify-center
      class="pa-4"
      style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; z-index: 1;"
    >
      <v-btn-toggle
        v-model="action"
        mandatory
        class="elevation-0 transparent mb-4"
      >
        <v-btn
          flat
          class="px-4"
          :active-class="activeClasses"
        >
          Lisää varastoon
        </v-btn>

        <v-btn
          flat
          class="px-4"
          :active-class="activeClasses"
        >
          Käytä tuote
        </v-btn>
      </v-btn-toggle>
    </v-layout>

    <v-layout
      justify-center
      align-center
      style="
        position: absolute;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
      "
    >
      <div
        style="width: 200px; height: 200px; border: 4px dashed white;"
      >

      </div>
    </v-layout>

    <video
      id="video"
      ref="video"
      width="100%"
      height="100%"
    />
  </v-container>
</template>

<script>
import {
  BrowserDatamatrixCodeReader,
} from '@zxing/library';
import { mapActions } from 'vuex';
import { mapWaitingActions } from 'vue-wait';

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
    this.loadInventory();
    this.readBarcode();
  },

  beforeDestroy() {
    this.killCamera();
  },

  methods: {
    ...mapActions({
      processBarcode: 'inventory/processBarcode',
    }),

    ...mapWaitingActions('inventory', {
      loadInventory: 'loading inventory',
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

    async process(barcode) {
      const params = {
        barcode,
        isPlacingProduct: this.isPlacingProduct,
        isUsingProduct: this.isUsingProduct,
        validateProduct: this.isUsingProduct,
      };

      await this.processBarcode(params);
    },

    killCamera() {
      this.codeReader.stopStreams();
      this.codeReader.unbindVideoSrc(this.$refs.video);
    },
  },
};
</script>
