import React, { Component } from 'react';
import { func } from 'prop-types';

const propTypes = {
  onSubmit: func.isRequired,
};

class LoginForm extends Component {
  render() {
    return (<form>
      <h3>Login</h3>
      <p>stub</p>
      <label>Username</label>
      <input type="text" placeholder="Username" />
      <label>Password</label>
      <input type="password" placeholder="Password" />
      <button type="submit">Submit</button>
    </form>);
  }
}

LoginForm.propTypes = propTypes;

export default LoginForm;
