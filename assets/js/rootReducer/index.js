import {
  combineReducers,
} from 'redux';

function stubReducer(state = {}, action) {
  switch (action.type) {
    default: return state;
  }
}

const rootReducer = combineReducers({
  stubReducer,
});

export default rootReducer;
