import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bool, func, string } from 'prop-types';
import { Button, Form, Input, Message } from 'semantic-ui-react';
import { clearError, loginRequest } from '../actions';

const propTypes = {
  dispatch: func,
  currentlySending: bool,
  error: string
};

const defaultProps = {
  dispatch: () => { },
  currentlySending: false,
  error: ''
};

class Signin extends Component {
  constructor(props) {
    super(props);
    this.state = {
      username: '',
      password: ''
    };

    this.props.dispatch(clearError());
  }

  onSubmit = (event) => {
    event.preventDefault();

    this.props.dispatch(loginRequest({
      username: this.state.username,
      password: this.state.password
    }));
  }

  changeUsername = (event) => {
    this.setState({ username: event.target.value });
  }

  changePassword = (event) => {
    this.setState({ password: event.target.value });
  }

  render = () => {
    const { currentlySending, error } = this.props;

    return (
      <div>
        <h2>Signin</h2>
        <Form onSubmit={this.onSubmit} loading={currentlySending} error={!!error}>
          <Form.Field>
            <Input
              label="Username" type="text" placeholder="username"
              onChange={this.changeUsername}
              value={this.state.username}
            />
          </Form.Field>
          <Form.Field>
            <Input
              label="Password" type="password" placeholder="••••••••••"
              onChange={this.changePassword}
              value={this.state.password}
            />
          </Form.Field>
          {!!error && <Message
            error={!!error}
            header={'Signin Failed'}
            content={error}
          />}
          <Button type="submit">Submit</Button>
        </Form>
      </div>
    );
  }
}

Signin.propTypes = propTypes;
Signin.defaultProps = defaultProps;

function mapStateToProps(state) {
  return state;
}

export default connect(mapStateToProps)(Signin);
