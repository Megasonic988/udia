import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import { Menu } from 'semantic-ui-react';

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
      <Menu.Item
        as={Link}
        to="/login"
        name="login"
        active={activeItem === 'login'}
        onClick={this.handleItemClick}
      >
        Login
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
    </Menu>);
  }
}

export default Navbar;
