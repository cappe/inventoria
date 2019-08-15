import Vue from 'vue';
import api from '../../../utils/api';

const initialState = () => ({
  users: [],
});

const getters = {
  users: state => state.users,
};

const actions = {
  async loadUsers({ commit }) {
    try {
      const r = await api.get('superadmin/users');
      commit('SET_USERS', r);
    } catch (e) {}
  },

  async createUser({ commit, dispatch }, { payload }) {
    try {
      const r = await api.post('superadmin/users', payload);
      commit('ADD_TO_USERS', r);

      const successParams = {
        msg: 'Käyttäjä tallennettu',
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

  async updateUser({ commit, dispatch }, { id, payload }) {
    try {
      const r = await api.update(`superadmin/users/${id}`, payload);
      commit('UPDATE_USER', r);

      const successParams = {
        msg: 'Käyttäjä tallennettu',
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

  async destroyUser({ commit, dispatch }, { id }) {
    try {
      const r = await api.delete(`superadmin/users/${id}`);
      commit('DESTROY_USER', r);

      const successParams = {
        msg: 'Käyttäjä poistettu',
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
  SET_USERS(state, { data }) {
    Vue.set(state, 'users', data);
  },

  ADD_TO_USERS(state, { data }) {
    state.users.push(data);
  },

  UPDATE_USER(state, { data }) {
    const users = state.users.map((i) => {
      if (i.id === data.id) {
        return data;
      }

      return i;
    });

    Vue.set(state, 'users', users);
  },

  DESTROY_USER(state, { data }) {
    const users = state.users.filter(i => i.id !== data.id);
    Vue.set(state, 'users', users);
  },
};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
