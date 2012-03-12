(function() {
  var env;

  env = {
    replace_env: function() {
      var secret_conf;
      secret_conf = require('nconf');
      secret_conf.argv({
        'about': {
          description: 'Provide some details about the author of this program',
          required: true,
          short: 'a'
        },
        'info': {
          description: 'Provide some information about the node.js agains!!!!!!',
          boolean: true,
          short: 'i'
        }
      }).env().file({
        file: __dirname + '/../config/config.json'
      });
      return env = {
        get: function(key) {
          return secret_conf.get(key);
        }
      };
    },
    get: function(key) {
      env.replace_env();
      return env.get(key);
    }
  };

  console.log(env.get('info'));

  console.log(env.get('about'));

}).call(this);
