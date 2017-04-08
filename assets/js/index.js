import 'phoenix_html';

import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter } from 'react-router-dom';
import { createStore } from 'redux';
import { Provider } from 'react-redux';

import './socket';
import App from './components/App';

import rootReducer from './rootReducer';

const store = createStore(rootReducer);

if (module.hot) {
  module.hot.accept('./reducers', () => {
    store.replaceReducer(rootReducer);
  });
}

ReactDOM.render(
  // eslint-disable-next-line react/jsx-filename-extension
  <Provider store={store}>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </Provider>,
  document.getElementById('app'),
);
