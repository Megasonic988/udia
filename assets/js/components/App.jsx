import React from 'react';
import { Route, Link, Switch } from 'react-router-dom';
import { string, shape } from 'prop-types';

import Navbar from './Navbar';
import Signin from './Signin';
import Signup from './Signup';
import Profile from './Profile';

const Home = () => (
  <div>
    <h2>Home</h2>
    <p>This is the home page.</p>
  </div>
);

const About = () => (
  <div>
    <h2>About</h2>
    <p>This is an about page.</p>
  </div>
);

const NoMatch = ({ location }) => (
  <div>
    <h3>Page not found</h3>
    <p>No match for <code>{location.pathname}</code></p>
    <p><Link to="/">Go to the home page →</Link></p>
  </div>
);

NoMatch.propTypes = {
  location: shape({
    pathname: string.isRequired
  }).isRequired
};

const App = () => (<div>
  <Navbar />
  <Switch>
    <Route exact path="/" component={Home} />
    <Route path="/about" component={About} />
    <Route path="/signin" component={Signin} />
    <Route path="/signup" component={Signup} />
    <Route path="/profile" component={Profile} />
    <Route component={NoMatch} />
  </Switch>
</div>);

export default App;
