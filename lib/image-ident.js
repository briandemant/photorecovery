(function() {
  var exec, exiftags, fs;

  exiftags = require('./exiftags');

  fs = require('fs');

  exec = require('child_process').exec;

  exports.info = function(path, callback) {
    return fs.stat(path, function(err, stats) {
      if (err) {
        return callback(err);
      } else {
        return exec("md5sum '" + path + "'", function(error, md5) {
          if (error) console.log(error);
          return exec("identify -format '%w %h %q %Q ' '" + path + "'", function(error, info) {
            var color, height, quality, width, _ref;
            if (error) console.log(error);
            _ref = info.split(" "), width = _ref[0], height = _ref[1], color = _ref[2], quality = _ref[3];
            return exiftags.read(path, function(err, result) {
              return callback(null, {
                'stats': {
                  'size': stats['size'],
                  'mtime': stats['mtime'],
                  'ctime': stats['ctime']
                },
                'md5': md5.split(" ")[0],
                'info': {
                  'width': width | 0,
                  'height': height | 0,
                  'colorspace': color | 0,
                  'quality': quality | 0
                },
                'exif-data': result || false
              });
            });
          });
        });
      }
    });
  };

  exports.basic = function(path, callback) {
    return fs.stat(path, function(err, stats) {
      if (err) {
        return callback(err);
      } else {
        return exec("md5sum '" + path + "'", function(error, md5) {
          if (error) console.log(error);
          return callback(null, {
            'stats': {
              'size': stats['size'],
              'mtime': stats['mtime'],
              'ctime': stats['ctime']
            },
            'md5': md5.split(" ")[0]
          });
        });
      }
    });
  };

}).call(this);
