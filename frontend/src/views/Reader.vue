<template>
  <v-container>
    <h1>
      Reader
    </h1>

    <video
      id="video"
      width="300"
      height="200"
      style="border: 1px solid gray"
    />
  </v-container>
</template>

<script>
import {
  BrowserDatamatrixCodeReader,
} from '@zxing/library';

export default {
  data: () => ({
    codeReader: null,
  }),

  mounted() {
    this.codeReader = new BrowserDatamatrixCodeReader();

    this.watchDatamatrices();
  },

  methods: {
    async watchDatamatrices() {
      try {
        const videoInputDevices = await this.codeReader.getVideoInputDevices();

        const firstDeviceId = videoInputDevices[1].deviceId;

        const result = await this.codeReader.decodeFromInputVideoDevice(firstDeviceId, 'video');

        alert(result); // eslint-disable-line

        this.watchDatamatrices();
      } catch (e) {
        console.error(e);
      }
    },
  },
};
</script>
