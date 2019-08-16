import api from '../../../utils/api';

const initialState = () => ({});

const getters = {};

const actions = {
  async loadAdmins({ commit }) {
    try {
      const r = await api.get('superadmin/users');
      commit('admin/users/SET_USERS', r, { root: true });
    } catch (e) {}
  },

  async createUser({ commit, dispatch }, { payload }) {
    try {
      const r = await api.post('superadmin/users', payload);
      commit('admin/users/ADD_TO_USERS', r, { root: true });

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
};

const mutations = {};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
