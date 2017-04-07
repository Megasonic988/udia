import React, { Component, PropTypes } from 'react';

const propTypes = {
  onSubmit: PropTypes.func.isRequired
}

class SignupForm extends Component {
  render() {
    return (<div>
      <p>Signup Form Stub</p>
    </div>)
  }
}

SignupForm.propTypes = propTypes;

export default SignupForm;
