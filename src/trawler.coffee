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
			@get_basic_info(filepath, stat, root)


	get_basic_info: (filepath, stat, root) ->
		image_ident.basic path.join(root, filepath), (err, data) =>
			console.log(err) if err
			@emit("error.import_image", err) if err
			#console.log ""
			console.log sprintf("%s %s %s", data["md5"], root, filepath)

	#console.log data

	run: ->
		@glob.execute()

[x,x,dirs...] = process.argv 
trawler = new Trawler dirs...
trawler.run()
