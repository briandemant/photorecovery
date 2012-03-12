(function() {
  var exec;

  exec = require('child_process').exec;

  exports.read = function(path, callback) {
    return exec("exiftags -avuqs '|' '" + path + "'", function(err, stdout, stderr) {
      var day, key, line, lines, month, parts, result, time, value, x, year, _i, _len, _ref;
      if (stdout) {
        lines = stdout.split("\n");
        result = {};
        for (_i = 0, _len = lines.length; _i < _len; _i++) {
          line = lines[_i];
          _ref = line.split('|'), key = _ref[0], value = _ref[1];
          if (!value) continue;
          if (value.match(/^\d+$/)) {
            value = parseInt(value);
          } else if (value.match(/^\d+\.\d+$/)) {
            value = parseFloat(value);
          } else if (parts = value.match(/^(\d+):(\d+):(\d+)\s+(\d+:\d+:\d+)$/)) {
            x = parts[0], year = parts[1], month = parts[2], day = parts[3], time = parts[4];
            value = new Date("" + year + "-" + month + "-" + day + " " + time);
          }
          result[key] = value;
        }
        return callback(null, result);
      } else if (stderr) {
        return callback({
          type: "stderr",
          message: stderr
        });
      } else if (err) {
        return callback({
          type: "error",
          message: err
        });
      }
    });
  };

}).call(this);
