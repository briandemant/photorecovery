Trawler = require("./trawler.coffee")
path = require("path")


trawler = new Trawler path.join(__dirname, '..', 'spec', 'fixtures', 'two'),
		path.join(__dirname, '..', 'spec', 'fixtures', 'one')

trawler.run()