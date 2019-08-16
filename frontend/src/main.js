import Vue from 'vue';
import './plugins/vuetify';
import './plugins/dayjs';
import VueWait from 'vue-wait';
import App from './App.vue';
import router from './router';
import store from './vuex';
import init from './initializers';

import 'roboto-fontface/css/roboto/roboto-fontface.css';
import 'material-design-icons-iconfont/dist/material-design-icons.css';

init({ store });

Vue.use(VueWait);

Vue.config.productionTip = false;

router.beforeEach(async (to, from, next) => {
  const authed = await store.dispatch('currentUser/auth');
  const {
    isAdmin,
    isSuperadmin,
  } = await store.getters['currentUser/user'];
  const isLoginPage = to.path === '/kirjaudu' || to.path === '/';

  let requiresAuth = false;
  let requiresAdmin = false;
  let requiresSuperadmin = false;

  to.matched.forEach((record) => {
    if (record.meta.requiresAuth) {
      requiresAuth = true;
    }

    if (record.meta.requiresAdmin) {
      requiresAdmin = true;
    }

    if (record.meta.requiresSuperadmin) {
      requiresSuperadmin = true;
    }
  });

  document.title = to.matched
    .filter(r => r.meta.documentTitle)
    .reduce((acc, r) => `${r.meta.documentTitle} | ${acc}`, 'Inventoria');

  await store.dispatch('admin/inventories/setCurrentInventoryId', {
    id: to.params.inventoryId,
  });

  const authedAndNotLoginPage = (authed && !isLoginPage);
  const noneAuthPage = (!authed && !requiresAuth);
  const authedAdminNotLoginPageIsAdmin = (authed && requiresAdmin && isAdmin && !isLoginPage);
  const authedSuperadminNotLoginPageIsSuperadmin = (
    authed
    && requiresSuperadmin
    && isSuperadmin
    && !isLoginPage
  );

  if (authedAndNotLoginPage
      || noneAuthPage
      || authedAdminNotLoginPageIsAdmin
      || authedSuperadminNotLoginPageIsSuperadmin
  ) {
    next();
  } else if (authed && isLoginPage) {
    if (isAdmin) {
      next({ path: '/admin/varastot' });
    } else if (isSuperadmin) {
      next({ path: '/superadmin/kayttajat' });
    } else {
      next({ path: '/lukija' });
    }
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
