(function() {
  var EventEmitter2, Globber, Trawler, image_ident, path,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __slice = Array.prototype.slice;

  EventEmitter2 = require('eventemitter2').EventEmitter2;

  Globber = require("./globber");

  image_ident = require('image-ident');

  path = require('path');

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
        return _this.import_image(filepath, stat, root);
      });
    }

    Trawler.prototype.import_image = function(filepath, stat, root) {
      var _this = this;
      return image_ident.info(path.join(root, filepath), function(err, data) {
        if (err) console.log(err);
        if (err) _this.emit("error.import_image", err);
        console.log("");
        console.log(path.join(root, filepath));
        return console.log(data);
      });
    };

    Trawler.prototype.run = function() {
      return this.glob.execute(function() {
        return console.log("done!");
      });
    };

    return Trawler;

  })(EventEmitter2);

  module.exports = Trawler;

}).call(this);
