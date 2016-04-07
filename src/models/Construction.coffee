Backbone = require "backbone"
ElementList = require "collections/ElementList"

module.exports = class extends Backbone.Model
	dataTable: null
	fetched: false
	
	fields: 
		show: 
			name: "Anzeige"
		color: 
			name: "Farbe"
		element: 
			name: "Bauteil"
		x: 
			name: "X"
		y: 
			name: "Y"
		h: 
			name: "H",
		direction: 
			name: "Richtung"
		special: 
			name: "Besonderheit"
	
	determineColumn: (label) ->
		return 'element' if /(Element|Bauteil)(\s.*)?/i.test label
		return 'direction' if /(Richtung)(\s.*)?/i.test label
		return 'special' if /(Besonderheit)(\s.*)?/i.test label
		return 'show' if  /(.*\s)?(Anzeige)/i.test label
		return 'x' if  /(.*\s)?(X)/i.test label
		return 'y' if  /(.*\s)?(Y)/i.test label
		return 'h' if  /(.*\s)?(H)/i.test label
		return 'color' if  /(.*\s)?(Farbe)/i.test label
		null
	
	idAttribute: "sheet"
	initialize: (attributes, options) ->
		@app = options.collection.app
#		console.log "init Construction"
		@elements = new ElementList [], 
			app: @app
	
	setSelected: (cb) ->
		@collection.setSelected this
		if not @fetched 
			@fetch success: => 
				@fetched = true
				cb this if cb
		else
			cb this if cb
	
	parse: (resp) ->
		@dataTable = do resp.getDataTable
		
		cols = {} 
		colTypes = {}
		for c in [0 ... @dataTable.getNumberOfColumns()]
			cv = @determineColumn @dataTable.getColumnLabel c
			if cv
				cols[cv] = c 
				colTypes[cv] = true
		
		for i,c of @fields
			if not colTypes[i]?
				console.log "Spalte '#{c.name}' nicht gefunden!"
				return
		
		data = []
		for r in [0 ... @dataTable.getNumberOfRows()]
			d = {}
			for key,c of cols
				d[key] = @dataTable.getValue r, c
			data.push d
		
		console.log "Construction: loaded element list: ", data
		elements: new ElementList data, app: @app

	
