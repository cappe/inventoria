import Vue from 'vue';
import './plugins/vuetify';
import VueWait from 'vue-wait';
import App from './App.vue';
import router from './router';
import store from './vuex';

import './registerServiceWorker';
import 'roboto-fontface/css/roboto/roboto-fontface.css';
import 'material-design-icons-iconfont/dist/material-design-icons.css';

Vue.use(VueWait);

Vue.config.productionTip = false;

new Vue({
  router,
  store,
  wait: new VueWait({
    useVuex: false,
  }),
  render: h => h(App),
}).$mount('#app');
