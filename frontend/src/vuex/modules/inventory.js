import Vue from 'vue';
import Gs1Parser from '../../lib/gs1/Gs1Parser';
import api from '../../utils/api';

const initialState = () => ({
  inventory: {},
  articlesWithProducts: [],
});

const getters = {
  inventory: state => state.inventory,
  articlesWithProducts: state => state.articlesWithProducts,
};

const actions = {
  async loadInventory({ commit }) {
    try {
      const r = await api.get(`inventories/${this.$currentInventoryId}`);
      commit('SET_INVENTORY', r);
    } catch (e) {}
  },

  async loadArticle(context, { gtin }) { // eslint-disable-line
    try {
      const r = await api.get(`article_by_gtin/${gtin}`);

      return r.data;
    } catch (e) {}
  },

  async processBarcode({ dispatch }, { barcode, ...rest }) {
    try {
      const product = Gs1Parser.createProductFromBarode(barcode).toString();

      const article = await dispatch('loadArticle', {
        gtin: product.gtin,
      });

      const dialogParams = {
        dialogComponent: 'show-barcode-result',
        dialogProps: {
          product,
          article,
          ...rest,
        },
      };

      await dispatch('dialog/openDialog', dialogParams, { root: true });
    } catch (e) {}
  },

  async loadArticlesWithProducts({ commit }) {
    try {
      const r = await api.get(`inventories/${this.$currentInventoryId}/articles_with_products`);
      commit('SET_ARTICLES_PRODUCTS', r);
    } catch (e) {}
  },

  async placeProduct({ dispatch }, { payload }) {
    try {
      const r = await api.post(`/inventories/${this.$currentInventoryId}/place_product?include=article`, payload);

      const successParams = {
        msg: `Tuote ${r.data.article.name} lisätty varastoon`,
        type: 'success',
      };

      await dispatch('snackbar/addNotification', successParams, { root: true });
    } catch (e) {
      const errorParams = {
        msg: e.message,
        type: 'error',
      };

      await dispatch('snackbar/addNotification', errorParams, { root: true });
    }
  },

  async useProduct({ dispatch }, { payload }) {
    try {
      const {
        gtin,
        lot,
      } = payload.product;

      const endpoint = `/inventories/${this.$currentInventoryId}/use_product?gtin=${gtin}&lot=${lot}&include=article`;

      const r = await api.update(endpoint);

      const successParams = {
        msg: `Tuote ${r.data.article.name} käytetty`,
        type: 'info',
      };

      await dispatch('snackbar/addNotification', successParams, { root: true });
    } catch (e) {
      const errorParams = {
        msg: e.message,
        type: 'error',
      };

      await dispatch('snackbar/addNotification', errorParams, { root: true });
    }
  },
};

const mutations = {
  SET_INVENTORY(state, { data }) {
    Vue.set(state, 'inventory', data);
  },

  SET_ARTICLES_PRODUCTS(state, { data }) {
    Vue.set(state, 'articlesWithProducts', data);
  },
};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
