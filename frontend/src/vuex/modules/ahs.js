import Vue from 'vue';

const initialState = () => ({
  installAppPrompt: null,
  appInstalled: false,
  appInstalling: false,
});

const getters = {
  installAppPrompt: state => state.installAppPrompt,
  appInstalled: state => state.appInstalled,
  appInstalling: state => state.appInstalling,
};

const actions = {
  listenToBeforeInstallPromptEvent({ commit }) {
    window.addEventListener('beforeinstallprompt', (e) => {
      e.preventDefault();

      commit('SET_APP_INSTALL_PROMPT', e);

      return false;
    });
  },

  listenToAppInstalledEvent({ commit }) {
    return new Promise((resolve) => {
      window.addEventListener('appinstalled', () => {
        commit('SET_APP_INSTALLED', true);

        resolve();
      });
    });
  },

  async promptAppInstall({ commit, getters: allGetters, dispatch }) {
    const { installAppPrompt } = allGetters;

    if (!installAppPrompt) return;

    installAppPrompt.prompt();

    commit('SET_APP_INSTALLING', true);

    await installAppPrompt.userChoice;
    await dispatch('listenToAppInstalledEvent');

    commit('SET_APP_INSTALLING', false);
  },
};

const mutations = {
  SET_APP_INSTALL_PROMPT(state, payload) {
    Vue.set(state, 'installAppPrompt', payload);
  },

  SET_APP_INSTALLED(state, payload) {
    Vue.set(state, 'appInstalled', payload);
  },

  SET_APP_INSTALLING(state, payload) {
    Vue.set(state, 'appInstalling', payload);
  },
};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
