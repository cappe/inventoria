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
      const r = await api.get('/admin/inventories');
      commit('SET_INVENTORIES', r);
    } catch (e) {}
  },

  async loadInventory({ commit }, { id }) {
    try {
      const r = await api.get(`/admin/inventories/${id}`);
      commit('SET_INVENTORY', r);
    } catch (e) {}
  },
};

const mutations = {
  SET_INVENTORIES(state, { data }) {
    Vue.set(state, 'inventories', data);
  },

  SET_INVENTORY(state, { data }) {
    Vue.set(state, 'inventory', data);
  },
};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
