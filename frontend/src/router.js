import Vue from 'vue';
import Router from 'vue-router';

Vue.use(Router);

export default new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'root',
      component: () => import(/* webpackChunkName: "baseLayout" */ './views/layouts/BaseLayout.vue'),
      children: [
        {
          path: 'kirjaudu',
          name: 'login',
          component: () => import(/* webpackChunkName: "login" */ './views/Login.vue'),
        },
      ],
    },
    {
      path: '/',
      name: 'bottomNavigationLayout',
      component: () => import(/* webpackChunkName: "bottomNavigationLayout" */ './views/layouts/BottomNavigationLayout.vue'),
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
          path: 'tilaukset',
          name: 'orders',
          component: () => import(/* webpackChunkName: "orders" */ './views/Orders.vue'),
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
