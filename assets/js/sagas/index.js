// This file contains the sagas used for async actions in our app. It's divided into
// "effects" that the sagas call (`authorize` and `logout`) and the actual sagas themselves,
// which listen for actions.

// Sagas help us gather all our side effects (network requests in this case) in one place

// import { take, call, put, fork, race } from 'redux-saga/effects';
import { effects } from 'redux-saga';

import {
  SENDING_REQUEST,
  LOGIN_REQUEST,
  REGISTER_REQUEST,
  SET_AUTH,
  LOGOUT,
  CHANGE_FORM,
  REQUEST_ERROR,
} from '../actions/constants';

import * as auth from '../auth';

/**
 * Effect to handle authorization
 * @param  {string} username               The username of the user
 * @param  {string} password               The password of the user
 * @param  {object} options                Options
 * @param  {boolean} options.isRegistering Is this a register request?
 */
export function* authorize({
  username,
  password,
  isRegistering,
}) {
  yield effects.put({
    type: SENDING_REQUEST,
    sending: true,
  });

  try {
    console.log(auth);
    let response;
    if (isRegistering) {
      response = yield effects.call(auth.default.signup, username, password);
    } else {
      response = yield effects.call(auth.default.signin, username, password);
    }
    return response;
  } catch (error) {
    yield effects.put({
      type: REQUEST_ERROR,
      error: error.message,
    });
    return false;
  } finally {
    yield effects.put({
      type: SENDING_REQUEST,
      sending: false,
    });
  }
}

/**
 * Effect to handle logging out
 */
export function* logout() {
  yield effects.put({
    type: SENDING_REQUEST,
    sending: true,
  });

  try {
    const response = yield effects.call(auth.default.signout);
    return response;
  } catch (error) {
    yield effects.put({
      type: REQUEST_ERROR,
      error: error.message,
    });
    return false;
  } finally {
    yield effects.put({
      type: SENDING_REQUEST,
      sending: false,
    });
  }
}

/**
 * Log in saga
 */
export function* loginFlow() {
  while (true) {
    const request = yield effects.take(LOGIN_REQUEST);
    const {
      username,
      password,
    } = request.data;

    const winner = yield effects.race({
      auth: effects.call(authorize, {
        username,
        password,
        isRegistering: false,
      }),
      logout: effects.take(LOGOUT),
    });

    if (winner.auth) {
      yield effects.put({
        type: SET_AUTH,
        newAuthState: true,
      });
      yield effects.put({
        type: CHANGE_FORM,
        newFormState: {
          username: '',
          password: '',
        },
      });
    }
  }
}

/**
 * Log out saga
 */
export function* logoutFlow() {
  while (true) {
    yield effects.take(LOGOUT);
    yield effects.put({
      type: SET_AUTH,
      newAuthState: false,
    });

    yield effects.call(logout);
  }
}

/**
 * Register saga
 */
export function* registerFlow() {
  while (true) {
    const request = yield effects.take(REGISTER_REQUEST);
    const {
      username,
      password,
    } = request.data;

    const wasSuccessful = yield effects.call(authorize, {
      username,
      password,
      isRegistering: true,
    });

    if (wasSuccessful) {
      yield effects.put({
        type: SET_AUTH,
        newAuthState: true,
      });
      yield effects.put({
        type: CHANGE_FORM,
        newFormState: {
          username: '',
          password: '',
        },
      });
    }
  }
}

export default function* root() {
  yield effects.fork(loginFlow);
  yield effects.fork(logoutFlow);
  yield effects.fork(registerFlow);
}
