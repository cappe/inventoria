import Vue from 'vue';
import Router from 'vue-router';

Vue.use(Router);

const meta = opts => Object.assign({}, {
  requiresAuth: true,
}, opts);

export default new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      component: () => import(/* webpackChunkName: "baseLayout" */ './views/layouts/BaseLayout.vue'),
      meta: meta({
        requiresAuth: false,
      }),
      children: [
        {
          path: '/',
          alias: 'kirjaudu',
          name: 'root',
          component: () => import(/* webpackChunkName: "login" */ './views/Login.vue'),
          meta: meta({
            requiresAuth: false,
          }),
        },
      ],
    },
    {
      path: '/',
      name: 'bottomNavigationLayout',
      component: () => import(/* webpackChunkName: "bottomNavigationLayout" */ './views/layouts/BottomNavigationLayout.vue'),
      meta: meta(),
      children: [
        {
          path: 'lukija',
          name: 'reader',
          component: () => import(/* webpackChunkName: "reader" */ './views/Reader.vue'),
        },
        {
          path: 'varasto',
          name: 'inventory',
          component: () => import(/* webpackChunkName: "inventory" */ './views/Inventory.vue'),
        },
        {
          path: 'tapahtumat',
          name: 'eventLog',
          component: () => import(/* webpackChunkName: "eventLog" */ './views/EventLog.vue'),
        },
        {
          path: 'kayttaja',
          name: 'currentUser',
          component: () => import(/* webpackChunkName: "currentUser" */ './views/CurrentUser.vue'),
        },
      ],
    },
  ],
});
