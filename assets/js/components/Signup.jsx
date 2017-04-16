import React, { Component } from 'react';
import { connect } from 'react-redux';
import { func, shape, string } from 'prop-types';
import { Button, Form, Input, Message } from 'semantic-ui-react';
import { clearError, registerRequest } from '../actions';

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

class Signup extends Component {
  constructor(props) {
    super(props);
    this.state = {
      username: '',
      password: '',
    };

    this.props.dispatch(clearError());
  }

  onSubmit = (event) => {
    event.preventDefault();
    this.props.dispatch(registerRequest({
      username: this.state.username,
      password: this.state.password,
    }));
  }

  changeUsername = (event) => {
    this.setState({ username: event.target.value });
  }

  changePassword = (event) => {
    this.setState({ password: event.target.value });
  }

  render() {
    const { currentlySending, error } = this.props.data;

    return (
      <div>
        <h2>Signup</h2>
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
            header="Signup Failed"
            list={Object.keys(error).map(p => <Message.Item key={p} >{p} {error[p]}</Message.Item>)}
          />}
          <Button type="submit">Submit</Button>
        </Form>
      </div>
    );
  }
}

Signup.propTypes = propTypes;
Signup.defaultProps = defaultProps;

function select(state) {
  return {
    data: state,
  };
}

export default connect(select)(Signup);
