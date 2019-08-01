import Cookies from 'js-cookie';

export function getCookie(name) {
  return Cookies.get(name);
}

export function setCookie(name, value, opts = {}) {
  const defaultOpts = {
    expires: 7300,
  };

  Cookies.set(name, value, Object.assign({}, defaultOpts, opts));
}

export function removeCookie(name) {
  Cookies.remove(name);
}
