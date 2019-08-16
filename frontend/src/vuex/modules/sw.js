import Vue from 'vue';
import api from '../../utils/api';

const initialState = () => ({
  reg: null,
  pushSubscription: null,
  notificationPermission: false,
});

const getters = {
  supportsPushNotifications: () => 'serviceWorker' in navigator && 'PushManager' in window,
  reg: state => state.reg,
  pushSubscription: state => state.pushSubscription,
  hasValidPushSubscription: (state, moduleGetters, allGetters, rootGetters) => {
    const {
      pushSubscription,
    } = moduleGetters;
    const userPushSubscriptions = rootGetters['registration/user/pushSubscriptions'];

    if (!pushSubscription) return false;

    return userPushSubscriptions.some(ps => ps.endpoint === pushSubscription.endpoint);
  },
  notificationPermission: state => state.notificationPermission,
};

const actions = {
  /**
   * For internal use only.
   */
  async __updateReg__({ commit }, { reg }) {
    const pushSubscription = await reg.pushManager.getSubscription();

    commit('SET_PUSH_SUBSCRIPTION', { pushSubscription });
    commit('SET_REG', { reg });
  },

  async registered({ dispatch }, { reg }) {
    dispatch('__updateReg__', { reg });
  },

  updated({ dispatch }, { reg }) {
    dispatch('__updateReg__', { reg });

    const params = {
      dialogComponent: 'update-available',
    };

    dispatch('dialog/openDialog', params, { root: true });
  },

  /**
   * May throw errors
   */
  async subscribeToPushNotifications({ getters: allGetters, rootGetters, dispatch }) {
    const registrationHash = rootGetters['registration/user/registrationHash'];
    const { reg } = allGetters;

    const response = await api.get(`registrations/public_vapid_key?h=${registrationHash}`);

    const subscription = await reg.pushManager
      .subscribe({
        userVisibleOnly: true,
        applicationServerKey: new Uint8Array(response),
      });

    const subscriptionJSON = subscription.toJSON();

    const params = {
      payload: {
        user: {
          pushSubscriptionsAttributes: [
            {
              endpoint: subscriptionJSON.endpoint,
              expirationTime: subscriptionJSON.expirationTime,
              auth: subscriptionJSON.keys.auth,
              p256dh: subscriptionJSON.keys.p256dh,
            },
          ],
        },
      },
    };

    await dispatch('registration/user/updateUser', params, { root: true });
  },

  notificationPermissionRejected({ commit }, payload) {
    commit('UPDATE_NOTIFICATION_PERMISSION', payload);
  },
};

const mutations = {
  SET_REG(state, { reg }) {
    Vue.set(state, 'reg', reg);
  },

  SET_PUSH_SUBSCRIPTION(state, { pushSubscription }) {
    Vue.set(state, 'pushSubscription', pushSubscription);
  },

  UPDATE_NOTIFICATION_PERMISSION(state, payload) {
    Vue.set(state, 'notificationPermission', payload);
  },
};

export default {
  state: initialState(),
  getters,
  actions,
  mutations,
};
