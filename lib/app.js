(function() {
  var Trawler, dirs, path, trawler, x, _ref,
    __slice = Array.prototype.slice;

  Trawler = require("./trawler.coffee");

  path = require("path");

  _ref = process.argv, x = _ref[0], x = _ref[1], dirs = 3 <= _ref.length ? __slice.call(_ref, 2) : [];

  console.log(dirs);

  trawler = (function(func, args, ctor) {
    ctor.prototype = func.prototype;
    var child = new ctor, result = func.apply(child, args);
    return typeof result === "object" ? result : child;
  })(Trawler, dirs, function() {});

  trawler.run();

}).call(this);
