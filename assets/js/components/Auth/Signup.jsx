import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { signup } from '../../actions/session';
import SignupForm from './SignupForm';

const propTypes = {
  signup: PropTypes.func,
};

const defaultProps = {
  signup: () => {},
};

class Signup extends Component {
  render() {
    return <SignupForm onSubmit={this.props.signup} />;
  }
}

Signup.propTypes = propTypes;
Signup.defaultProps = defaultProps;

export default connect(null, { signup })(Signup);
