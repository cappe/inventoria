import Vue from 'vue';
import Vuetify from 'vuetify/lib';
import 'vuetify/src/stylus/app.styl';

import LoaderCircular from '@/components/loaders/LoaderCircular';

Vue.use(Vuetify, {
  options: {
    customProperties: true,
  },
  iconfont: 'md',
});

Vue.component('loader-circular', LoaderCircular);
