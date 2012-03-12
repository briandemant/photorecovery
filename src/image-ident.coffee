exiftags = require './exiftags'
fs = require 'fs'
exec = require('child_process').exec

exports.info = (path, callback) ->
	exports.basic path, (err, data)->
		return callback err if err
		exec "identify -format '%w %h %q %Q ' '" + path + "'", (error, info) ->
			console.log error if error
			[width, height, color, quality] = info.split(" ")
			exiftags.read path, (err, result) ->
				data['info'] =
					'width'     : width | 0
					'height'    : height | 0
					'colorspace': color | 0
					'quality'   : quality | 0
				data['exif-data'] = (result || false)

				callback null, data

exports.basic = (path, callback) ->
	fs.stat path, (err, stats) ->
		if err
			callback err
		else
			exec "md5sum '" + path + "'", (error, md5) ->
				console.log error if error
				callback null,
						'stats':
							'size' : stats['size']
							'mtime': stats['mtime']
							'ctime': stats['ctime']
						'md5'  : md5.split(" ")[0]
