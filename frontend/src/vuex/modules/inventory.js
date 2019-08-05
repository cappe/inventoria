import Vue from 'vue';
import Gs1Parser from '../../lib/gs1/Gs1Parser';
import api from '../../utils/api';

const initialState = () => ({
  products: [],
});

const getters = {
  products: state => state.products,
};

const actions = {
  async loadProducts(
    { commit },
    { include = [], used = false } = { include: [], used: false },
  ) {
    let endpoint = '/products?';

    if (include.length > 0) {
      endpoint += `include=${include.join(',')}&`;
    }

    if (used) {
      endpoint += `used=${used}&`;
    }

    try {
      const r = await api.get(endpoint);
      commit('SET_PRODUCTS', r);
    } catch (e) {}
  },

  async placeProduct({ commit, dispatch }, { barcode }) {
    try {
      const product = Gs1Parser.createProductFromBarode(barcode);
      const params = {
        product: product.toString(),
      };

      const r = await api.post('/inventories/place_product', params);

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
};

const mutations = {
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
