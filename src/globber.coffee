{EventEmitter2} = require('eventemitter2')
fs = require("fs")
path = require("path")

class Globber extends EventEmitter2
  constructor: (@roots...)->
    @debug = false
    @used = false
    @matchers = []

    this.on "file", (file,stat, root)->
      if @matchers.length == 0
        @emit("match", file,stat, root)
      else
        @matchers.forEach (regex) =>
          if file.match(regex)
            @emit("match", file,stat, root,regex)

  lookfor: (regex)->
    @matchers.push(regex)

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



  execute: (done = ->)->
    throw "Cannot reuse a Globber please make a new"        if @used

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

# Usage:
#glob = new Globber "./spec/fixtures", "src", "src/app.coffee"
#glob.lookfor(/jpg$/i)
#glob.on("dir", (dir, stat, root)-> console.log "dir  : #{root}/#{dir}")
#glob.on("file", (file, stat, root)-> console.log "file : #{root}/#{file}")
#glob.on("match", (file, regex)-> console.log "FOUND : #{file} via #{regex}")
#glob.execute(-> console.log "done!")
#
#console.log "jiiha!"