Backbone = require "backbone"

module.exports = class extends Backbone.Model
	app: null
	geometry: null
	initialize: (attributes, options) ->
		super attributes, options
		@app = options.collection.app
		@geometry = @app.egsElementProvider.getGeometry @ 

