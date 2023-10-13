THREE = require "THREE"
{ Helpers } = require "../Helpers"
Common = require "../Common"

class GewindeFussPlatte extends THREE.Geometry

	_GewindeFussPlatte: (length) ->
		f = Helpers.threadCyl length
		f.merge new THREE.BoxGeometry(100,100,5)
		f.merge new THREE.BoxGeometry(120,40,10), Helpers.matrix(0,0,70, 'y', .5)
		f
	
	constructor: (length, x, y, h, special)  ->
		super()

		@merge @_GewindeFussPlatte(10 * length)
		
		if parseInt(special) < 0 or (special and special[0] is 'n') or special is '-'
			@applyMatrix4 Helpers.matrix(10*x,10*h+175,10*y,'X', 1)
		else
			@applyMatrix4 Helpers.matrix(10*x,10*h-144,10*y,'X', -1)
	
module.exports = GewindeFussPlatte
