import React, { Component } from 'react';
import { connect } from 'react-redux';

import { loginRequest } from '../actions';

class Signin extends Component {
  constructor(props) {
    super(props);

    this._login = this._login.bind(this);
  }

  render() {
    const { dispatch } = this.props;
    const { formState, currentlySending, error } = this.props.data;

    return (
      <div>
        <h2>Login</h2>
        <form data={formState} dispatch={dispatch} history={this.props.history} onSubmit={this._login} btnText={'Login'} error={error} currentlySending={currentlySending} />
      </div>
    );
  }

  _login(username, password) {
    this.props.dispatch(loginRequest({ username, password }));
  }
}

Signin.propTypes = {
  data: React.PropTypes.object,
  history: React.PropTypes.object,
  dispatch: React.PropTypes.func,
};

// Which props do we want to inject, given the global state?
function select(state) {
  return {
    data: state,
  };
}

// Wrap the component to inject dispatch and state into it
export default connect(select)(Signin);
