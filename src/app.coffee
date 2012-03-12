#
# see [Globber](globber.html)
#
# see [Trawler](trawler.html)
Trawler = require("./trawler.coffee")
path = require("path")

[x,x,dirs...] = process.argv

console.log dirs

trawler = new Trawler dirs...
# execute!
# --------
# do the stuff!
trawler.run()
