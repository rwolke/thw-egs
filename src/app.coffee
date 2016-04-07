Backbone = require "backbone"
_ = require "underscore"
window = require "window"
EGS = require "views/EGS"

Backbone.sync = (method, model, options) ->
	key = model.id.split '/'
	console.log "sync called with key: ", key
	url = 'https://docs.google.com/spreadsheets/d/' + key[key.length-2] + '/gviz/tq?gid=' + key[key.length-1]
	
	if method is 'read'
		(new google.visualization.Query url).send (resp) =>
			if do resp.isError
				options.error(resp)
			else
				options.success(resp)

DataSourceModel = require "models/DataSource"
DataSourceListCollection = require "collections/DataSourceList"
EGS_Elements = require 'egs/EGS_Elements'

App = class MainApp extends Backbone.Router
	view: {}
	egsElementProvider: new EGS_Elements
	dataSourceList: null
	activeSource: null
	activeConstruct: null
	routes: 
		"": "default"
		":skey": "loadSource"
		":skey/:sgid": "loadSource"
		":skey/:sgid/:ckey/:cgid": "loadConstruct"
	
	default: -> 
		@setActiveDataSource.call @
	
	loadSource: (skey, sgid = 0) -> 
		console.log "Routed to loadSource '#{skey}'/'#{sgid}'"
		@setActiveDataSource.call @, skey + "/" + sgid
	
	loadConstruct: (skey, sgid, ckey, cgid) -> 
		console.log "Routed to loadConstruct '#{skey}'/'#{sgid}'/'#{ckey}'/'#{cgid}'"
		@setActiveDataSource.call @, skey + "/" + sgid, (ds) =>
			@setActiveConstruction.call @, skey + "/" + sgid + "/" + ckey + "/" + cgid, (c) =>
				@view.EGS.showConstruct c
	
	setActiveDataSource: (source, cb = null) ->
		console.log "setActiveDataSource", source
		if source
			source = source.split '/'
			source = source[0] + '/' + source[1]
			if not @dataSourceList.get(source)
				@dataSourceList.add [{source: source}]
			@activeSource = @dataSourceList.get(source).setSelected cb
		else if @dataSourceList.length
			@activeSource = @dataSourceList.at(0).setSelected cb
	
	setActiveConstruction: (construct, cb = null) ->
		source = @dataSourceList.selected
		return if source is null
		console.log "setActiveConstruction", construct
		
		if not source.get('constructions').get(construct)
			alert "ausgewählte Konstruktion nicht in Datenquelle definiert!"
		@activeConstruct = source.get('constructions').get(construct).setSelected cb
	
	initialize: (data) ->
		console.log "App Init"
		@dataSourceList = new DataSourceListCollection [{source: data.defaultSource}], 
			app: @
		
		PrimaryNavView = require "views/PrimaryNav"
		@view.PrimaryNav = new PrimaryNavView @dataSourceList
		SecondaryNavView = require "views/SecondaryNav"
		@view.SecondaryNav = new SecondaryNavView @
		DataSourceModal = require "views/DataSourceModal"
		@view.DataSource = new DataSourceModal @
		@view.EGS = new EGS @, 'display'
		
		for i,v of @view
			if v.startup?
				do v.startup
	
	start: ->
		console.log "App start"
		do Backbone.history.start
	
google = require "google"

google.load 'visualization', '1', 
	packages: ['table']

google.setOnLoadCallback ->
	body = document.getElementsByTagName('body')[0]
	return if window.App 
	window.App = new App
		defaultSource: body.getAttribute 'data-defaultSource'
	do window.App.start
