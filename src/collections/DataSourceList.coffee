Backbone = require "backbone"
DataSource = require "models/DataSource"

module.exports = class DataSourceList extends Backbone.Collection
	app: null
	model: DataSource
	selected: null
	setSelected: (ds) ->
		return if ds is @selected 
		@trigger "unselect", @selected if @selected
		@selected = ds
		@trigger "select", @selected
		@trigger "sync" if @selected.fetched
	
	initialize: (models, options)->
		@app = options.app
		console.log "init DataSourceList", @app
