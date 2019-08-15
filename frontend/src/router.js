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
        documentTitle: 'Kirjaudu',
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
          meta: meta({
            documentTitle: 'Lukija',
          }),
        },
        {
          path: 'varasto',
          name: 'inventory',
          component: () => import(/* webpackChunkName: "inventory" */ './views/Inventory.vue'),
          meta: meta({
            documentTitle: 'Varasto',
          }),
        },
        {
          path: 'tapahtumat',
          name: 'eventLog',
          component: () => import(/* webpackChunkName: "eventLog" */ './views/EventLog.vue'),
          meta: meta({
            documentTitle: 'Tapahtumat',
          }),
        },
        {
          path: 'kayttaja',
          name: 'currentUser',
          component: () => import(/* webpackChunkName: "currentUser" */ './views/CurrentUser.vue'),
          meta: meta({
            documentTitle: 'Käyttäjä',
          }),
        },
      ],
    },
    {
      path: '/admin',
      name: 'adminLayout',
      component: () => import(/* webpackChunkName: "adminLayout" */ './views/layouts/AdminLayout.vue'),
      meta: meta({
        requiresAdmin: true,
      }),
      children: [
        {
          path: 'varastot',
          name: 'inventories',
          component: () => import(/* webpackChunkName: "inventories" */ './views/admin/Inventories.vue'),
          meta: meta({
            documentTitle: 'Varastot',
          }),
        },
        {
          path: 'artikkelit',
          name: 'articles',
          component: () => import(/* webpackChunkName: "articles" */ './views/admin/Articles.vue'),
          meta: meta({
            documentTitle: 'Artikkelit',
          }),
        },
        {
          path: 'varastot/:inventoryId',
          name: 'adminInventory',
          component: () => import(/* webpackChunkName: "adminInventoryBase" */ './views/admin/Inventory.vue'),
          meta: meta({
            documentTitle: 'Varasto',
          }),
          children: [
            {
              path: 'tuotteet',
              name: 'adminInventoryProducts',
              component: () => import(/* webpackChunkName: "adminInventoryProducts" */ './views/admin/inventory/Products.vue'),
              meta: meta({
                documentTitle: 'Tuotteet',
              }),
            },
            {
              path: 'tapahtumat',
              name: 'adminInventoryEventLogs',
              component: () => import(/* webpackChunkName: "adminInventoryEventLogs" */ './views/EventLog.vue'),
              meta: meta({
                documentTitle: 'Tapahtumat',
              }),
            },
            {
              path: 'kayttajat',
              name: 'adminInventoryUsers',
              component: () => import(/* webpackChunkName: "adminInventoryUsers" */ './views/admin/inventory/Users.vue'),
              meta: meta({
                documentTitle: 'Käyttäjät',
              }),
            },
            {
              path: 'sopimus',
              name: 'adminInventoryContract',
              component: () => import(/* webpackChunkName: "adminInventoryContract" */ './views/admin/inventory/Contract.vue'),
              meta: meta({
                documentTitle: 'Sopimus',
              }),
            },
          ],
        },
        {
          path: 'kayttaja',
          name: 'adminCurrentUser',
          component: () => import(/* webpackChunkName: "adminCurrentUser" */ './views/CurrentUser.vue'),
          meta: meta({
            documentTitle: 'Käyttäjä',
          }),
        },
      ],
    },
  ],
});
