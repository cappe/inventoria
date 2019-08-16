import { register } from 'register-service-worker';

const registerSW = ({ store }) => {
  const swName = process.env.NODE_ENV === 'development' ? 'custom-sw.js' : 'service-worker.js';

  register(`${process.env.BASE_URL}${swName}`, {
    registered(reg) {
      store.dispatch('sw/registered', { reg });
    },

    updated(reg) {
      store.dispatch('sw/updated', { reg });
    },
  });
};

const deferAddToHomescreen = ({ store }) => {
  store.dispatch('ahs/listenToBeforeInstallPromptEvent');
};

export default ({ store }) => {
  registerSW({ store });
  deferAddToHomescreen(({ store }));
};
