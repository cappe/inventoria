import Vue from 'vue';

const initialState = () => ({
  products: [],
});

const getters = {
  products: state => state.products,
};

const actions = {
  loadProducts({ commit }) {
    return new Promise((resolve) => {
      const products = [];

      for (let i = 0; i < 20; i += 1) {
        const product = {
          id: i,
          label: `Product ${i}`,
        };

        products.push(product);
      }

      commit('SET_PRODUCTS', { data: products });

      resolve();
    });
  },
};

const mutations = {
  SET_PRODUCTS(state, { data }) {
    Vue.set(state, 'products', data);
  },
};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
