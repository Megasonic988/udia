// Copyright 2016 Udia Software Incorporated
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

'use strict';

// Hierarchical node.js configuration with command-line arguments, environment
// variables, and files.
var nconf = module.exports = require('nconf');
var path = require('path');
try {
  var env = require('./env');
} catch (ex) {
  // If the env file doesn't exist, this might be a warning
  console.warn('Local ./env.js file does not exist.');
}

// Memcache configuration settings
var MEMCACHE_HOST = process.env.MEMCACHE_PORT_11211_TCP_ADDR || 'localhost';
var MEMCACHE_PORT = process.env.MEMCACHE_PORT_11211_TCP_PORT || 11211;

nconf
// 1. Command-line arguments
  .argv()
  // 2. Environment variables
  .env([
    'CLOUD_BUCKET',
    'DATA_BACKEND',
    'GCLOUD_PROJECT',
    'MONGO_URL',
    'MONGO_COLLECTION',
    'MYSQL_USER',
    'MYSQL_PASSWORD',
    'MYSQL_HOST',
    'NODE_ENV',
    'OAUTH2_CLIENT_ID',
    'OAUTH2_CLIENT_SECRET',
    'OAUTH2_CALLBACK',
    'PORT',
    'SECRET',
    'SUBSCRIPTION_NAME',
    'TOPIC_NAME'
  ])
  // 3. Config file
  .file({file: path.join(__dirname, 'config.json')})
  // 4. Defaults
  .defaults({
    // Typically you will create a bucket with the same name as your project ID.
    CLOUD_BUCKET: process.env.CLOUD_BUCKET || env.CLOUD_BUCKET || '',

    // dataBackend can be 'datastore', 'cloudsql', or 'mongodb'. Be sure to
    // configure the appropriate settings for each storage engine below.
    // If you are unsure, use datastore as it requires no additional
    // configuration.
    DATA_BACKEND: process.env.DATA_BACKEND || env.DATA_BACKEND || 'datastore',

    // This is the id of your project in the Google Cloud Developers Console.
    GCLOUD_PROJECT: process.env.GCLOUD_PROJECT || env.GCLOUD_PROJECT || '',

    // Connection url for the Memcache instance used to store session data
    MEMCACHE_URL: MEMCACHE_HOST + ':' + MEMCACHE_PORT,

    // MongoDB connection string
    // https://docs.mongodb.org/manual/reference/connection-string/
    MONGO_URL: 'mongodb://localhost:27017',
    MONGO_COLLECTION: 'books',

    MYSQL_USER: '',
    MYSQL_PASSWORD: '',
    MYSQL_HOST: '',

    OAUTH2_CLIENT_ID: process.env.OAUTH2_CLIENT_ID || env.OAUTH2_CLIENT_ID || '',
    OAUTH2_CLIENT_SECRET: process.env.OAUTH2_CLIENT_SECRET || env.OAUTH2_CLIENT_SECRET || '',
    OAUTH2_CALLBACK: 'http://localhost:8080/auth/google/callback',

    // Port the HTTP server
    PORT: 8080,

    SECRET: 'keyboardcat',

    SUBSCRIPTION_NAME: 'shared-worker-subscription',
    TOPIC_NAME: 'book-process-queue'
  });

// Check for required settings
checkConfig('GCLOUD_PROJECT');
checkConfig('CLOUD_BUCKET');
checkConfig('OAUTH2_CLIENT_ID');
checkConfig('OAUTH2_CLIENT_SECRET');

if (nconf.get('DATA_BACKEND') === 'cloudsql') {
  checkConfig('MYSQL_USER');
  checkConfig('MYSQL_PASSWORD');
  checkConfig('MYSQL_HOST');
} else if (nconf.get('DATA_BACKEND') === 'mongodb') {
  checkConfig('MONGO_URL');
  checkConfig('MONGO_COLLECTION');
}

function checkConfig(setting) {
  if (!nconf.get(setting)) {
    throw new Error('You must set the ' + setting + ' environment variable or' +
      ' add it to config.json!');
  }
}
