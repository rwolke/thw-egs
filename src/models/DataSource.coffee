Backbone = require "backbone"
ConstructionList = require "collections/ConstructionList"
keyNormalizer = require "keyNormalizer"

module.exports = class DataSource extends Backbone.Model
	app: null
	fetched: false
	dataTable: null
	columns: 
		sheet: "Blatt-Link (gid)"
		name: "Konstruktion"
		desc: "Beschreibung"
	
	idAttribute: "source"
	initialize: (attributes, options) ->
		@app = options.collection.app
		@set 'constructions', new ConstructionList [], 
			app: @app
	
	setSelected: (cb) ->
		@collection.setSelected this
		if not @fetched 
			@fetch success: => 
				@fetched = true
				cb this if cb
		else
			cb this if cb

	set: (attr, opts) ->
		if attr.source
			attr.source = keyNormalizer(attr.source).join('/') 
		Backbone.Model.prototype.set.call this, attr, opts
	
	parse: (resp) ->
		@dataTable = do resp.getDataTable
		
		firstDataRow = if @dataTable.getColumnLabel(0).length then 0 else 1
		isConstructTable = firstDataRow is 0
		for k of @columns
			if @columns[k] is @dataTable.getColumnLabel(0)
				isConstructTable = false
		
		if isConstructTable
			return constructions: new ConstructionList [{name: "Konstruktion", desc: "", sheet: @id}]
		data = []
		for r in [firstDataRow ... @dataTable.getNumberOfRows()]
			d = {}
			for k of @columns
				importer = (v) -> v
				if k is "sheet"
					importer = (v) => [@id, keyNormalizer(v, false, @id).join '/'].join '/'
				
				for c in [0 ... @dataTable.getNumberOfColumns()]
					if (firstDataRow and @dataTable.getValue(0, c) is @columns[k]) or @dataTable.getColumnLabel(c) is @columns[k]
						d[k] = importer @dataTable.getValue r, c
				if not d[k]
					alert "Übersichtstabelle: Spalte '#{@columns[k]}' wurde nicht in der Tabelle gefunden!"
					return
			data.push d
		
		console.log "DataSource: loaded construction list: ", data
		constructions: new ConstructionList data, 
			app: @app
	
