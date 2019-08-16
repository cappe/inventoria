/* eslint no-restricted-globals: ["error"] */ // Allows self

self.addEventListener('message', (event) => {
  if (!event.data) return;

  switch (event.data.action) {
    case 'skip-waiting':
      self.skipWaiting();
      break;
    default:
      break;
  }
});

self.addEventListener('push', (event) => {
  if (!event.data) return;

  const {
    title,
    body,
  } = event.data.json();

  const options = {
    body,
    icon: '/img/icons/android-chrome-192x192.png',
    badge: '/img/icons/apple-touch-icon-76x76.png',
    vibrate: [150, 150],
  };

  const promiseChain = self.registration.showNotification(title, options);

  event.waitUntil(promiseChain);
});

self.addEventListener('notificationclick', (event) => {
  const {
    notification,
    action,
  } = event;

  if (!action) {
    notification.close();
    return;
  }

  // switch (event.action) {
  //   case 'coffee-action':
  //     console.log('User ❤️️\'s coffee.');
  //     break;
  //   case 'doughnut-action':
  //     console.log('User ❤️️\'s doughnuts.');
  //     break;
  //   case 'gramophone-action':
  //     console.log('User ❤️️\'s music.');
  //     break;
  //   case 'atom-action':
  //     console.log('User ❤️️\'s science.');
  //     break;
  //   default:
  //     console.log(`Unknown action clicked: '${event.action}'`);
  //     break;
  // }

  // Do something as the result of the notification click
  // const promiseChain = doSomething();
  // event.waitUntil(promiseChain);

  notification.close();
});
