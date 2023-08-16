THREE = require "THREE"
{ Helpers } = require "../Helpers"
Common = require "../Common"

class Betonblockstein extends THREE.Geometry
	
	_Noppe: (size, height) ->
		points = [
			# Unten
			new THREE.Vector3( 0, 0, 0 )
			new THREE.Vector3( size, 0, 0 )
			new THREE.Vector3( size, 0, size )
			new THREE.Vector3( 0, 0, size )

			# Oben
			new THREE.Vector3( size / 4, height, size / 4 )
			new THREE.Vector3( 3 * size / 4, height, size / 4 )
			new THREE.Vector3( 3 * size / 4, height, 3 * size / 4 )
			new THREE.Vector3( size / 4, height, 3 * size / 4 )
		];

		n = new THREE.ConvexGeometry points
		n.applyMatrix4 Helpers.matrix(-size/2,0,-size/2)
		n

	_Betonblockstein: (length, width, height) ->
		k = new THREE.BoxGeometry(length,height,width)

		x = Math.floor length / 150 / 2
		y = Math.floor width / 150 / 2
		if x > 0 && y > 0
			for i in [0..(x - 1)]
				for n in [0..(y - 1)]
					k.merge @_Noppe(150, 75), Helpers.matrix(
						(i * 2 * 150) - width / 2 + 75 + (width - (x * 150) - ((x - 1) * 150)) / 2, 
						height/2 ,
						(n * 2 * 150) - width / 2 + 75 + (width - (y * 150) - ((y - 1) * 150)) / 2
					)

		k.applyMatrix4 Helpers.matrix(0,height/2,0)
		#k.applyMatrix4 Helpers.matrix(length/2,height/2,width/2)
	
	constructor: (length, width, height, x, y, h, direction) ->
		super()

		switch direction
			when "X" then direction = 0
			when "Y" then direction = 1
			when "-X" then direction = 2
			when "-Y" then direction = 3
			else throw new Error('Drehrichtung muss X, Y oder -X, -Y sein')

		@merge @_Betonblockstein(10 * length, 10 * width, 10 * height)
		
		@applyMatrix4 Helpers.matrix(10*x, 10*h + 50, 10*y, 'Y', -direction)
	
module.exports = Betonblockstein
