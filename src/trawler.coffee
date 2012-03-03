{EventEmitter2} = require('eventemitter2')
Globber = require("./globber")
image_ident = require('image-ident')
path = require('path')

class Trawler extends EventEmitter2
	constructor: (@roots...)->
		@glob = new Globber @roots...
		@glob.lookfor(/\.jpg$/i)
		@glob.on "match", (filepath, stat, root) =>
			@import_image(filepath, stat, root)


	import_image: (filepath, stat, root) ->
		image_ident.info path.join(root, filepath), (err, data) =>
			console.log(err) if err
			@emit("error.import_image", err) if err
			console.log ""
			console.log path.join(root, filepath)
			console.log data

	run: ->
		@glob.execute(-> console.log "done!")

module.exports = Trawler
