expect = require 'expect.js'
Globber = require '../src/globber.coffee'

describe 'fire events for all dirs', ->
	it 'should call callback with tags', (done) ->
		emit_count = 0

		glob = new Globber "./spec/fixtures"
		glob.on "dir", (dir, stat, root) ->
			done() if (++emit_count is 2)
		glob.execute()

#       glob.lookfor(/jpg$/i)
#
#       glob.on "dir", (dir, stat, root) ->
#           console.log "dir  : #{root}/#{dir}"
#
#       glob.on "file", (file, stat, root) ->
#           console.log "file : #{root}/#{file}")
#
#       glob.on "match", (file, stat, root, regex) ->
#           console.log "FOUND : #{file} via #{regex}")
#
#       glob.execute(-> console.log "done!")
#
#       console.log "Yes!!!"