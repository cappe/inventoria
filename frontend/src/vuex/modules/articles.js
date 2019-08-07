import Vue from 'vue';
import api from '../../utils/api';

const initialState = () => ({
  articles: [],
});

const getters = {
  articles: state => state.articles,
};

const actions = {
  async loadArticles({ commit }) {
    try {
      const r = await api.get('articles');
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
  SET_ARTICLES(state, { data }) {
    Vue.set(state, 'articles', data);
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
