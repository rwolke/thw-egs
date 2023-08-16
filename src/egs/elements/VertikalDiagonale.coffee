THREE = require "THREE"
{ Helpers } = require "../Helpers"
Common = require "../Common"

class VertikalDiagonale extends THREE.Geometry

	_VertikalDiagonale: (width, s = 1, height = 2000) ->
		vd = new THREE.Geometry()
		r = new THREE.Geometry()
		s *= -1
		
		bohrAbstand = Math.sqrt(Math.pow(width - 155, 2) + Math.pow(height, 2))
		degree = Math.atan2 width-155, height
		
		vd.merge Common.keilKupplungDiagonale(-1, 1*s)
		vd.merge Common.keilKupplungDiagonale(-1,-1*s), Helpers.matrix(width, 0, height, 'Z', 2)
		
		offset = if s > 0 then 14 else 7
		
		r.merge new THREE.BoxGeometry(35,10,60), Helpers.matrix( 0, 0,  10)
		r.merge Helpers.cylinder(16,0,21), Helpers.matrix( 0, offset, 0, 'X', 1)
		r.merge Helpers.barToCircle(35, 10, 70, Common.RohrDurchmesserAussen / 2), Helpers.matrix( 0, 0, 110, 'X', 2)
		r.merge Helpers.cylinder(
			Common.RohrDurchmesserAussen, Common.RohrDurchmesserInnen, 
			bohrAbstand-220
		), Helpers.matrix( 0, 0, 110)
		r.merge Helpers.barToCircle(35, 10, 70, Common.RohrDurchmesserAussen / 2), Helpers.matrix( 0, 0, bohrAbstand-110)
		r.merge new THREE.BoxGeometry(35,10,60), Helpers.matrix( 0, 0, bohrAbstand-10)
		r.merge Helpers.cylinder(16,0,21), Helpers.matrix( 0, offset, bohrAbstand, 'X', 1)
		
		vd.merge r, Helpers.matrix(77.5, -50 * s, 0, 'Y', degree / Helpers.D90)
		vd
	
	constructor: (width, height, x, y, h, direction, special) ->
		super()

		s = -1
		switch direction
			when "X" then direction = 0
			when "Y" then direction = 1
			when "-X" then direction = 2
			when "-Y" then direction = 3
			else throw new Error('Drehrichtung muss X, Y oder -X, -Y sein')
		s = if direction == 1 or direction == 2 then 1 else -1
		s *= -1 if parseInt(special) < 0 or (special and special[0] is 'n') or special is '-'

		@merge @_VertikalDiagonale(10*width, s, 10*height)

		@applyMatrix4 Helpers.matrix(0,0,0,'X', -1)
		@applyMatrix4 Helpers.matrix(0,0,0,'Y', -direction)
		@applyMatrix4 Helpers.matrix(10*x, 10*h, 10*y)
	
module.exports = VertikalDiagonale
