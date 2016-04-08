Backbone = require "backbone"

module.exports = Backbone.View.extend
	el: document.getElementById 'primaryNav'
	template: require 'templates/PrimaryNav'
	activeConstructionList: null
	
	initialize: (@dataSourceList) -> 
		@listenTo @dataSourceList, 'select', ->
			@stopListening @activeConstructionList if @activeConstructionList
			@activeConstructionList = null
			@render 'loading', 'unset'
		
		@listenTo @dataSourceList, "sync", ->
			@activeConstructionList = @dataSourceList.selected.get 'constructions'
			@listenTo @activeConstructionList, 'select', -> @render 'loaded', 'loading'
			@listenTo @activeConstructionList, 'sync', -> @render 'loaded', 'loaded'
			@render 'loaded', 'unset'
		
		@render 'unset', 'unset'
		
	
	render: (dataSourceState = 0, constructionState = 0) ->
#		console.log "PrimNavRender: #{dataSourceState} #{constructionState}"
		tpl = {}
		if dataSourceState is 'loaded'
			tpl.item = []
			constructionList = @dataSourceList.selected.get 'constructions' 
			selected = null
			constructionList.each (e) ->
				selected = e.get('name') if e == constructionList.selected
				tpl.item.push
					sheet: e.get('sheet')
					name: e.get('name')
			
			if constructionState isnt "unset"
				tpl.auswahl = "#{selected}"
			else
				tpl.auswahl = "#{tpl.item.length} Konstruktionen zur Auswahl"
		
		if dataSourceState is 'loading' or constructionState is 'loading'
			tpl.loading = true
		
		@el.innerHTML = @template tpl
		
