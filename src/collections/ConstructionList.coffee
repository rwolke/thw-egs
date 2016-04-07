Backbone = require "backbone"
Construction = require "models/Construction"

module.exports = class ConstructionList extends Backbone.Collection
	app: null
	model: Construction
	selected: null
	setSelected: (ds) ->
		console.log "CL select: ", ds, @selected
		return if ds is @selected 
		@trigger "unselect", @selected if @selected
		@selected = ds
		console.log "CL triggered select"
		@trigger "select", @selected
		@trigger "sync" if @selected.fetched
		
	
	initialize: (models, options)->
		@app = options.app
#		console.log "init ConstructionList"
