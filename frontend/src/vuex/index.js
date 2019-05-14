import Vue from 'vue';
import Vuex from 'vuex';
import camelCase from 'lodash/camelCase';

Vue.use(Vuex);

const modules = {};

/* ============ Get all manager modules ============ */
const requireModule = require.context('./modules', false, /\.js$/);

requireModule.keys().forEach((fileName) => {
  const moduleName = camelCase(fileName.replace(/(\.\/|\.js)/g, ''));

  modules[moduleName] = {
    namespaced: true,
    ...requireModule(fileName).default,
  };
});

export default new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production',
  modules,
});
