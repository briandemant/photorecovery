exec = require('child_process').exec

exports.read = (path, callback)->
	exec "exiftags -avuqs '|' '#{path}'", (err, stdout, stderr)->
		if stdout
			lines = stdout.split "\n"
			result = {}
			for line in lines
				[key,value] = line.split '|'
				continue unless value

				if value.match(/^\d+$/)
					value = parseInt(value)
				else if value.match(/^\d+\.\d+$/)
					value = parseFloat(value)
				else if parts = value.match(/^(\d+):(\d+):(\d+)\s+(\d+:\d+:\d+)$/)
					[x,year,month,day,time] = parts
					value = new Date "#{year}-#{month}-#{day} #{time}"

				result[key] = value

			callback null, result
		else if stderr
			callback
					type   : "stderr"
					message: stderr
		else if err
			callback
					type   : "error"
					message: err

