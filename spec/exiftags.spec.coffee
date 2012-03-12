expect = require 'expect.js'
exiftags = require '../src/exiftags.coffee'

describe 'exiftags', ->
	it 'should export a read function', ->
		expect(exiftags.read).to.be.a('function')

describe 'get tags for valid image', ->
	it 'should call callback with tags', (done) ->
		exiftags.read __dirname + '/fixtures/one/map.jpg', (err, data)->
			expect(err).to.be(null)
			expect(data).to.eql
					'Camera Software'        : 'Adobe Photoshop CS3 Windows',
					'Image Orientation'      : 'Top, Left-Hand',
					'Horizontal Resolution'  : '72 dpi',
					'Vertical Resolution'    : '72 dpi',
					'Image Created'          : new Date('2007-09-19 14:04:30'),
					'Color Space Information': 'Uncalibrated',
					'Image Width'            : 6400,
					'Image Height'           : 3200,
					'Resolution Unit'        : 'i',
					'Exif IFD Pointer'       : 164,
					'Compression Scheme'     : 'JPEG Compression (Thumbnail)',
					'Offset to JPEG SOI'     : 302,
					'Bytes of JPEG Data'     : 4608
		done()

describe 'get tags for non existing path', ->
	it 'should call callback with error', (done) ->
		exiftags.read 'xxx.jpg', (err, data)->
			expect(err).to.eql
					type   : 'stderr'
					message: "exiftags: No such file or directory (xxx.jpg)\n"
			expect(data).to.be(undefined)
			done()

describe 'get tags for image without exifdata', ->
	it 'should call callback with stderr', (done) ->
		exiftags.read __dirname + '/fixtures/one/noexif.jpg', (err, data)->
			expect(err).to.eql
					type   : 'stderr'
					message: "exiftags: couldn't find Exif data\n"
			expect(data).to.be(undefined)
			done()
