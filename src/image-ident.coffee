exiftags = require './exiftags'
fs = require 'fs'
exec = require('child_process').exec

exports.info = (path, callback) ->
	fs.stat path, (err, stats) ->
		if err
			callback err
		else
			exec "md5sum '" + path + "'", (error, md5) ->
				console.log error if error
				exec "identify -format '%w %h %q %Q ' '" + path + "'", (error, info) ->
					console.log error if error
					[width, height, color, quality] = info.split(" ")
					exiftags.read path, (err, result) ->
						callback null,
								'stats'    :
									'size' : stats['size']
									'mtime': stats['mtime']
									'ctime': stats['ctime']
								'md5'      : md5.split(" ")[0]
								'info'     :
									'width'     : width|0
									'height'    : height|0
									'colorspace': color|0
									'quality'   : quality|0
								'exif-data': (result || false)
exports.basic = (path, callback) ->
	fs.stat path, (err, stats) ->
		if err
			callback err
		else
			exec "md5sum '" + path + "'", (error, md5) ->
				console.log error if error
				callback null,
						'stats'    :
							'size' : stats['size']
							'mtime': stats['mtime']
							'ctime': stats['ctime']
						'md5'      : md5.split(" ")[0]
