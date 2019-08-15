const initialState = () => ({});

const getters = {
  isDevEnv: () => process.env.VUE_APP_ENV === 'development',
  isDemoEnv: () => process.env.VUE_APP_ENV === 'demo',
  isProductionEnv: () => process.env.VUE_APP_ENV === 'production',
};

const actions = {};

const mutations = {};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
