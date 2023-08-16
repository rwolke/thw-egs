THREE = require "THREE"
require "ConvexGeometry"

class ThreadCurve extends THREE.Curve

	constructor: (@height, @pitch, @radius)->
		super()
	
	getPoint: (t) ->
		t = t * @height / @pitch
		new THREE.Vector3(
			@radius * Math.cos(2 * Math.PI * (t - Math.floor(t))),
			@radius * Math.sin(2 * Math.PI * (t - Math.floor(t))),
			t * @pitch
		)

class CustomGeometry extends THREE.Geometry

	calcUVs: ->
		do @computeBoundingBox
		
		max = @boundingBox.max
		min = @boundingBox.min
		
		offset = new THREE.Vector2 0 - min.x, 0 - min.y
		range = new THREE.Vector2 max.x - min.x, max.y - min.y
		
		@faceVertexUvs[0] = [];
		faces = @faces;
		
		for i in [0...@faces.length]
			
			v1 = @vertices[@faces[i].a]
			v2 = @vertices[@faces[i].b]
			v3 = @vertices[@faces[i].c]
			
			@faceVertexUvs[0].push([
				new THREE.Vector2( ( v1.x + offset.x ) / range.x , ( v1.y + offset.y ) / range.y ),
				new THREE.Vector2( ( v2.x + offset.x ) / range.x , ( v2.y + offset.y ) / range.y ),
				new THREE.Vector2( ( v3.x + offset.x ) / range.x , ( v3.y + offset.y ) / range.y )
			]);
		
		@uvsNeedUpdate = true;
	
	constructor: (vertices, faces) ->
		super()
		for v in vertices
			@vertices.push new THREE.Vector3 v[0], v[1], v[2]
		for f in faces
			@faces.push new THREE.Face3 f[0], f[1], f[2]
		do @computeBoundingSphere
		do @computeFaceNormals
		do @computeVertexNormals
		do @calcUVs

class EGS_Helpers
	@DETAIL = 8
	@D90 = .5 * Math.PI
	@D180 = Math.PI
	@D360 = 2 * Math.PI
	X = new THREE.Vector3 1, 0, 0
	Y = new THREE.Vector3 0, 1, 0
	Z = new THREE.Vector3 0, 0, 1
		
	@matrix: (x,y,z,A,n) ->
		m = (new THREE.Matrix4()).makeTranslation(x,y,z)
		m.multiply (new THREE.Matrix4()).makeRotationX(n * @D90) if A == 'X'
		m.multiply (new THREE.Matrix4()).makeRotationY(n * @D90) if A == 'Y'
		m.multiply (new THREE.Matrix4()).makeRotationZ(n * @D90) if A == 'Z'
		m
	
	@barToCircle: (x,y,l,r) ->
		circle = new THREE.CircleGeometry r, @DETAIL
		vert = circle.vertices
		vert.push new THREE.Vector3( x / 2, y / 2, l)
		vert.push new THREE.Vector3(-x / 2, y / 2, l)
		vert.push new THREE.Vector3(-x / 2,-y / 2, l)
		vert.push new THREE.Vector3( x / 2,-y / 2, l)
		new THREE.ConvexGeometry vert
	
	@cylinder: (o,i,h) ->
		shape = new THREE.Shape()
		shape.absarc 0, 0, o / 2, 0, @D360, true
		if i
			hole = new THREE.Path()
			hole.absarc 0, 0, i / 2, 0, @D360, true
			shape.holes.push hole
		new THREE.ExtrudeGeometry shape,
			depth: h
			steps: 1
			bevelEnabled: false
			curveSegments: @DETAIL
	@cylinderPath: (o,i,p) ->
		shape = new THREE.Shape()
		shape.absarc 0, 0, o / 2, 0, @D360, true
		if i
			hole = new THREE.Path()
			hole.absarc 0, 0, i / 2, 0, @D360, true
			shape.holes.push hole
		new THREE.ExtrudeGeometry shape,
			steps: 10
			extrudePath: p
	
	@cubicPath = (l,w,p) ->
		shape = new THREE.Shape()
		shape.moveTo( 0,0 );
		shape.lineTo( 0, w );
		shape.lineTo( l, w );
		shape.lineTo( l, 0 );
		shape.lineTo( 0, 0 );
		new THREE.ExtrudeGeometry shape,
			steps: 100
			extrudePath: p
	
	@threadCyl: (h) ->
		if @DETAIL >= 16
			o = 13
			i = 8
		else
			o = 18
			i = 15
		
		shape = new THREE.Shape()
		shape.absarc 0, 0, o, 0, @D360, true
		if i
			hole = new THREE.Path()
			hole.absarc 0, 0, i, 0, @D360, true
			shape.holes.push hole
		cyl = new THREE.ExtrudeGeometry shape,
			depth: h
			steps: 1
			bevelEnabled: false
			curveSegments: @DETAIL
		
		if @DETAIL >= 16
			h -= 10
			thread =  new THREE.TubeGeometry(
				new ThreadCurve(h, 10, 13),
				@DETAIL * h / 10,
				4
			)
			cyl.merge thread, @matrix(0,0,5)
		cyl


module.exports =
	ThreadCurve: ThreadCurve
	CustomGeometry: CustomGeometry
	Helpers: EGS_Helpers


