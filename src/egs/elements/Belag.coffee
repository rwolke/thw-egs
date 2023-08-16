THREE = require "THREE"
{ Helpers, CustomGeometry } = require "../Helpers"
Common = require "../Common"

class Belag extends THREE.Geometry

	_BelagKlammer: (x) ->
		shape = new THREE.Shape()
		y = 30
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
		bk = new THREE.ExtrudeGeometry shape,
			depth: 40
			steps: 1
			bevelEnabled: false
			curveSegments: Helpers.DETAIL
		bk.applyMatrix4 Helpers.matrix(x, 0, 55, 'Y', 1)
		bk
	
	_BelagRahmen: (length, b) ->
		o = 50
		vertices = [
			# oberkante
			[ 0, 45,  o],[  b, 45,  o],[  b, 45,  length-o],[ 0, 45,  length-o], 
			# unterkante
			[ 0,-30,  o],[  b,-30,  o],[  b,-30,  length-o],[ 0,-30,  length-o], 
			# unterkante innen
			[ 5,-30,o+5],[b-5,-30,o+5],[b-5,-30,length-o-5],[ 5,-30,length-o-5], 
			# oberkante innen
			[ 5, 40,o+5],[b-5, 40,o+5],[b-5, 40,length-o-5],[ 5, 40,length-o-5], 
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
		new CustomGeometry vertices, faces
	
	_Belag: (length, w, x = 0) ->
		b = new THREE.Geometry
		b.merge @_BelagKlammer(1), Helpers.matrix(  60,0,0)
		b.merge @_BelagKlammer(1), Helpers.matrix(w-60,0,0)
		b.merge @_BelagRahmen(length, w), Helpers.matrix(0,0,0)
		b.merge @_BelagKlammer(1), Helpers.matrix(  60,0,length, 'Y', 2)
		b.merge @_BelagKlammer(1), Helpers.matrix(w-60,0,length, 'Y', 2)
		b.applyMatrix4 Helpers.matrix(55+x, 0, 0)
		b
	
	constructor: (length, x, y, h, direction, special) ->
		super()

		special = special.split '/'
		o = 0
		w = special[0]
		if special.length >= 2 and parseInt special[1]
			o = parseInt special[1]
		
		for b in w.split(',')
			@merge @_Belag(10*length, 10*b, o)
			o += 10*b + 5
		
		switch direction
			when  "X" then @applyMatrix4 Helpers.matrix(10*x + 10*length, 10*h, 10*y, 'Y', -1)
			when  "Y" then @applyMatrix4 Helpers.matrix(10*x, 10*h, 10*y)
			when "-X" then @applyMatrix4 Helpers.matrix(10*x, 10*h, 10*y, 'Y', 1)
			when "-Y" then @applyMatrix4 Helpers.matrix(10*x, 10*h, 10*y+10*length, 'Y', 2)
			else throw new Error('Drehrichtung muss X, Y oder -X, -Y sein')
	
module.exports = Belag
