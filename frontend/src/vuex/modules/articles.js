import Vue from 'vue';
import api from '../../utils/api';

const initialState = () => ({
  articles: [],
  selectedArticles: [],
});

const getters = {
  articles: state => state.articles,
  selectedArticles: state => state.selectedArticles,
};

const actions = {
  setSelectedArticles({ commit }, payload) {
    commit('SET_SELECTED_ARTICLES', payload);
  },

  resetSelectedArticles({ commit }) {
    commit('RESET_SELECTED_ARTICLES');
  },

  async loadArticles({ commit }, { getParams = [] } = { getParams: [] }) {
    let endpoint = 'articles?';

    if (getParams.length > 0) {
      getParams.forEach((param) => {
        endpoint += `${param.key}=${param.value}&`;
      });
    }

    try {
      const r = await api.get(endpoint);
      commit('SET_ARTICLES', r);
    } catch (e) {}
  },

  async createArticle({ commit, dispatch }, { payload }) {
    try {
      const r = await api.post('articles', payload);
      commit('ADD_TO_ARTICLES', r);

      const successParams = {
        msg: 'Artikkeli tallennettu',
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

  async updateArticle({ commit, dispatch }, { id, payload }) {
    try {
      const r = await api.update(`articles/${id}`, payload);
      commit('UPDATE_ARTICLE', r);

      const successParams = {
        msg: 'Artikkeli tallennettu',
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

  async updateSelectedArticles({ dispatch, getters: allGetters }) {
    try {
      const {
        selectedArticles,
      } = allGetters;

      const payload = {
        inventoryArticles: {
          articleIds: selectedArticles.map(a => a.id),
        },
      };

      await api.put(`admin/inventories/${this.$currentInventoryId}/inventory_articles`, payload);

      const params = {
        getParams: [
          {
            key: 'belongs_to_inventory',
            value: this.$currentInventoryId,
          },
        ],
      };

      await dispatch('loadArticles', params);

      const successParams = {
        msg: 'Artikkelit päivitetty',
        type: 'success',
      };

      dispatch('snackbar/addNotification', successParams, { root: true });
    } catch (e) {
      const errorParams = {
        msg: 'Artikkelien päivitys epäonnistui',
        type: 'error',
      };

      dispatch('snackbar/addNotification', errorParams, { root: true });
    }
  },

  async destroyArticle({ commit, dispatch }, { id }) {
    try {
      const r = await api.delete(`articles/${id}`);
      commit('DESTROY_ARTICLE', r);

      const successParams = {
        msg: 'Artikkeli poistettu',
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
  SET_SELECTED_ARTICLES(state, { selectedArticles }) {
    Vue.set(state, 'selectedArticles', selectedArticles);
  },

  RESET_SELECTED_ARTICLES(state) {
    const selectedArticles = state.articles.filter(a => a.belongsToInventory);

    Vue.set(state, 'selectedArticles', selectedArticles);
  },

  SET_ARTICLES(state, { data }) {
    Vue.set(state, 'articles', data);

    const selectedArticles = data.filter(a => a.belongsToInventory);

    Vue.set(state, 'selectedArticles', selectedArticles);
  },

  ADD_TO_ARTICLES(state, { data }) {
    state.articles.push(data);
  },

  UPDATE_ARTICLE(state, { data }) {
    const articles = state.articles.map((i) => {
      if (i.id === data.id) {
        return data;
      }

      return i;
    });

    Vue.set(state, 'articles', articles);
  },

  DESTROY_ARTICLE(state, { data }) {
    const articles = state.articles.filter(i => i.id !== data.id);
    Vue.set(state, 'articles', articles);
  },
};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
