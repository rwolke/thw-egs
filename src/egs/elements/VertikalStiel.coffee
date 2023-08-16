THREE = require "THREE"
{ Helpers } = require "../Helpers"
Common = require "../Common"

class VertikalStiel extends THREE.Geometry

	_VertikalStiel: (length, rv = 1) ->
		v = new THREE.Geometry()
		v.merge Common.rohr(length), Helpers.matrix(0,0,100)
		for i in [500..length] by 500
			v.merge Common.teller(), Helpers.matrix(0,0,i)
		v.merge Common.rohrverbinder(), Helpers.matrix(0,0,length) if rv is 1
		v.applyMatrix4 Helpers.matrix(0,0,0, 'X', -1)
		v
	
	constructor: (length, x, y, h, special) ->
		super()

		direction = 0
		rv = 1
		if special
			for s in special.split ','
				direction = 2 if parseInt(s) < 0 or (s and s[0] is 'n') or s is '-' 
				rv = 0 if s[0] is 'o'

		@merge @_VertikalStiel(10 * length, rv)
		
		@applyMatrix4 Helpers.matrix(10*x, 10*h, 10*y, 'X', direction)
	
module.exports = VertikalStiel
