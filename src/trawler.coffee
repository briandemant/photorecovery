{EventEmitter2} = require('eventemitter2')
Globber = require("./globber")
image_ident = require('./image-ident')
path = require('path')
sprintf = require('sprintf').sprintf

class Trawler extends EventEmitter2
	constructor: (@roots...)->
		@glob = new Globber @roots...
		@glob.lookfor(/\.jpg$/i)
		@glob.on "match", (filepath, stat, root) =>
			@get_image_info(filepath, stat, root)


	get_image_info: (filepath, stat, root) ->
		image_ident.info path.join(root, filepath), (err, data) =>
			console.log(err) if err
			@emit("error.import_image", err) if err
				#console.log ""
			console.log sprintf("%s %4d x %4d %s", data["md5"],data["info"]['height'],data["info"]['width'],filepath)

	#console.log data

	run: ->
		@glob.execute()

module.exports = Trawler
