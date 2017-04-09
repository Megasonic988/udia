import {
  del, post,
} from '../api';

// If testing, use localStorage polyfill, else use browser localStorage
const localStorage = global.process && process.env.NODE_ENV === 'test' ?
  // eslint-disable-next-line import/no-extraneous-dependencies
  require('localStorage') : global.window.localStorage;

const auth = {
  /**
   * Logs a user in, returning a promise with `true` when done
   * @param  {string} username The username of the user
   * @param  {string} password The password of the user
   */
  login(username, password) {
    if (auth.loggedIn()) return Promise.resolve(true);

    return post('/sessions', {
      username,
      password,
    }).then((response) => {
      // Save token to local storage
      localStorage.token = response.token;
      return Promise.resolve(true);
    });
  },

  /**
   * Logs the current user out
   */
  logout() {
    return del('/sessions');
  },

  /**
   * Checks if a user is logged in
   */
  loggedIn() {
    return !!localStorage.token;
  },

  /**
   * Registers a user and then logs them in
   * @param  {string} username The username of the user
   * @param  {string} password The password of the user
   */
  register(username, password) {
    return post('/users', {
      username,
      password,
    }).then(() => {
      auth.login(username, password);
    });
  },

  onChange() {},
};

export default auth;
