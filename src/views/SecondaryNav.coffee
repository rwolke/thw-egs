Backbone = require "backbone"

module.exports = Backbone.View.extend
	el: document.getElementById 'secondaryNav'
	template: require 'templates/SecondaryNav'
	
	steps: []
	step: 0
	counter: 0
	stepper: 5
	rotRate: 2
	
	events: 
		"click .step-rel": "stepRel"
		"click .step-abs": "stepAbs"
		"click .step-auto": "stepAuto"
		"click .rot-incr": "rotationIncr"
		"click .rot-setp": "rotationSetp"
		"click .rot-reset": "rotationReset"
	
	stepRel: (e) ->
		@incrStep e.target.dataset.step
	stepAbs: (e) ->
		@setStep e.target.dataset.step
	stepAuto: (e) ->
		@stepper = parseInt e.target.dataset.val
		do @render
	rotationIncr: (e) ->
		@rotRate += parseFloat e.target.dataset.incr
		@app.view.EGS.setTurnRate @rotRate if @app.view.EGS 
		do @update
	rotationSetp: (e) ->
		@rotRate = parseFloat e.target.dataset.setp
		@app.view.EGS.setTurnRate @rotRate if @app.view.EGS 
		do @update
	rotationReset: (e) ->
		@app.view.EGS.setTurnRate @rotRate if @app.view.EGS 
		
	
	startup: ->
		@setStep 0
		setInterval (=> do @timeTrigger), 1000
		@app.view.EGS.updateConstruct @step 
		@app.view.EGS.setTurnRate @rotRate
	
	setSteps: (steps) ->
		@steps = steps
		@step = 0
		do @render
	
	incrStep: (dir) ->
		dir = parseInt(dir)
		return @setStep @step + @steps.length + dir if @step + dir < 0
		return @setStep @step - @steps.length + dir if @step + dir >= @steps.length
		@setStep @step + dir
	
	setStep: (step) ->
		@step = parseInt(step)
		console.log "Aufbauschritt: " + @steps[@step] + " (index: " + @step + ")"
		@app.view.EGS.updateConstruct @step if @app.view.EGS 
		do @update
	
	timeTrigger: ->
		@incrStep 1 if @stepper and ++@counter %% @stepper is 0
	
	initialize: (@app) -> 
		do @render
		
	update: ->
		$('#stepNo', @$el).text @steps[@step]
		$('.steps li', @$el).removeClass 'active'
		$('.step-' + @step, @$el).addClass 'active'
		$('#rotMode', @$el).text if @rotRate > 0 then @rotRate + ' U/min' else "Manuell"
		$('.rots li', @$el).removeClass 'active'
		$('.rot-' + @rotRate, @$el).addClass 'active'
		
	render: ->
		steps = []
		for i of @steps
			steps.push 
				i: i
				name: "Schritt " + @steps[i]
			
		tpl = 
			steps: steps
			step: @step
			stepName: @steps[@step]
			auto: @stepper
			rotMode: if @rotRate > 0 then @rotRate + ' U/min' else "Manuell"
			rate: @rotRate
		@el.innerHTML = @template tpl
		
