import React, { Component } from 'react';
import { connect } from 'react-redux';

class Profile extends Component {
  render = () => {
    return (
      <div>
        <h2>Profile</h2>
      </div>
    );
  }
}

function mapStateToProps(state) {
  return state;
}

export default connect(mapStateToProps)(Profile);
