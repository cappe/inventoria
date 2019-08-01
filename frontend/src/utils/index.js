import { getCookie, removeCookie, setCookie } from './cookie';

const ACCESS_TOKEN = 'accessToken';

export function getAccessToken() {
  return getCookie(ACCESS_TOKEN);
}

export function setAccessToken(token) {
  return setCookie(ACCESS_TOKEN, token);
}

export function removeAccessToken() {
  return removeCookie(ACCESS_TOKEN);
}
