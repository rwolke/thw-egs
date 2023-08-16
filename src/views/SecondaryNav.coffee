Backbone = require "backbone"
Package = require "../../package.json"

module.exports = Backbone.View.extend
	el: document.getElementById 'secondaryNav'
	template: require 'templates/SecondaryNav'
	
	events: 
		"click .step-rel": "incrStep"
		"click .step-abs": "setStep"
		"click .step-auto": "setStepper"
		"click .rot-incr": "incrTurnRate"
		"click .rot-set": "setTurnRate"
		"click .reset-view": "resetView"
		"click .height-setincr": "setHeightIncr"
		"click .height-setabs": "setHeightAbs"
		"click .height-setrel": "setHeightRel"
		"click .bg-set": "setBackgroundColor"
	
	setStepper: (e) ->
		@app.view.EGS.setStepper parseInt(e.target.dataset.val)
	incrStep: (e) ->
		@app.view.EGS.incrStep parseInt(e.target.dataset.step)
	setStep: (e) ->
		@app.view.EGS.setStep parseInt(e.target.dataset.step)
	incrTurnRate: (e) ->
		@app.view.EGS.incrTurnRate parseFloat(e.target.dataset.incr)
	setTurnRate: (e) ->
		@app.view.EGS.setTurnRate parseFloat(e.target.dataset.setp)
	setHeightIncr: (e) ->
		@app.view.EGS.setHeight( parseInt(e.target.dataset.incr) , 'incr') if @app.view.EGS 
		do @update
	setHeightAbs: (e) ->
		@app.view.EGS.setHeight( parseInt(e.target.dataset.setabs) , 'abs') if @app.view.EGS 
		do @update
	setHeightRel: (e) ->
		@app.view.EGS.setHeight( parseFloat(e.target.dataset.setrel) , 'rel') if @app.view.EGS 
		do @update
	setBackgroundColor: (e) ->
		@app.view.EGS.setBackgroundColor( e.target.dataset.setc ) if @app.view.EGS 
		do @update
	resetView: (e) ->
		do @app.view.EGS.resetView
	
	initialize: (app) -> 
		@app = app
		
	update: ->
		if (!@app.view.EGS) then return

		$('#stepperMode', @$el).text if @app.view.EGS.stepper > 0 then 'Automatisch' else "Manuell"
		$('.stepper li a', @$el).removeClass 'active'
		$('.stepper-' + @app.view.EGS.stepper, @$el).addClass 'active'
		$('#stepNo', @$el).text @app.view.EGS.steps[@app.view.EGS.stepNo]
		$('.steps li a', @$el).removeClass 'active'
		$('.step-' + @app.view.EGS.stepNo, @$el).addClass 'active'
		$('#turnMode', @$el).text if @app.view.EGS.turnRate > 0 then @app.view.EGS.turnRate + ' U/min' else "Manuell"
		$('.rots li a', @$el).removeClass 'active'
		$('.rot-' + @app.view.EGS.turnRate, @$el).addClass 'active'
		
	render: ->
		if (!@app.view.EGS) then return
			
		tpl = 
			steps: @app.view.EGS.steps
			step: @app.view.EGS.steps[@app.view.EGS.stepNo]
			stepperMode: if @app.view.EGS.stepper > 0 then 'Automatisch' else "Manuell"
			stepper: @app.view.EGS.stepper
			turnMode: if @app.view.EGS.turnRate > 0 then @app.view.EGS.turnRate + ' U/min' else "Manuell"
			turnRate: @app.view.EGS.turnRate
			version: Package.version
		@el.innerHTML = @template tpl
		
