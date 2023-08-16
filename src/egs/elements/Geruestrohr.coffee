THREE = require "THREE"
{ Helpers } = require "../Helpers"
Common = require "../Common"

class Geruestrohr extends THREE.Geometry

	_Geruestrohr: (length) ->
		r = new THREE.Geometry
		r.merge Common.rohr(length)
		r.applyMatrix4 Helpers.matrix(0,0,0, 'Y', 1)
		r.applyMatrix4 Helpers.matrix(0,0,0, 'X', -1)
		r
	
	constructor: (length, x, y, h, direction, special) ->
		super()

		@merge @_Geruestrohr(10 * length)

		if special
			for b in special.split('/')
				c = b.split('=')
				if (c.length == 2)
					switch c[0].trim()
						when "RX"
							rot = -1 * parseFloat(c[1].trim())
							@applyMatrix4 Helpers.matrix(0, 0, 0, 'X', rot / 90)
						when "RZ"
							rot = -1 * parseFloat(c[1].trim())
							@applyMatrix4 Helpers.matrix(0, 0, 0, 'Y', rot / 90)
						when "RY"
							rot = -1 * parseFloat(c[1].trim())
							@applyMatrix4 Helpers.matrix(0, 0, 0, 'Z', rot / 90)
						else throw new Error('Drehung muss RX, RY oder RZ sein')
		
		@applyMatrix4 Helpers.matrix(10*x, 10*h, 10*y)
	
module.exports = Geruestrohr
