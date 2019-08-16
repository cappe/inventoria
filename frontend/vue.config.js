const WebpackPwaManifest = require('webpack-pwa-manifest'); // eslint-disable-line
const path = require('path');

const shortName = () => {
  switch (process.env.VUE_APP_ENV) {
    case 'development':
      return 'Dev Inventoria';
    case 'demo':
      return 'Demo Inventoria';
    default:
      return 'Inventoria';
  }
};

module.exports = {
  pwa: {
    workboxOptions: {
      importScripts: ['custom-sw.js', 'cache-strategies.js'],
    },
  },

  configureWebpack: {
    plugins: [
      new WebpackPwaManifest({
        name: 'Inventoria',
        short_name: shortName(),
        background_color: '#F3F6F8',
        theme_color: '#4c5473',
        orientation: 'any',
        display: 'standalone',
        start_url: '/kirjaudu?utm_source=standalone',
        inject: false,
        fingerprints: false,
        icons: [
          {
            src: path.resolve('./public/img/icons/icon.png'),
            sizes: [192, 512],
          },
        ],
      }),
    ],
  },
};
