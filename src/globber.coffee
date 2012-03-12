# Search through dirs and subdirs for files matching one or more regexes
#
# Globber is a EventEmitter2 object and fires events when files og dirs are found
#
# Usage:
# ------
#
#       glob = new Globber "./spec/fixtures", "src", "src/app.coffee"
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
#
# Events
# ------
# * **file**   when a file has been found
# * **dir**   when a directory has been found
# * **match**   when a file matches the regex has been found
#
# If 2 regexes match the same file the match event will be fired twice!
#
# If no regexes are added then all files fires the match event

{EventEmitter2} = require('eventemitter2')
fs = require("fs")
path = require("path")

# ### Constructor
#
# params [roots] one or more paths to dirs or files
class Globber extends EventEmitter2
	constructor: (@roots...)->
		@debug = false
		@used = false
		@matchers = []

		this.on "file", (file, stat, root)->
			if @matchers.length == 0
				@emit("match", file, stat, root)
			else
				@matchers.forEach (regex) =>
					if file.match(regex)
						@emit("match", file, stat, root, regex)

	# #### lookfor
	# @params [regex] regex to look for
	lookfor    : (regex)->
		@matchers.push(regex)

	# #### taverse_dir
	# **private** .. please don't call directly
	taverse_dir: (root, dir, done) =>
		@left++
		console.log "dir >> #{dir}" if @debug
		fs.readdir dir, (err, files) =>
			@emit("error", {path: dir, error: err}) if (err)
			console.log " len #{files.length}" if @debug

			@left += files.length

			files.forEach (file, index) =>
				fullpath = path.join(dir, file)
				console.log " - #{fullpath}" if @debug
				fs.stat fullpath, (err, stat) =>
					if stat.isDirectory()
						@taverse_dir(root, fullpath, done)
						@emit("dir", path.relative(root, fullpath), stat, root)
					else
						@emit("file", path.relative(root, fullpath), stat, root)
					done()

			done()

	# #### execute
	# The callback is called when the last event has been emitted.
	#
	# This means that the callback is called *long* before the callbacks for the events are finished
	execute    : (done = ->)->
		throw "Cannot reuse a Globber please make a new"		  if @used

		@used = true
		@left = 0

		for root in @roots
			do (root) =>
				root = path.normalize(root)
				fs.stat root, (err, stat) =>
					console.log "root >> #{root}" if @debug
					if stat.isDirectory()
						@taverse_dir root, root, =>
							if  --@left == 0
								@emit("done")
								done()
						@emit("dir", ".", stat, root)
					else
						@emit("file", path.basename(root), stat, path.dirname(root))

module.exports = Globber

