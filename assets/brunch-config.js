exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: 'js/app.js',
    },
    stylesheets: {
      joinTo: 'css/app.css',
    },
    templates: {
      joinTo: 'js/app.js',
    },
  },

  conventions: {
    assets: /^(static)/,
  },

  paths: {
    watched: ['static', 'css', 'js', 'vendor'],
    public: '../priv/static',
  },

  plugins: {
    babel: {
      presets: ['env', 'stage-1', 'react'],
      ignore: [/vendor/],
    },
  },

  modules: {
    autoRequire: {
      'js/app.js': ['js/index'],
    },
  },

  npm: {
    enabled: true,
  },

  // Hot module reloading
  hot: true,
};
