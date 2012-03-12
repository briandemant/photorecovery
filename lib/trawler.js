(function() {
  var EventEmitter2, Globber, Trawler, image_ident, path, sprintf,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __slice = Array.prototype.slice;

  EventEmitter2 = require('eventemitter2').EventEmitter2;

  Globber = require("./globber");

  image_ident = require('./image-ident');

  path = require('path');

  sprintf = require('sprintf').sprintf;

  Trawler = (function(_super) {

    __extends(Trawler, _super);

    function Trawler() {
      var roots,
        _this = this;
      roots = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.roots = roots;
      this.glob = (function(func, args, ctor) {
        ctor.prototype = func.prototype;
        var child = new ctor, result = func.apply(child, args);
        return typeof result === "object" ? result : child;
      })(Globber, this.roots, function() {});
      this.glob.lookfor(/\.jpg$/i);
      this.glob.on("match", function(filepath, stat, root) {
        return _this.get_image_info(filepath, stat, root);
      });
    }

    Trawler.prototype.get_image_info = function(filepath, stat, root) {
      var _this = this;
      return image_ident.info(path.join(root, filepath), function(err, data) {
        if (err) console.log(err);
        if (err) _this.emit("error.import_image", err);
        return console.log(sprintf("%s %4d x %4d %s", data["md5"], data["info"]['height'], data["info"]['width'], filepath));
      });
    };

    Trawler.prototype.run = function() {
      return this.glob.execute();
    };

    return Trawler;

  })(EventEmitter2);

  module.exports = Trawler;

}).call(this);
