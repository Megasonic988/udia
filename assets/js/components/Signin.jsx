import React, { Component } from 'react';
import { connect } from 'react-redux';
import { func, shape, string } from 'prop-types';
import { Button, Form, Input, Message } from 'semantic-ui-react';
import { changeForm, loginRequest } from '../actions';

const propTypes = {
  dispatch: func,
  data: shape({
    formState: shape({
      username: string,
      password: string,
    }),
  }),
};

const defaultProps = {
  dispatch: () => { },
  data: {
    formState: {
      username: '',
      password: '',
    },
  },
};

class Signin extends Component {
  onSubmit = (event) => {
    event.preventDefault();
    this.props.dispatch(loginRequest({
      username: this.props.data.formState.username,
      password: this.props.data.formState.password,
    }));
  }

  changeUsername = (event) => {
    this.emitChange(
      { ...this.props.data.formState, username: event.target.value },
    );
  }

  changePassword = (event) => {
    this.emitChange(
      { ...this.props.data.formState, password: event.target.value },
    );
  }

  emitChange = (newFormState) => {
    this.props.dispatch(changeForm(newFormState));
  }

  render = () => {
    const { currentlySending, error } = this.props.data;

    console.log('signin');
    console.log(this.props);

    return (
      <div>
        <h2>Signin</h2>
        <Form onSubmit={this.onSubmit} loading={currentlySending} error={!!error}>
          <Form.Field>
            <Input
              label="Username" type="text" placeholder="username"
              onChange={this.changeUsername}
              value={this.props.data.formState.username}
            />
          </Form.Field>
          <Form.Field>
            <Input
              label="Password" type="password" placeholder="••••••••••"
              onChange={this.changePassword}
              value={this.props.data.formState.password}
            />
          </Form.Field>
          {!!error && <Message
            error={!!error}
            header={'Login Failed'}
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

// Which props do we want to inject, given the global state?
function select(state) {
  return {
    data: state,
  };
}

// Wrap the component to inject dispatch and state into it
export default connect(select)(Signin);
