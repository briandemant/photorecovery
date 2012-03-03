env =
	replace_env: ->
		secret_conf = require('nconf')
		secret_conf.argv(
				'about':
					description: 'Provide some details about the author of this program',
					required   : true,
					short      : 'a'
				'info' :
					description: 'Provide some information about the node.js agains!!!!!!',
					boolean    : true,
					short      : 'i'
		).env().file({ file: __dirname + '/../config/config.json' })
		#console.log secret_conf.stores.argv
		env =
			get: (key) -> secret_conf.get(key)

	get: (key) ->
		env.replace_env()
		env.get(key)

console.log env.get('info')

console.log env.get('about')



