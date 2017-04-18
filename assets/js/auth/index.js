import {
  del, post
} from '../api';

// If testing, use localStorage polyfill, else use browser localStorage
const localStorage = global.process && process.env.NODE_ENV === 'test' ?
  // eslint-disable-next-line import/no-extraneous-dependencies
  require('localStorage') : global.window.localStorage;

/**
 * Checks if a user is logged in
 */
export function signedIn() {
  return !!localStorage.token;
}

/**
 * Logs a user in, returning a promise with `true` when done
 * @param  {string} username The username of the user
 * @param  {string} password The password of the user
 */
export function signin(username, password) {
  if (signedIn()) return Promise.resolve(true);

  return post('/sessions', {
    username,
    password
  }).then((response) => {
    // Save token to local storage
    localStorage.token = response.token;
    return Promise.resolve(true);
  });
}

/**
 * Logs the current user out
 */
export function signout() {
  return del('/sessions');
}

/**
 * Registers a user and then logs them in
 * @param  {string} username The username of the user
 * @param  {string} password The password of the user
 */
export function signup(username, password) {
  return post('/users', {
    user: {
      username,
      password
    }
  }).then((response) => {
    localStorage.token = response.token;
    return Promise.resolve(true);
  });
}
