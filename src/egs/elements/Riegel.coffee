THREE = require "THREE"
{ Helpers } = require "../Helpers"
Common = require "../Common"

class Riegel extends THREE.Geometry
	
	_Riegel: (length) ->
		r = Helpers.cylinder Common.RohrDurchmesserAussen, Common.RohrDurchmesserInnen, length - 150
		r.applyMatrix4 Helpers.matrix(75, 0, 0, 'Y', 1)
		r.merge Common.keilKupplungRiegel()
		r.merge Common.keilKupplungRiegel(), Helpers.matrix(length, 0, 0, 'Z', 2)
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

		@merge @_Riegel(10 * length)
		
		@applyMatrix4 Helpers.matrix(10*x, 10*h, 10*y, 'Y', -direction)
	
module.exports = Riegel
