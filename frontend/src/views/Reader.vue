<template>
  <v-container
    fill-height
    class="pa-0"
  >
    <v-layout
      v-if="action === null"
      column
      justify-center
      align-center
    >
      <h1
        class="mb-5"
      >
        Valitse toiminto
      </h1>

      <div>
        <v-btn
          large
          color="teal"
          class="white--text elevation-12 ml-0 mr-2"
          style="height: 100px; max-width: 150px;"
          @click="action = 0"
        >
          Lue varastoon
        </v-btn>

        <v-btn
          large
          color="info"
          class="white--text elevation-12 mr-0 ml-2"
          style="height: 100px; max-width: 150px;"
          @click="action = 1"
        >
          Käytä tuote
        </v-btn>
      </div>
    </v-layout>

    <template
      v-else
    >
      <v-layout
        justify-center
        :class="{
          'pa-4': true,
          'teal': isPlacingProduct,
          'info': isUsingProduct,
        }"
        style="position: absolute; top: 0; left: 0; right: 0; height: auto; z-index: 1;"
      >
        <h1
          class="text-xs-center white--text"
        >
          {{ actionTitle }}
        </h1>

        <v-spacer />

        <v-btn
          icon
          outline
          large
          dark
          @click="action = null"
        >
          <v-icon
            dark
          >
            close
          </v-icon>
        </v-btn>
      </v-layout>

      <!-- dashed square -->
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
        />
      </v-layout>

      <video
        id="video"
        ref="video"
        width="100%"
        height="100%"
      />
    </template>
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
    action: null,
  }),

  computed: {
    isPlacingProduct() {
      return this.action === 0;
    },

    isUsingProduct() {
      return this.action === 1;
    },

    actionTitle() {
      if (this.isPlacingProduct) {
        return 'Lue varastoon';
      }

      return 'Käytä tuote';
    },
  },

  watch: {
    action(newVal) {
      if (newVal === null) {
        this.killCamera();
      } else {
        this.readBarcode();
      }
    },
  },

  mounted() {
    this.loadInventory();
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
