Backbone = require "backbone"
THREE = require "THREE"
OrbitControls = require('three-orbit-controls')(THREE)

class EGS_ElementView extends Backbone.View
	parent: null
	mesh: null
	color: null
	display: null
	
	parseNum: (text) ->
		return [] if not text
		list = []
		t1 = String(text).split ','
		for t2 in t1
			tt = t2.split ':'
			ptt = tt[0].split '-'
			color = if tt.length is 2 then tt[1] else null;
			ptt[0] = null if ptt[0] is ''
			ptt[1] = ptt[0] if ptt.length is 1
			ptt[1] = null if ptt[1] is ''
			
			if ptt[0] >= 0
				list.push [ptt[0], ptt[1], color]
		list
	
	initialize: (options) ->
		@parent = options.parent 
		
		do @model.geometry.computeBoundingBox
		
		@color = @parent.getAndStoreColor @model.get 'color'
		
		@mesh = new THREE.Mesh @model.geometry, @color
		@mesh.visible = false
		
		@display = []
		for d in @parseNum @model.get 'show'
			for i in [0,1]
				if d[i] isnt null
					d[i] = parseInt d[i]
					@parent.steps.push d[i]
			d[2] = if d[2] is null then @color else @parent.getAndStoreColor d[2] 
			@display.push d
	
	getMesh: -> @mesh
	setStep: (step) ->
		show = null
		for i of @display
			if @display[i][0] isnt null && @display[i][1] isnt null 
				show = @display[i][2] if step >= @display[i][0] and step <= @display[i][1]
			else if @display[i][0] isnt null
				show = @display[i][2] if step >= @display[i][0]
			else if @display[i][1] isnt null
				show = @display[i][2] if step <= @display[i][1]
		
		@mesh.visible = show isnt null
		@mesh.material = if show then show else @color
		
class Display 
	center: new THREE.Vector3()
	bbox: new THREE.Box3()
	
	startTime: null
	turnRate: 0
	turnOffset: 0
	camDistance: 0
	camDistanceOffset: 0
	camHeight: 0
	camHeightOffset: 0
	
	scene: null
	renderer: null
	camera: null
	controls: null
	
	animationRequest: null
	
	_addRenderer: (domElementID)->
		hasWebGL = false
		try
			canvas = document.createElement 'canvas' 
			hasWebGL = !! ( window.WebGLRenderingContext && 
				( canvas.getContext( 'webgl' ) || canvas.getContext( 'experimental-webgl' ) )
			)
	
		if hasWebGL
			@renderer = new THREE.WebGLRenderer
				antialias: true
		else
			@renderer = new THREE.CanvasRenderer()
		@renderer.setPixelRatio window.devicePixelRatio
		@renderer.setSize window.innerWidth, window.innerHeight
		document.getElementById(domElementID).appendChild @renderer.domElement
	
	_setBackgroundColor: (color) ->
		@scene.background = new THREE.Color( color )

	_addLights: ->
		ambiLight = new THREE.AmbientLight( 0xffffff, 0.6 )
		@scene.add ambiLight

		dirLight = new THREE.DirectionalLight 0xffffff, 1
		dirLight.color.setHSL 0.1, 1, 0.95
		dirLight.position.set -5000, 10000, -5000
		dirLight.position.multiplyScalar 50
		@scene.add dirLight

	_addCamera: ->
		width = window.innerWidth
		height = window.innerHeight
		@camera = new THREE.PerspectiveCamera 70, width / height, 1, 200000
#		camera = new THREE.OrthographicCamera( width / - .5, width / .5, height / .5, height / - .5, 1, 100000 );

	_addControls: ->
		@controls = new OrbitControls @camera, @renderer.domElement
		@controls.zoomSpeed = .3
		@controls.rotateSpeed = .3
	
	onWindowResize: =>
		return if not @camera
		
		style = getComputedStyle document.getElementById(@domElementID), null
		w = parseInt style.getPropertyValue 'width'
		h = parseInt style.getPropertyValue 'height'
		
		@camera.aspect = w / h 
		do @camera.updateProjectionMatrix
		
		@renderer.setSize w, h
	
	_animationStart: ->
		return if not @scene
		do @_animationFrame if not @animationRequest
		
	_animationStop: ->
		window.cancelAnimationFrame @animationRequest if @animationRequest
		@animationRequest = null
		
	_animationFrame: ->
		@animationRequest = window.requestAnimationFrame (=> do @_animationFrame )
		do @calcCamPos
		@renderer.render @scene, @camera
	
	constructor: (@domElementID) ->
		@scene = new THREE.Scene
		@_addRenderer @domElementID
		do @_addLights
		do @_addCamera
		do @_addControls
		
		do @onWindowResize
		do @_animationStart
		
	
	resetView: ->
		@center = new THREE.Vector3();
		@center = @bbox.getCenter @center
		size = new THREE.Vector3();
		size = @bbox.getSize size
		
		fovH = @camera.fov / 180 * Math.PI * 80 / 100
		@camDistance = Math.max.apply Math, [
			size.y / 2 * Math.tan(fovH) + Math.sqrt size.x * size.x / 4 + size.z * size.z / 4
			size.y / 2 * Math.tan(fovH) + size.z / 2
			size.y / 2 * Math.tan(fovH) + size.x / 2
			size.x / 2 * Math.tan(fovH) / @camera.aspect + size.z / 2
			size.z / 2 * Math.tan(fovH) / @camera.aspect + size.x / 2
		]
		@camHeight = @center.y
		
		@controls.target.copy @center
	
	removeAll: ->
		@scene.remove @scene.children[0] while @scene.children.length
		do @_addLights
		@bbox = new THREE.Box3()
		
	add: (element) ->
		@scene.add do element.getMesh
		@bbox.union element.model.geometry.boundingBox
		do @resetView
	
	setTurnRate: (rate) ->
		delta = (do Date.now) - @startTime # 60 000 per Minute
		@turnOffset = @turnOffset + delta / (60000 / @turnRate)
		@startTime = do Date.now
		
		@controls.enableZoom = rate == 0
		@controls.enablePan = rate == 0
		@controls.enableRotate = rate == 0
		
		@turnRate = rate
		@calcCamPos true
	
	setHeight: (height, relation) ->
		@camHeight = switch relation
			when "abs" then 10 * height
			when "incr" then @camHeight + 10 * height
			when "rel" then 2 * @center.y * height
			else @camHeight
		@calcCamPos true
	
	calcCamPos: (override) ->
		if override
			turnIndex = @turnOffset
		else
			return if @turnRate is 0
			delta = (do Date.now) - @startTime # 60 000 per Minute
			turnIndex = @turnOffset + delta / (60000 / @turnRate)
		
		@camera.position.x = @center.x + Math.sin(2 * Math.PI * turnIndex) * ( @camDistance + @camDistanceOffset )
		@camera.position.y = @camHeight
		@camera.position.z = @center.z + Math.cos(2 * Math.PI * turnIndex) * ( @camDistance + @camDistanceOffset )
		@camera.lookAt @center
	
	setBackgroundColor: (color) ->
		@_setBackgroundColor color

class EGS_View extends Backbone.View
	elements: []
	steps: []
	stepNo: 0
	stepper: 0
	counter: 0
	turnRate: 0
	height: 0
	heightRelation: 'abs'
	bgColor: ''
	
	colorTable = []
	
	setTurnRate: (rate) ->
		@turnRate = rate
		@display.setTurnRate @turnRate
		do @app.view.SecondaryNav.update
		@_saveSetting('turnRate', @turnRate)
	incrTurnRate: (value) ->
		@turnRate = @turnRate + value
		if (@turnRate < 0) then @turnRate = 0
		@setTurnRate @turnRate
	setHeight: (height, relation) ->
		@height = height
		@heightRelation = relation
		@display.setHeight height, relation
		do @app.view.SecondaryNav.update
		@_saveSetting('height', @height)
		@_saveSetting('heightRelation', @heightRelation)
	setBackgroundColor: (color) ->
		@bgColor = color
		@display.setBackgroundColor @bgColor
		do @app.view.SecondaryNav.update
		@_saveSetting('bgColor', @bgColor)
	setStepper: (value) ->
		@stepper = value
		do @app.view.SecondaryNav.update
		@_saveSetting('stepper', @stepper)
	setStep: (step) ->
		@stepNo = step
		console.log "Aufbauschritt: " + @steps[@stepNo] + " (index: " + @stepNo + ")"
		@updateConstruct @stepNo
		do @app.view.SecondaryNav.update
	incrStep: (value) ->
		@stepNo = @stepNo + value
		if (@stepNo >= @steps.length) then @stepNo = 0
		if (@stepNo < 0) then @stepNo = @steps.length - 1
		@setStep @stepNo
	resetView: ->
		do @_setDefaultSettings
		do @_applySettings
		do @app.view.SecondaryNav.update
	
	timeTrigger: ->
		@incrStep 1 if @stepper and ++@counter %% @stepper is 0
		do @app.view.SecondaryNav.update
	
	constructor: (@app, @domElementID) ->
		super()
		@display = new Display @domElementID

		setInterval (=> do @timeTrigger), 1000
		@updateConstruct @stepNo
		do @_setDefaultSettings
		do @_initSettings
		do @_applySettings
	
	showConstruct: (construction) ->
		@elements = [];
		@steps = []
		construction.get('elements').each (e) =>
			@elements.push new EGS_ElementView
				model: e
				parent: @
		
		@steps = @steps.filter (v,i,x) -> i is x.indexOf v 
		@steps.sort (a,b) -> a-b
		@stepNo = @steps.length - 1
		
		do @app.view.SecondaryNav.render
		do @display.removeAll
		for e in @elements
			@display.add e
		
		@updateConstruct @stepNo
		@display.calcCamPos true
	
	updateConstruct: (step) ->
		@stepNo = step
		for e in @elements
			e.setStep parseInt @steps[@stepNo]
		do @render

	_setDefaultSettings: ->
		@stepper = 0
		@turnRate = 0
		@height = 1
		@heightRelation = 'rel'
		@bgColor = '#ccc'

	_applySettings: ->
		@setStepper @stepper
		@setTurnRate @turnRate
		@setHeight @height, @heightRelation
		@setBackgroundColor @bgColor
		do @app.view.SecondaryNav.update

	_initSettings: ->
		@stepper = parseInt(@_getSetting('stepper', @stepper))
		@turnRate = parseInt(@_getSetting('turnRate', @turnRate))
		@height = parseInt(@_getSetting('height', @height))
		@heightRelation = @_getSetting('heightRelation', @heightRelation)
		@bgColor = @_getSetting('bgColor', @bgColor)

	_saveSetting: (key, val) ->
		if window.localStorage
			window.localStorage.setItem key, val
	
	_getSetting: (key, defVal) ->
		if window.localStorage
			if window.localStorage.getItem key
				return window.localStorage.getItem key
		return defVal
		
	_hexToRGB = (hex) ->
		r = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec hex
		rs = /^#?([a-f\d])([a-f\d])([a-f\d])$/i.exec hex
		return (parseInt(r[1], 16) << 16) + (parseInt(r[2], 16) << 8) + parseInt(r[3], 16) if r
		return ((parseInt(rs[1], 16)*17) << 16) + ((parseInt(rs[2], 16)*17) << 8) + (parseInt(rs[3], 16)*17) if rs
		return 0x888888
	
	getAndStoreColor: (val) ->
		if not colorTable[val]?
			colorTable[val] = new THREE.MeshPhongMaterial
				color: _hexToRGB val
				emissive: 0x000000
				specular: 0x000000
				shininess: 30
		colorTable[val]
	



module.exports = EGS_View
