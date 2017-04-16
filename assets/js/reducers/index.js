import {
  SET_AUTH,
  SENDING_REQUEST,
  REQUEST_ERROR,
  CLEAR_ERROR,
} from '../actions/constants';
import { signedIn } from '../auth';

// The initial application state
const initialState = {
  error: '',
  currentlySending: false,
  loggedIn: signedIn(),
};

// Takes care of changing the application state
function reducer(state = initialState, action) {
  switch (action.type) {
    case SET_AUTH:
      return { ...state,
        loggedIn: action.newAuthState,
      };
    case SENDING_REQUEST:
      return { ...state,
        currentlySending: action.sending,
      };
    case REQUEST_ERROR:
      return { ...state,
        error: action.error,
      };
    case CLEAR_ERROR:
      return { ...state,
        error: '',
      };
    default:
      return state;
  }
}

export default reducer;
