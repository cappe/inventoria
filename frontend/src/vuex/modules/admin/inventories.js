import Vue from 'vue';
import api from '../../../utils/api';

const initialState = () => ({
  inventories: [],
  inventory: {},
});

const getters = {
  inventories: state => state.inventories,
  inventory: state => state.inventory,
};

const actions = {
  async loadInventories({ commit }) {
    try {
      const r = await api.get('admin/inventories');
      commit('SET_INVENTORIES', r);
    } catch (e) {}
  },

  async loadInventory({ commit }, { id }) {
    try {
      const r = await api.get(`admin/inventories/${id}`);
      commit('SET_INVENTORY', r);
    } catch (e) {}
  },

  async createInventory({ commit, dispatch }, { payload }) {
    try {
      const r = await api.post('admin/inventories', payload);
      commit('ADD_TO_INVENTORIES', r);

      const successParams = {
        msg: 'Inventaario tallennettu',
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

  async updateInventory({ commit, dispatch }, { id, payload }) {
    try {
      const r = await api.update(`admin/inventories/${id}`, payload);
      commit('UPDATE_INVENTORY', r);

      const successParams = {
        msg: 'Inventaario tallennettu',
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

  async destroyInventory({ commit, dispatch }, { id }) {
    try {
      const r = await api.delete(`admin/inventories/${id}`);
      commit('DESTROY_INVENTORY', r);

      const successParams = {
        msg: 'Inventaario poistettu',
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
  SET_INVENTORIES(state, { data }) {
    Vue.set(state, 'inventories', data);
  },

  SET_INVENTORY(state, { data }) {
    Vue.set(state, 'inventory', data);
  },

  ADD_TO_INVENTORIES(state, { data }) {
    state.inventories.push(data);
  },

  UPDATE_INVENTORY(state, { data }) {
    if (state.inventories.length > 0) {
      const inventories = state.inventories.map((i) => {
        if (i.id === data.id) {
          return data;
        }

        return i;
      });

      Vue.set(state, 'inventories', inventories);
    }

    if (state.inventory.id === data.id) {
      Vue.set(state, 'inventory', data);
    }
  },

  DESTROY_INVENTORY(state, { data }) {
    if (state.inventories.length > 0) {
      const inventories = state.inventories.filter(i => i.id !== data.id);
      Vue.set(state, 'inventories', inventories);
    }

    if (state.inventory.id === data.id) {
      Vue.set(state, 'inventory', initialState().inventory);
    }
  },
};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
