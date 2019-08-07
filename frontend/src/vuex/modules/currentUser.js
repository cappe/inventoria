import Vue from 'vue';
import Vuex from 'vuex';
import api from '../../utils/api';
import {
  setAccessToken,
  removeAccessToken,
  getAccessToken,
} from '../../utils';

const initialState = () => ({
  user: {},
});

const getters = {
  user: state => state.user,
  authenticated: (_, allGetters) => !!allGetters.user.accessToken,
};

const actions = {
  async login({ commit, dispatch }, params) {
    try {
      const r = await api.post('login', params);

      commit('SET_USER', r);

      return true;
    } catch (e) {
      const errorParams = {
        msg: 'Kirjautuminen epäonnistui, tarkista sähköposti ja salasana',
        type: 'error',
      };

      dispatch('snackbar/addNotification', errorParams, { root: true });

      return false;
    }
  },

  logout({ commit }) {
    const accessToken = getAccessToken();

    if (!accessToken) {
      commit('LOGOUT');
      return true;
    }

    return api.delete('logout')
      .then(() => true)
      .catch(() => false)
      .finally(() => commit('LOGOUT'));
  },

  async auth({ commit, getters: allGetters }) {
    if (!getAccessToken()) {
      return false;
    }

    if (allGetters.authenticated) {
      return true;
    }

    try {
      const r = await api.get('auth');

      commit('SET_USER', r);

      return true;
    } catch (e) {
      return false;
    }
  },
};

const mutations = {
  SET_USER(state, { data }) {
    setAccessToken(data.accessToken);

    Vue.prototype.$currentUser = data;
    Vuex.Store.prototype.$currentUser = data;

    Vue.set(state, 'data', data);
  },

  LOGOUT(state) {
    removeAccessToken();

    Vue.set(state, 'data', initialState().data);

    Vue.prototype.$currentUser = undefined;
    Vuex.Store.prototype.$currentUser = undefined;
  },
};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
