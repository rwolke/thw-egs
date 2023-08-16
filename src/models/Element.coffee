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
			@app.view.ToastsView.alert null, attributes.element + ': ' + exception.message, 'error', {autohide: false}
			@geometry = new THREE.Geometry

