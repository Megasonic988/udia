import React, { Component } from 'react';
import { func } from 'prop-types';

const propTypes = {
  onSubmit: func.isRequired,
};

class SignupForm extends Component {
  render() {
    return (<div>
      <p>Signup Form Stub</p>
    </div>);
  }
}

SignupForm.propTypes = propTypes;

export default SignupForm;
