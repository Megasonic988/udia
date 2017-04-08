import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { login } from '../../actions/session';
import LoginForm from './LoginForm';

const propTypes = {
  login: PropTypes.func,
};

const defaultProps = {
  login: () => {},
};

class Login extends Component {
  render() {
    return <LoginForm onSubmit={this.props.login} />;
  }
}

Login.propTypes = propTypes;
Login.defaultProps = defaultProps;

export default connect(null, { login })(Login);
