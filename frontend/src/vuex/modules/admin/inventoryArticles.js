import Vue from 'vue';
import api from '../../../utils/api';

const initialState = () => ({
  inventoryArticles: [],
});

const getters = {
  inventoryArticles: state => state.inventoryArticles,
  groupedInventoryArticles: (_, allGetters) => {
    const r = allGetters.inventoryArticles.reduce((acc, ia) => {
      acc[ia.articleId] = ia;

      return acc;
    }, {});

    return r;
  },
  inventoryArticleById: (_, allGetters) => id => allGetters.groupedInventoryArticles[id],
};

const actions = {
  async loadInventoryArticles({ commit }) {
    try {
      const r = await api.get(`admin/inventories/${this.$currentInventoryId}}/inventory_articles`);
      commit('SET_INVENTORY_ARTICLES', r);
    } catch (e) {}
  },

  async createInventoryArticle({ commit, dispatch }, { payload }) {
    try {
      const r = await api.post(`admin/inventories/${this.$currentInventoryId}}/inventory_articles`, payload);
      commit('ADD_TO_INVENTORY_ARTICLES', r);

      const successParams = {
        msg: 'Päivitys onnistui',
        type: 'success',
      };

      dispatch('snackbar/addNotification', successParams, { root: true });
    } catch (e) {
      const errorParams = {
        msg: e.message,
        type: 'error',
      };

      dispatch('snackbar/addNotification', errorParams, { root: true });
    }
  },

  async updateInventoryArticle({ commit, dispatch }, { id, payload }) {
    try {
      const r = await api.update(`admin/inventories/${this.$currentInventoryId}/inventory_articles/${id}`, payload);
      commit('UPDATE_INVENTORY_ARTICLE', r);

      const successParams = {
        msg: 'Päivitys onnistui',
        type: 'success',
      };

      dispatch('snackbar/addNotification', successParams, { root: true });
    } catch (e) {
      const errorParams = {
        msg: e.message,
        type: 'error',
      };

      dispatch('snackbar/addNotification', errorParams, { root: true });
    }
  },

  async destroyInventoryArticle({ commit, dispatch }, { id }) {
    try {
      const r = await api.delete(`admin/inventories/${this.$currentInventoryId}/inventory_articles/${id}`);
      commit('DESTROY_INVENTORY_ARTICLE', r);

      const successParams = {
        msg: 'Päivitys onnistui',
        type: 'success',
      };

      dispatch('snackbar/addNotification', successParams, { root: true });
    } catch (e) {
      const errorParams = {
        msg: e.message,
        type: 'error',
      };

      dispatch('snackbar/addNotification', errorParams, { root: true });
    }
  },
};

const mutations = {
  SET_INVENTORY_ARTICLES(state, { data }) {
    Vue.set(state, 'inventoryArticles', data);
  },

  ADD_TO_INVENTORY_ARTICLES(state, { data }) {
    state.inventoryArticles.push(data);
  },

  UPDATE_INVENTORY_ARTICLE(state, { data }) {
    const inventoryArticles = state.inventoryArticles.map((i) => {
      if (i.id === data.id) {
        return data;
      }

      return i;
    });

    Vue.set(state, 'inventoryArticles', inventoryArticles);
  },

  DESTROY_INVENTORY_ARTICLE(state, { data }) {
    const inventoryArticles = state.inventoryArticles.filter(i => i.id !== data.id);
    Vue.set(state, 'inventoryArticles', inventoryArticles);
  },
};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
