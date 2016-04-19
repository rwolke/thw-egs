THREE = require "THREE"
require "ConvexGeometry"

class THREE.ThreadCurve extends THREE.Curve
	constructor: (@height, @pitch, @radius)->
		super()
	
	getPoint: (t) ->
		t = t * @height / @pitch
		new THREE.Vector3(
			@radius * Math.cos(2 * Math.PI * (t - Math.floor(t))),
			@radius * Math.sin(2 * Math.PI * (t - Math.floor(t))),
			t * @pitch
		)

class THREE.CustomGeometry extends THREE.Geometry
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

class EGS_Elements
	DETAIL = 8
	D90 = .5 * Math.PI
	D180 = Math.PI
	D360 = 2 * Math.PI
	X = new THREE.Vector3 1, 0, 0
	Y = new THREE.Vector3 0, 1, 0
	Z = new THREE.Vector3 0, 0, 1
	
	TellerDurchmesser = 123.6
	RohrDurchmesserAussen = 48.3
	RohrDurchmesserInnen = 45.1
	TellerHoehe = 9
		
	_m = (x,y,z,A,n) ->
		m = (new THREE.Matrix4()).makeTranslation(x,y,z)
		m.multiply (new THREE.Matrix4()).makeRotationX(n * D90) if A == 'X'
		m.multiply (new THREE.Matrix4()).makeRotationY(n * D90) if A == 'Y'
		m.multiply (new THREE.Matrix4()).makeRotationZ(n * D90) if A == 'Z'
		m
	
	_barToCircle = (x,y,l,r) ->
		circle = new THREE.CircleGeometry r, DETAIL
		vert = circle.vertices
		vert.push new THREE.Vector3( x / 2, y / 2, l)
		vert.push new THREE.Vector3(-x / 2, y / 2, l)
		vert.push new THREE.Vector3(-x / 2,-y / 2, l)
		vert.push new THREE.Vector3( x / 2,-y / 2, l)
		new THREE.ConvexGeometry vert
	
	_cylinder = (o,i,h) ->
		shape = new THREE.Shape()
		shape.absarc 0, 0, o / 2, 0, D360, true
		if i
			hole = new THREE.Path()
			hole.absarc 0, 0, i / 2, 0, D360, true
			shape.holes.push hole
		shape.extrude
			amount: h
			steps: 1
			bevelEnabled: false
			curveSegments: DETAIL
	_cylinderPath = (o,i,p) ->
		shape = new THREE.Shape()
		shape.absarc 0, 0, o / 2, 0, D360, true
		if i
			hole = new THREE.Path()
			hole.absarc 0, 0, i / 2, 0, D360, true
			shape.holes.push hole
		shape.extrude
			steps: 10
			extrudePath: p
	
	_threadCyl = (h) ->
		if DETAIL >= 16
			o = 13
			i = 8
		else
			o = 18
			i = 15
		
		shape = new THREE.Shape()
		shape.absarc 0, 0, o, 0, D360, true
		if i
			hole = new THREE.Path()
			hole.absarc 0, 0, i, 0, D360, true
			shape.holes.push hole
		cyl = shape.extrude
			amount: h
			steps: 1
			bevelEnabled: false
			curveSegments: DETAIL
		
		if DETAIL >= 16
			h -= 10
			thread =  new THREE.TubeGeometry(
				new THREE.ThreadCurve(h, 10, 13),
				DETAIL * h / 10,
				4
				)
			cyl.merge thread, _m(0,0,5)
		cyl
	
	_rohr = (length) ->
		_cylinder RohrDurchmesserAussen, RohrDurchmesserInnen, length
		
	_AnfStk = ->
		a = new THREE.Geometry()
		a.merge _rohr(165), _m(0,0,-65)
		a.merge _teller()
		a.merge _cylinder(55,49,170), _m(0,0,95)
		a.applyMatrix _m(0,0,0, 'X', -1)
		a
	
	_belagKlammer = (x) ->
		shape = new THREE.Shape()
		z = 30
		d1 = 25
		d2 = 33
		shape.moveTo(  0,  0)
		shape.lineTo( 30,  0)
		shape.arc(25, 0, d1, 0, Math.PI)
		shape.lineTo(17+d2+d2,0)
		shape.arc(-33, 0, d2, Math.PI*.7, 0)
		shape.lineTo( 30, 35)
		shape.lineTo(  0, 35)
		shape.lineTo(  0,  0)
		bk = shape.extrude
			amount: 40
			steps: 1
			bevelEnabled: false
			curveSegments: DETAIL
		bk.applyMatrix _m(x, 0, 55, 'Y', 1)
		bk
	
	_belagRahmen = (l, b) ->
		o = 50
		vertices = [
			# oberkante
			[ 0, 45,  o],[  b, 45,  o],[  b, 45,  l-o],[ 0, 45,  l-o], 
			# unterkante
			[ 0,-30,  o],[  b,-30,  o],[  b,-30,  l-o],[ 0,-30,  l-o], 
			# unterkante innen
			[ 5,-30,o+5],[b-5,-30,o+5],[b-5,-30,l-o-5],[ 5,-30,l-o-5], 
			# oberkante innen
			[ 5, 40,o+5],[b-5, 40,o+5],[b-5, 40,l-o-5],[ 5, 40,l-o-5], 
		]
		faces = [
			[ 0, 2, 1], [ 0, 3, 2], [12,13,14], [12,14,15],
			[ 0, 1, 5], [ 0, 5, 4], [ 1, 2, 6], [ 1, 6, 5],
			[ 2, 3, 7], [ 2, 7, 6], [ 3, 0, 4], [ 3, 4, 7],
			[ 4, 5, 9], [ 4, 9, 8], [ 5, 6,10], [ 5,10, 9],
			[ 6, 7,11], [ 6,11,10], [ 7, 4, 8], [ 7, 8,11],
			[ 8, 9,13], [ 8,13,12], [ 9,10,14], [ 9,14,13],
			[10,11,15], [10,15,14], [11, 8,12], [11,12,15],
		]
		new THREE.CustomGeometry vertices, faces
	
	_Belag = (l, w, x = 0) ->
		b = new THREE.Geometry()
		b.merge _belagKlammer(1), _m(  60,0,0)
		b.merge _belagKlammer(1), _m(w-60,0,0)
		b.merge _belagRahmen(l, w), _m(0,0,0)
		b.merge _belagKlammer(1), _m(  60,0,l, 'Y', 2)
		b.merge _belagKlammer(1), _m(w-60,0,l, 'Y', 2)
		b.applyMatrix _m(55+x, 0, 0)
		b
	
	_keilKupplungDiagonale = (d, r = 1)->
		z = 35
		vertices = [
			[25, 7, 38], [26,0, 38], [25,-7, 38], 
			[25, 7, 11], [26,0, 11], [25,-7, 11], # 6
			[25, 7, -1], [26,0, -1], [25,-7, -1],
			[25, 7,-35], [26,0,-35], [25,-7,-35], # 12
			[65, 12, 24], [65,-12, 24],
			[65, 22, 11], [65,-22, 11], # 16
			[65, 22, -1], [65,-22, -1],
			[65, 12,-24], [65,-12,-24], # 20
			[65,  1*r, 20], [65,  1*r,-20], 
			[65, 11*r,-20], [65, 11*r, 20], # 24
			[65+z,  1*r+z*r, 20], [65+z,  1*r+z*r,-20], 
			[65+z-5, 6*r+z*r,-20], [65+z-5, 6*r+z*r, 20]
		]
		faces = [
			[ 0, 1,12], [ 1,13,12], [ 1, 2,13], # top
			[ 9,18,10], [10,18,19], [10,19,11], # bottom
			[ 1, 0, 4], [ 4, 0, 3], [ 2, 1, 5], [ 5, 1, 4], # innen
			[ 7, 6,10], [10, 6, 9], [ 8, 7,11], [11, 7,10], # innen
			[ 4, 3,14], [ 4,14,15], [ 5, 4,15], # zwischen
			[ 6, 7,16], [ 7,17,16], [ 7, 8,17], # zwischen
			[14,17,15], [14,16,17], [14,15,17], [14,17,16], 
			[ 3, 0,14], [ 0,12,14], [16, 9, 6], [18, 9,16], #links
			[ 2, 5,15], [ 2,15,13], [17, 8,11], [17,11,19],
			[12,13,14], [13,15,14], [16,17,18], [17,19,18], # HINTEN
		]
		facesD = [
			[20,21,25], [20,25,24], [22,23,27], [22,27,26],
			[20,27,23], [20,24,27], [21,22,26], [21,26,25],
			[24,25,26], [24,26,27]
		]
		for fd in facesD
			if r > 0
				faces.push fd
			else
				faces.push [fd[1], fd[0], fd[2]]
		
		kkd = new THREE.CustomGeometry vertices, faces
		kkd.applyMatrix _m(0,0,0, 'Z', .5*r*d)
		kkd
	
	_VertikalDiagonale = (w, s = 1, h = 2000) ->
		vd = new THREE.Geometry()
		r = new THREE.Geometry()
		s *= -1
		
		bohrAbstand = Math.sqrt(Math.pow(w - 155, 2) + Math.pow(h, 2))
		degree = Math.atan2 w-155, h
		
		vd.merge _keilKupplungDiagonale(-1, 1*s)
		vd.merge _keilKupplungDiagonale(-1,-1*s), _m(w, 0, h, 'Z', 2)
		
		offset = if s > 0 then 14 else 7
		
		r.merge new THREE.BoxGeometry(35,10,60), _m( 0, 0,  10)
		r.merge _cylinder(16,0,21), _m( 0, offset, 0, 'X', 1)
		r.merge _barToCircle(35, 10, 70, RohrDurchmesserAussen / 2), _m( 0, 0, 110, 'X', 2)
		r.merge _cylinder(
			RohrDurchmesserAussen, RohrDurchmesserInnen, 
			bohrAbstand-220
		), _m( 0, 0, 110)
		r.merge _barToCircle(35, 10, 70, RohrDurchmesserAussen / 2), _m( 0, 0, bohrAbstand-110)
		r.merge new THREE.BoxGeometry(35,10,60), _m( 0, 0, bohrAbstand-10)
		r.merge _cylinder(16,0,21), _m( 0, offset, bohrAbstand, 'X', 1)
		
		vd.merge r, _m(77.5, -50 * s, 0, 'Y', degree / D90)
		vd
	
	_keilKupplungRiegel = ->
		vertices = [
			[25, 7, 38], [26,0, 38], [25,-7, 38], 
			[25, 7, 11], [26,0, 11], [25,-7, 11],
			[25, 7, -1], [26,0, -1], [25,-7, -1],
			[25, 7,-35], [26,0,-35], [25,-7,-35], # 12
			[65, 12, 24], [65,-12, 24],
			[65, 22, 11], [65,-22, 11],
			[65, 22, -1], [65,-22, -1],
			[65, 12,-24], [65,-12,-24], # 20
			[77,  0, 24], [77,-17, 17], 
			[77,-24,  0], [77,-17,-17], 
			[77,  0,-24], [77, 17,-17], 
			[77, 24,  0], [77, 17, 17]
		]
		faces = [
			[ 0, 1,12], [ 1,13,12], [ 1, 2,13], # top
			[ 9,18,10], [10,18,19], [10,19,11], # bottom
			[ 1, 0, 4], [ 4, 0, 3], [ 2, 1, 5], [ 5, 1, 4], # innen
			[ 7, 6,10], [10, 6, 9], [ 8, 7,11], [11, 7,10], # innen
			[ 4, 3,14], [ 4,14,15], [ 5, 4,15], # zwischen
			[ 6, 7,16], [ 7,17,16], [ 7, 8,17], # zwischen
			[14,17,15], [14,16,17],
			[ 3, 0,14], [ 0,12,14], [16, 9, 6], [18, 9,16], #links
			[ 2, 5,15], [ 2,15,13], [17, 8,11], [17,11,19],
			[20,12,13], [20,13,21], [21,13,15], [21,15,22],
			[22,15,17], [22,17,23], [23,17,19], [23,19,24],
			[24,19,18], [24,18,25], [25,18,16], [25,16,26],
			[26,16,14], [26,14,27], [27,14,12], [27,12,20]
		]
		new THREE.CustomGeometry vertices, faces
	
	_Riegel = (l) ->
		r = _cylinder RohrDurchmesserAussen, RohrDurchmesserInnen, l - 150
		r.applyMatrix _m(75, 0, 0, 'Y', 1)
		r.merge _keilKupplungRiegel()
		r.merge _keilKupplungRiegel(), _m(l, 0, 0, 'Z', 2)
		r.applyMatrix _m(0,0,0, 'X', -1)
		r
	
	_DoppelRiegel = (l) ->
		r = _cylinder RohrDurchmesserAussen, RohrDurchmesserInnen, l - 150
		r.applyMatrix _m(75, 0, 0, 'Y', 1)
		r.merge _keilKupplungRiegel()
		r.merge _keilKupplungRiegel(), _m(l, 0, 0, 'Z', 2)
		
		p = new THREE.CurvePath();
		p.add(new THREE.LineCurve3((new THREE.Vector3(    0,   0, 0)),(new THREE.Vector3(  200, 100, 0))));
		p.add(new THREE.LineCurve3((new THREE.Vector3(  200, 100, 0)),(new THREE.Vector3(l-350, 100, 0))));
		p.add(new THREE.LineCurve3((new THREE.Vector3(l-350, 100, 0)),(new THREE.Vector3(l-150,   0, 0))));
		r2 = _cylinderPath RohrDurchmesserAussen*.6, RohrDurchmesserInnen*.6, p
		r2.applyMatrix _m(75, 0, 0, 'X',-1)
		r.merge r2
		
		for i in [500..l-1] by 500
			f = new THREE.BoxGeometry(100,100,5)
			f.applyMatrix _m(i, 0,-50, 'X', 1)
			r.merge f
		
		r.applyMatrix _m(0,0,0, 'X', -1)
		r
	
	_teller = ->
		_cylinder TellerDurchmesser, RohrDurchmesserAussen, TellerHoehe
	
	_rohrverbinder = ->
		rv = _cylinder 45, 30, 400
		rv.applyMatrix _m(0,0,-200)
		rv
	
	_VertikalStiel = (l, rv = 1) ->
		v = new THREE.Geometry()
		v.merge _rohr(l), _m(0,0,100)
		for i in [500..l] by 500
			v.merge _teller(), _m(0,0,i)
		v.merge _rohrverbinder(), _m(0,0,l) if rv is 1
		v.applyMatrix _m(0,0,0, 'X', -1)
		v
	
	FX = (l,x,y,z,o) ->
		f = _threadCyl 10*l
		f.merge new THREE.BoxGeometry(100,100,5)
		f.merge new THREE.BoxGeometry(120,40,10), _m(0,0,70, 'Z', .5)
		if parseInt(o) < 0 or (o and o[0] is 'n') or o is '-'
			f.applyMatrix _m(10*x,10*y+175,10*z,'X', 1)
		else
			f.applyMatrix _m(10*x,10*y-144,10*z,'X', -1)
		f
	
	VX = (l,x,y,z,o) ->
		d = 0
		rv = 1
		if o
			for s in o.split ','
				d = 2 if parseInt(s) < 0 or (s and s[0] is 'n') or s is '-' 
				rv = 0 if s[0] is 'o'
		v = _VertikalStiel 10*l, rv
		v.applyMatrix _m(10*x, 10*y, 10*z, 'X', d)
		v
	
	RX = (l,x,y,z,d) ->
		r = _Riegel 10*l
		switch d
			when "X" then d = 0
			when "Y" then d = 1
			when "-X" then d = 2
			when "-Y" then d = 3
			else return
				
		r.applyMatrix _m(10*x, 10*y, 10*z, 'Y', -d)
		r
	
	DRX = (l,x,y,z,d) ->
		r = _DoppelRiegel 10*l
		switch d
			when "X" then d = 0
			when "Y" then d = 1
			when "-X" then d = 2
			when "-Y" then d = 3
			else return
				
		r.applyMatrix _m(10*x, 10*y, 10*z, 'Y', -d)
		r
	
	VDX = (w,h,x,y,z,d,o) ->
		s = -1
		switch d
			when "X" then d = 0
			when "Y" then d = 1
			when "-X" then d = 2
			when "-Y" then d = 3
			else return
		s = if d == 1 or d == 2 then 1 else -1
		s *= -1 if parseInt(o) < 0 or (o and o[0] is 'n') or o is '-'
		vd = _VertikalDiagonale 10*w, s, 10*h
		vd.applyMatrix _m(0,0,0,'X', -1)
		vd.applyMatrix _m(0,0,0,'Y', -d)
		vd.applyMatrix _m(10*x, 10*y, 10*z)
		vd
	
	BX = (l,x,y,z,d,s) ->
		bl = new THREE.Geometry()
		s = s.split '/'
		o = 0
		w = s[0]
		if s.length >= 2 and parseInt s[1]
			o = parseInt s[1]
		
		for b in w.split(',')
			bl.merge _Belag(10*l, 10*b, o)
			o += 10*b + 5
		
		switch d
			when  "X" then bl.applyMatrix _m(10*x + 10*l, 10*y, 10*z, 'Y', -1)
			when  "Y" then bl.applyMatrix _m(10*x, 10*y, 10*z)
			when "-X" then bl.applyMatrix _m(10*x, 10*y, 10*z, 'Y', 1)
			when "-Y" then bl.applyMatrix _m(10*x, 10*y, 10*z+10*l, 'Y', 2)
		bl
	
	AnfSt = (x,y,z) ->
		a = do _AnfStk
		a.applyMatrix _m(10*x, 10*y, 10*z)
		a
	
	constructor: ->
		console.log "EGS_Elements constructed"
	
	getGeometry: (element) ->
		n = element.get 'element'
		x = element.get 'x'
		z = element.get 'y'
		h = element.get 'h'
		d = element.get 'direction'
		s = element.get 'special'
#		console.log n,x,z,h,d,s
		
		switch n
			when "AnfSt" then AnfSt x, h, z
			when "V50" then VX 50, x, h, z, s
			when "V100" then VX 100, x, h, z, s
			when "V150" then VX 150, x, h, z, s
			when "V200" then VX 200, x, h, z, s
			when "V300" then VX 300, x, h, z, s
			when "V400" then VX 400, x, h, z, s
			when "R25" then RX 25, x, h, z, d
			when "R50" then RX 50, x, h, z, d
			when "R100" then RX 100, x, h, z, d
			when "R200" then RX 200, x, h, z, d
			when "R300" then RX 300, x, h, z, d
			when "DR100" then DRX 100, x, h, z, d
			when "DR200" then DRX 200, x, h, z, d
			when "DR300" then DRX 300, x, h, z, d
			when "D100" then VDX 100, 200, x, h, z, d, s
			when "D150" then VDX 150, 200, x, h, z, d, s
			when "D200" then VDX 200, 200, x, h, z, d, s
			when "D300" then VDX 300, 200, x, h, z, d, s
			when "DS200" then VDX 200, 100, x, h, z, d, s
			when "F40" then FX 40, x, h, z, s
			when "F60" then FX 40, x, h, z, s
			when "B100" then BX 100, x, h, z, d, s
			when "B200" then BX 200, x, h, z, d, s
			when "B300" then BX 300, x, h, z, d, s
			else new THREE.Geometry()
	
module.exports = EGS_Elements
