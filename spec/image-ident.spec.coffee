expect = require 'expect.js'
image_ident = require '../src/image-ident.coffee'

describe 'exiftags.spec.coffee', ->
	it 'should export a tags function', ->
		expect(image_ident.info).not.to.be(undefined)
		expect(image_ident.info).to.be.a('function')


describe 'get info for valid image', ->
	it 'should call callback with data containing tags and basic stats', (done) ->
		image_ident.info __dirname + '/fixtures/one/map.jpg', (err, data)->
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
					mtime: new Date("Sat, 17 Feb 2012 20:39:00 GMT")
					ctime: new Date("Sat, 18 Feb 2012 21:29:58 GMT")
			expect(data['info']).to.eql
							width     : 6400
							height    : 3200
							colorspace: 16
							quality   : 91
			done()

describe 'get tags for non existing path', ->
	it 'should call callback with error', (done) ->
		image_ident.info 'xxx.jpg', (err, data)->
			expect(err).to.eql
					errno: 34
					code : 'ENOENT'
					path : 'xxx.jpg'
			expect(data).to.be(undefined)
			done()

describe 'get tags for image without exifdata', ->
	it 'should call callback with stderr', (done) ->
		image_ident.info __dirname + '/fixtures/one/noexif.jpg', (err, data)->
			expect(data['stats']).to.eql
					size : 8867
					mtime: new Date("Fri, 17 Feb 2012 15:20:54 GMT")
					ctime: new Date("Sat, 18 Feb 2012 21:29:58 GMT")
			expect(data['exif-data']).to.be(false)
			expect(data['info']).to.eql
					width     : 160
					height    : 120
					colorspace: 16
					quality   : 88
			done()

describe 'get tags for image without exifdata', ->
	it 'should call callback with stderr', (done) ->
		image_ident.basic __dirname + '/fixtures/one/map.jpg', (err, data)->
			expect(data['stats']).to.eql
					size : 1699551
					mtime: new Date("Sat, 17 Feb 2012 20:39:00 GMT")
					ctime: new Date("Sat, 18 Feb 2012 21:29:58 GMT")
			expect(data['exif-data']).to.be(undefined)
			expect(data['info']).to.be(undefined)
			done()