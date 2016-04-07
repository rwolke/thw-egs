Backbone = require "backbone"
ConstructionElement = require "models/Element"

module.exports = class extends Backbone.Collection
	model: ConstructionElement
	initialize: (models, options)->
		@app = options.app
#		console.log "init ConstructionElements"

