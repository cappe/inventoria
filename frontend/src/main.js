import Vue from 'vue';
import './plugins/vuetify';
import VueWait from 'vue-wait';
import App from './App';
import router from './router';
import store from './vuex';

import './registerServiceWorker';
import 'roboto-fontface/css/roboto/roboto-fontface.css';
import 'material-design-icons-iconfont/dist/material-design-icons.css';

Vue.use(VueWait);

Vue.config.productionTip = false;

router.beforeEach(async (to, from, next) => {
  const authed = await store.dispatch('currentUser/auth');
  const isLoginPage = to.path === '/kirjaudu' || to.path === '/';

  let requiresAuth = false;

  to.matched.forEach((record) => {
    if (record.meta.requiresAuth) {
      requiresAuth = true;
    }
  });

  // document.title = to.matched
  //   .filter(r => r.meta.documentTitle)
  //   .reduce((acc, r) => `${r.meta.documentTitle} | ${acc}`, 'Mestamaster');

  if ((authed && !isLoginPage) || (!authed && !requiresAuth)) {
    next();
  } else if (authed && isLoginPage) {
    next({ path: '/lukija' });
  } else {
    await store.dispatch('currentUser/logout');

    next({ path: '/kirjaudu', query: { redirect: to.fullPath } });
  }
});

new Vue({
  router,
  store,
  wait: new VueWait({
    useVuex: false,
  }),
  render: h => h(App),
}).$mount('#app');
