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
  SET_USER,
  LOGOUT,
  REQUEST_ERROR
} from '../actions/constants';

import { me, signup, signin, signout } from '../auth';

export function* register({
  username,
  password
}) {
  yield effects.put({
    type: SENDING_REQUEST,
    sending: true
  });

  try {
    return yield effects.call(signup, username, password);
  } catch (exception) {
    yield effects.put({
      type: REQUEST_ERROR,
      error: exception.errors
    });
    return false;
  } finally {
    yield effects.put({
      type: SENDING_REQUEST,
      sending: false
    });
  }
}

export function* login({
  username,
  password
}) {
  yield effects.put({
    type: SENDING_REQUEST,
    sending: true
  });

  try {
    return yield effects.call(signin, username, password);
  } catch (exception) {
    yield effects.put({
      type: REQUEST_ERROR,
      error: exception.error
    });
    return false;
  } finally {
    yield effects.put({
      type: SENDING_REQUEST,
      sending: false
    });
  }
}

/**
 * Effect to handle logging out
 */
export function* logout() {
  yield effects.put({
    type: SENDING_REQUEST,
    sending: true
  });

  try {
    const response = yield effects.call(signout);
    return response;
  } catch (error) {
    yield effects.put({
      type: REQUEST_ERROR,
      error: error.message
    });
    return false;
  } finally {
    yield effects.put({
      type: SENDING_REQUEST,
      sending: false
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
      password
    } = request.data;

    const winner = yield effects.race({
      auth: effects.call(login, {
        username,
        password
      }),
      logout: effects.take(LOGOUT)
    });

    if (winner.auth) {
      yield effects.put({
        type: SET_AUTH,
        newAuthState: true
      });
      yield effects.put({
        type: SET_USER,
        newUserState: me()
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
      newAuthState: false
    });
    yield effects.put({
      type: SET_USER,
      newUserState: me()
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
      password
    } = request.data;

    const wasSuccessful = yield effects.call(register, {
      username,
      password
    });

    if (wasSuccessful) {
      yield effects.put({
        type: SET_AUTH,
        newAuthState: true
      });
      yield effects.put({
        type: SET_USER,
        newUserState: me()
      });
    }
  }
}

export default function* root() {
  yield effects.fork(loginFlow);
  yield effects.fork(logoutFlow);
  yield effects.fork(registerFlow);
}
