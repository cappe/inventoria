/**
 * This snackbar module is FIFO-based (first-in — first-out).
 */

import Vue from 'vue';

const initialState = () => ({
  queue: [],
  currentNotification: {},
});

const getters = {
  currentNotification: state => state.currentNotification,
  queue: state => state.queue,
  showNotification: (_, allGetters) => Object.keys(allGetters.currentNotification).length > 0,
  hasNotificationsInQueue: (_, allGetters) => allGetters.queue.length > 0,
};

const actions = {
  addNotification({ commit }, payload) {
    commit('ADD_NOTIFICATION_TO_QUEUE', payload);
    commit('SHOW_NEXT_NOTIFICATION');
  },

  removeCurrentNotification({ commit, getters: allGetters }) {
    commit('REMOVE_CURRENT_NOTIFICATION');

    if (!allGetters.hasNotificationsInQueue) return;

    /**
     * Allows snackbar animation to finish
     */
    setTimeout(() => {
      commit('SHOW_NEXT_NOTIFICATION');
    }, 500);
  },

  // showGeneralError({ dispatch }) {
  //   dispatch('addNotification', { msg: 'Jotakin meni vikaan', type: 'error' });
  // },
};

const mutations = {
  SHOW_NEXT_NOTIFICATION(state) {
    Vue.set(state, 'currentNotification', state.queue[0]);
  },

  ADD_NOTIFICATION_TO_QUEUE(state, payload) {
    state.queue.push(payload);
  },

  REMOVE_CURRENT_NOTIFICATION(state) {
    Vue.set(state, 'currentNotification', initialState().currentNotification);
    state.queue.splice(0, 1);
  },
};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
