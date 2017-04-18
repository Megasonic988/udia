import 'babel-polyfill';
import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter } from 'react-router-dom';
import { createStore, applyMiddleware } from 'redux';
import createSagaMiddleware from 'redux-saga';
import { Provider } from 'react-redux';
import { createLogger } from 'redux-logger';

import './socket';
import reducer from './reducers';
import rootSaga from './sagas';
import App from './components/App';

const logger = createLogger({
  predicate: (getState, action) => action.type !== 'CHANGE_FORM'
});

const sagaMiddleware = createSagaMiddleware();

const store = createStore(reducer, applyMiddleware(logger, sagaMiddleware));
sagaMiddleware.run(rootSaga);

if (module.hot) {
  module.hot.accept('./reducers', () => {
    store.replaceReducer(reducer);
  });
}

const supportsHistory = 'pushState' in window.history;

ReactDOM.render(
  // eslint-disable-next-line react/jsx-filename-extension
  <Provider store={store}>
    <BrowserRouter forceRefresh={!supportsHistory}>
      <App />
    </BrowserRouter>
  </Provider>,
  document.getElementById('app'),
);
