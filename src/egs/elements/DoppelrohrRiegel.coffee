THREE = require "THREE"
{ Helpers } = require "../Helpers"
Common = require "../Common"

class DoppelrohrRiegel extends THREE.Geometry
	
	_DoppelrohrRiegel: (length) ->
		r = Helpers.cylinder Common.RohrDurchmesserAussen, Common.RohrDurchmesserInnen, length - 150
		r.applyMatrix4 Helpers.matrix(75, 0, 0, 'Y', 1)
		r.merge Common.keilKupplungRiegel()
		r.merge Common.keilKupplungRiegel(), Helpers.matrix(length, 0, 0, 'Z', 2)
		
		p = new THREE.CurvePath();
		p.add(new THREE.LineCurve3((new THREE.Vector3(    0,   0, 0)),(new THREE.Vector3(  200, 100, 0))));
		p.add(new THREE.LineCurve3((new THREE.Vector3(  200, 100, 0)),(new THREE.Vector3(length-350, 100, 0))));
		p.add(new THREE.LineCurve3((new THREE.Vector3(length-350, 100, 0)),(new THREE.Vector3(length-150,   0, 0))));
		r2 = Helpers.cylinderPath Common.RohrDurchmesserAussen*.6, Common.RohrDurchmesserInnen*.6, p
		r2.applyMatrix4 Helpers.matrix(75, 0, 0, 'X',-1)
		r.merge r2
		
		for i in [500..length-1] by 500
			f = new THREE.BoxGeometry(100,100,5)
			f.applyMatrix4 Helpers.matrix(i, 0,-50, 'X', 1)
			r.merge f
		
		r.applyMatrix4 Helpers.matrix(0,0,0, 'X', -1)
		r
	
	constructor: (length, x, y, h, direction) ->
		super()

		switch direction
			when "X" then direction = 0
			when "Y" then direction = 1
			when "-X" then direction = 2
			when "-Y" then direction = 3
			else throw new Error('Drehrichtung muss X, Y oder -X, -Y sein')

		@merge @_DoppelrohrRiegel(10 * length)
		
		@applyMatrix4 Helpers.matrix(10*x, 10*h, 10*y, 'Y', -direction)
	
module.exports = DoppelrohrRiegel
