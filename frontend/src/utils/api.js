// import { getAccessToken } from './index';
// import store from '../vuex';

// const BASE_URL = `https://${process.env.VUE_APP_API_URL}/api/v2`;

const getHeaders = (args = {}) => {
  const defaults = {
    Accept: 'application/json',
  };
  const accessToken = getAccessToken();

  if (accessToken) {
    defaults.Authorization = `Token token=${accessToken}`;
  }

  return Object.assign(defaults, args);
};

const parseResponse = (response) => {
  if (response.status >= 200 && response.status < 300) {
    if (response.status === 204) return true; // Return true if 204 No Content

    return response.json();
  }

  return response.json().then(async (err) => {
    throw err;
  });
};

export default {
  get(url) {
    const options = {
      method: 'GET',
      headers: getHeaders(),
    };

    return fetch(`${BASE_URL}/${url}`, options).then(parseResponse);
  },
  post(url, data) {
    const options = {
      method: 'POST',
      headers: getHeaders({
        'Content-Type': 'application/json',
      }),
      body: JSON.stringify(data),
    };

    return fetch(`${BASE_URL}/${url}`, options).then(parseResponse);
  },
  update(url, data) {
    const options = {
      method: 'PATCH',
      headers: getHeaders({
        'Content-Type': 'application/json',
      }),
      body: JSON.stringify(data),
    };

    return fetch(`${BASE_URL}/${url}`, options).then(parseResponse);
  },
  delete(url) {
    const options = {
      method: 'DELETE',
      headers: getHeaders({
        'Content-Type': 'application/json',
      }),
    };

    return fetch(`${BASE_URL}/${url}`, options).then(parseResponse);
  },
};
