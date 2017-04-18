import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bool } from 'prop-types';
import { Link } from 'react-router-dom';
import { Menu } from 'semantic-ui-react';

const propTypes = {
  loggedIn: bool
};

const defaultProps = {
  loggedIn: false
};

class Navbar extends Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  handleItemClick = (e, { name }) => {
    this.setState({ activeItem: name });
  }

  render() {
    const { activeItem } = this.state;
    const { loggedIn } = this.props;

    return (<Menu>
      <Menu.Item
        as={Link}
        to="/"
        name="home"
        active={activeItem === 'home'}
        onClick={this.handleItemClick}
      >
        Home
      </Menu.Item>
      <Menu.Item
        as={Link}
        to="/about"
        name="about"
        active={activeItem === 'about'}
        onClick={this.handleItemClick}
      >
        About
      </Menu.Item>
      {loggedIn && <Menu.Menu position="right">
        <Menu.Item
          as={Link}
          to="/profile"
          name="profile"
          active={activeItem === 'profile'}
          onClick={this.handleItemClick}
        >
          My Profile
        </Menu.Item>
      </Menu.Menu>}
      {!loggedIn && <Menu.Menu position="right">
        <Menu.Item
          as={Link}
          to="/signin"
          name="signin"
          active={activeItem === 'signin'}
          onClick={this.handleItemClick}
        >
          Signin
        </Menu.Item>
        <Menu.Item
          as={Link}
          to="/signup"
          name="signup"
          active={activeItem === 'signup'}
          onClick={this.handleItemClick}
        >
          Signup
        </Menu.Item>
      </Menu.Menu>}
    </Menu>);
  }
}

Navbar.propTypes = propTypes;
Navbar.defaultProps = defaultProps;

function mapStateToProps(state) {
  return state;
}

export default connect(mapStateToProps)(Navbar);
