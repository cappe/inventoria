import Vue from 'vue';
import api from '../../utils/api';

const initialState = () => ({
  eventLogs: [],
});

const getters = {
  eventLogs: state => state.eventLogs,
};

const actions = {
  async loadEventLogs(
    { commit },
  ) {
    try {
      const r = await api.get('/audits/by_inventory');
      commit('SET_EVENT_LOGS', r);
    } catch (e) {}
  },
};

const mutations = {
  SET_EVENT_LOGS(state, { data }) {
    Vue.set(state, 'eventLogs', data);
  },
};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
