import React from 'react';
import { Route, Link, Switch } from 'react-router-dom'

import Navbar from './Navbar';
import Login from './Auth/Login';
import Signup from './Auth/Signup';

const Home = () => (
  <div>
    <h2>Home</h2>
  </div>
);

const About = () => (
  <div>
    <h2>About</h2>
  </div>
);

const Topics = ({ match }) => (
  <div>
    <h2>Topics</h2>
    <ul>
      <li>
        <Link to={`${match.url}/rendering`}>
          Rendering with React
        </Link>
      </li>
      <li>
        <Link to={`${match.url}/components`}>
          Components
        </Link>
      </li>
      <li>
        <Link to={`${match.url}/props-v-state`}>
          Props v. State
        </Link>
      </li>
    </ul>

    <Route path={`${match.url}/:topicId`} component={Topic} />
    <Route exact path={match.url} render={() => (
      <h3>Please select a topic.</h3>
    )} />
  </div>
);

const Topic = ({ match }) => (
  <div>
    <h3>{match.params.topicId}</h3>
  </div>
);

const NoMatch = ({ location }) => (
  <div>
    <h3>Page not found</h3>
    <p>No match for <code>{location.pathname}</code></p>
    <p><Link to="/">Go to the home page →</Link></p>
  </div>
);

const BasicExample = () => (<div>
  <Navbar />
  <Switch>
    <Route exact path="/" component={Home} />
    <Route path="/about" component={About} />
    <Route path="/topics" component={Topics} />
    <Route path="/login" component={Login} />
    <Route path="/signup" component={Signup} />
    <Route component={NoMatch} />
  </Switch>
</div>);

export default class App extends React.Component {
  render() {
    return (<BasicExample />);
  }
}
