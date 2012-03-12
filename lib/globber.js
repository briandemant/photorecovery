(function() {
  var EventEmitter2, Globber, fs, path,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __slice = Array.prototype.slice;

  EventEmitter2 = require('eventemitter2').EventEmitter2;

  fs = require("fs");

  path = require("path");

  Globber = (function(_super) {

    __extends(Globber, _super);

    function Globber() {
      var roots;
      roots = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.roots = roots;
      this.taverse_dir = __bind(this.taverse_dir, this);
      this.debug = false;
      this.used = false;
      this.matchers = [];
      this.on("file", function(file, stat, root) {
        var _this = this;
        if (this.matchers.length === 0) {
          return this.emit("match", file, stat, root);
        } else {
          return this.matchers.forEach(function(regex) {
            if (file.match(regex)) {
              return _this.emit("match", file, stat, root, regex);
            }
          });
        }
      });
    }

    Globber.prototype.lookfor = function(regex) {
      return this.matchers.push(regex);
    };

    Globber.prototype.taverse_dir = function(root, dir, done) {
      var _this = this;
      this.left++;
      if (this.debug) console.log("dir >> " + dir);
      return fs.readdir(dir, function(err, files) {
        if (err) {
          _this.emit("error", {
            path: dir,
            error: err
          });
        }
        if (_this.debug) console.log(" len " + files.length);
        _this.left += files.length;
        files.forEach(function(file, index) {
          var fullpath;
          fullpath = path.join(dir, file);
          if (_this.debug) console.log(" - " + fullpath);
          return fs.stat(fullpath, function(err, stat) {
            if (stat.isDirectory()) {
              _this.taverse_dir(root, fullpath, done);
              _this.emit("dir", path.relative(root, fullpath), stat, root);
            } else {
              _this.emit("file", path.relative(root, fullpath), stat, root);
            }
            return done();
          });
        });
        return done();
      });
    };

    Globber.prototype.execute = function(done) {
      var root, _i, _len, _ref, _results,
        _this = this;
      if (done == null) done = function() {};
      if (this.used) throw "Cannot reuse a Globber please make a new";
      this.used = true;
      this.left = 0;
      _ref = this.roots;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        root = _ref[_i];
        _results.push((function(root) {
          root = path.normalize(root);
          return fs.stat(root, function(err, stat) {
            if (_this.debug) console.log("root >> " + root);
            if (stat.isDirectory()) {
              _this.taverse_dir(root, root, function() {
                if (--_this.left === 0) {
                  _this.emit("done");
                  return done();
                }
              });
              return _this.emit("dir", ".", stat, root);
            } else {
              return _this.emit("file", path.basename(root), stat, path.dirname(root));
            }
          });
        })(root));
      }
      return _results;
    };

    return Globber;

  })(EventEmitter2);

  module.exports = Globber;

}).call(this);
