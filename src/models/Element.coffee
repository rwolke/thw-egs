Backbone = require "backbone"
THREE = require "THREE"

module.exports = class extends Backbone.Model
	app: null
	geometry: null
	initialize: (attributes, options) ->
		super attributes, options
		@app = options.collection.app
		try
			@geometry = @app.egsElementProvider.getGeometry @
		catch exception
			console.warn(exception)
			@geometry = new THREE.Geometry

