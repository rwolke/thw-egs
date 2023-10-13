require "scss/style.scss"

Bootstrap = require "bootstrap"
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
EGS_Elements = require 'egs/Elements'

App = class MainApp extends Backbone.Router
	view: {}
	egsElementProvider: null
	dataSourceList: null
	activeSource: null
	activeConstruct: null
	routes:
		"": "default"
		":skey": "loadSource"
		":skey/:sgid(/)": "loadSource"
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

		@egsElementProvider = new EGS_Elements();
		PrimaryNavView = require "views/PrimaryNav"
		@view.PrimaryNav = new PrimaryNavView @dataSourceList
		SecondaryNavView = require "views/SecondaryNav"
		@view.SecondaryNav = new SecondaryNavView @
		DataSourceModal = require "views/DataSourceModal"
		@view.DataSource = new DataSourceModal @
		ToastsView = require "views/Toasts"
		@view.ToastsView = new ToastsView
		@view.EGS = new EGS @, 'display'

		for i,v of @view
			if v.startup?
				do v.startup

	start: ->
		console.log "App start"
		do Backbone.history.start
		@view.ToastsView.alert null, 'App gestartet.', 'success'

google = require "google"

# Theudebart:
# Load Google Charts API
# Load Frozen Version 44 (February 23, 2016) as this was the latest version from the last commit.
google.charts.load '44', {packages: ['corechart']}

google.setOnLoadCallback (e)->
	body = document.getElementsByTagName('body')[0]
	return if window.App  ## singleton behaviour
	window.App = new App
		defaultSource: body.getAttribute 'data-defaultSource'
	do window.App.start

# Theudebart:
# Bugfix
# Loading the Google Chart Library has changed. See https://developers.google.com/chart/interactive/docs/basic_load_libs#updateloader
# This results in an error. See Issue 13: https://github.com/rwolke/thw-egs/issues/13
# The code below is deprecated and should be removed in later releases.
# The code below is replaced by google.charts.load and moved further up (needs to be called before google.setOnLoadCallback)
###
google.load 'visualization', '1',
	packages: ['table']
###
