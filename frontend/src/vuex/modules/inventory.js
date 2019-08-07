import Vue from 'vue';
import Gs1Parser from '../../lib/gs1/Gs1Parser';
import api from '../../utils/api';

const initialState = () => ({
  inventory: {},
  products: [],
});

const getters = {
  inventory: state => state.inventory,
  products: state => state.products,
};

const actions = {
  async loadInventory({ commit }) {
    try {
      const r = await api.get(`inventories/${this.$currentInventoryId}`);
      commit('SET_INVENTORY', r);
    } catch (e) {}
  },

  async loadProducts(
    { commit },
    { include = [], used = false } = { include: [], used: false },
  ) {
    let endpoint = `inventories/${this.$currentInventoryId}/products?used=${used}&`;

    if (include.length > 0) {
      endpoint += `include=${include.join(',')}&`;
    }

    try {
      const r = await api.get(endpoint);
      commit('SET_PRODUCTS', r);
    } catch (e) {}
  },

  async placeProduct({ dispatch }, { barcode }) {
    try {
      const product = Gs1Parser.createProductFromBarode(barcode);
      const params = {
        product: product.toString(),
      };

      const r = await api.post(`/inventories/${this.$currentInventoryId}/place_product?include=article`, params);

      const successParams = {
        msg: `Tuote ${r.data.article.name} lisätty onnistuneesti`,
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

  async useProduct({ dispatch }, { barcode }) {
    try {
      const product = Gs1Parser.createProductFromBarode(barcode);
      const {
        gtin,
        lot,
      } = product.toString();

      const endpoint = `/inventories/${this.$currentInventoryId}/use_product?gtin=${gtin}&lot=${lot}&include=article`;

      const r = await api.update(endpoint);

      const successParams = {
        msg: `Tuote ${r.data.article.name} käytetty onnistuneesti`,
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
};

const mutations = {
  SET_INVENTORY(state, { data }) {
    Vue.set(state, 'inventory', data);
  },

  SET_PRODUCTS(state, { data }) {
    Vue.set(state, 'products', data);
  },
};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
