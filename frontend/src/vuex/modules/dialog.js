import Vue from 'vue';

const initialState = () => ({
  dialogComponent: null,
  dialogProps: {},
  config: {},
  showDialog: false,
});

const getters = {
  dialogComponent: state => state.dialogComponent,
  dialogProps: state => state.dialogProps,
  maxWidth: state => state.config.maxWidth ? state.config.maxWidth : '500px', // eslint-disable-line
  scrollable: state => !!state.config.scrollable,
  showDialog: state => state.showDialog,
};

const actions = {
  openDialog({ commit }, payload) {
    commit('OPEN_DIALOG', payload);
  },

  closeDialog({ commit }) {
    commit('CLOSE_DIALOG');

    setTimeout(() => {
      commit('RESET_DIALOG');
    }, 300);
  },
};

const mutations = {
  OPEN_DIALOG(state, { dialogComponent, dialogProps, config = {} }) {
    Vue.set(state, 'dialogComponent', dialogComponent);
    Vue.set(state, 'dialogProps', dialogProps);
    Vue.set(state, 'config', config);
    Vue.set(state, 'showDialog', true);
  },

  CLOSE_DIALOG(state) {
    Vue.set(state, 'showDialog', false);
  },

  RESET_DIALOG(state) {
    const initial = initialState();

    Vue.set(state, 'dialogComponent', initial.dialogComponent);
    Vue.set(state, 'dialogProps', initial.dialogProps);
    Vue.set(state, 'config', initial.config);
  },
};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
