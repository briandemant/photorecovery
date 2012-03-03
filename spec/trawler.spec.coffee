expect = require 'expect.js'
trawler = require '../src/trawler.coffee'

describe 'exiftags.spec.coffee', ->
	it 'should export a tags function', ->
		expect(image_ident.info).not.to.be(undefined)
		expect(image_ident.info).to.be.a('function')


describe 'get info for valid image', ->
	it 'should call callback with data containing tags and basic stats', (done) ->
		image_ident.info __dirname + '/fixtures/map.jpg', (err, data)->
			expect(data['exif-data']).to.eql
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
			expect(data['stats']).to.eql
					size : 1699551
					mtime: new Date("Sat, 17 Feb 2012 20: 39: 00 GMT")
					ctime: new Date("Sat, 17 Feb 2012 20: 39: 00 GMT")
			done()