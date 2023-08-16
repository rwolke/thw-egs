THREE = require "THREE"
{ Helpers } = require "../Helpers"
Common = require "../Common"

class EuroPalette extends THREE.Geometry

	_EuroPalette: ->
		p = new THREE.Geometry()
		p.merge new THREE.BoxGeometry(1200, 22   ,100 ), Helpers.matrix( 0           ,0 + 22 / 2   , 400 - 50 )
		p.merge new THREE.BoxGeometry(1200 ,22   ,145 ), Helpers.matrix( 0           ,0 + 22 / 2   , 0   )
		p.merge new THREE.BoxGeometry(1200 ,22   ,100 ), Helpers.matrix( 0           ,0 + 22 / 2   ,-400 + 50 )

		p.merge new THREE.BoxGeometry(145  ,78   ,100  ), Helpers.matrix(-600 + 72.5 ,22 + 78 / 2  ,-400 + 50 )
		p.merge new THREE.BoxGeometry(145  ,78   ,145  ), Helpers.matrix(-600 + 72.5 ,22 + 78 / 2  , 0   )
		p.merge new THREE.BoxGeometry(145  ,78   ,100  ), Helpers.matrix(-600 + 72.5 ,22 + 78 / 2  , 400 - 50 )
		p.merge new THREE.BoxGeometry(145  ,78   ,100  ), Helpers.matrix( 600 - 72.5 ,22 + 78 / 2  ,-400 + 50 )
		p.merge new THREE.BoxGeometry(145  ,78   ,145  ), Helpers.matrix( 600 - 72.5 ,22 + 78 / 2  , 0   )
		p.merge new THREE.BoxGeometry(145  ,78   ,100  ), Helpers.matrix( 600 - 72.5 ,22 + 78 / 2  , 400 - 50 )
		p.merge new THREE.BoxGeometry(145  ,78   ,100  ), Helpers.matrix( 0          ,22 + 78 / 2  ,-400 + 50 )
		p.merge new THREE.BoxGeometry(145  ,78   ,145  ), Helpers.matrix( 0          ,22 + 78 / 2  , 0   )
		p.merge new THREE.BoxGeometry(145  ,78   ,100  ), Helpers.matrix( 0          ,22 + 78 / 2  , 400 - 50 )

		p.merge new THREE.BoxGeometry(145  ,22   ,800 ), Helpers.matrix(-600 + 72.5  ,100 + 22 / 2 , 0 )
		p.merge new THREE.BoxGeometry(145  ,22   ,800 ), Helpers.matrix( 0           ,100 + 22 / 2 , 0   )
		p.merge new THREE.BoxGeometry(145  ,22   ,800 ), Helpers.matrix( 600 - 72.5  ,100 + 22 / 2 , 0 )

		p.merge new THREE.BoxGeometry(1200  ,22   ,100 ), Helpers.matrix( 0          ,122 + 22 / 2 , 400 - 50 )
		p.merge new THREE.BoxGeometry(1200  ,22   ,100 ), Helpers.matrix( 0          ,122 + 22 / 2 , 145 + 40   )
		p.merge new THREE.BoxGeometry(1200  ,22   ,145 ), Helpers.matrix( 0          ,122 + 22 / 2 , 0 )
		p.merge new THREE.BoxGeometry(1200  ,22   ,100 ), Helpers.matrix( 0          ,122 + 22 / 2 , -145 - 40 )
		p.merge new THREE.BoxGeometry(1200  ,22   ,100 ), Helpers.matrix( 0          ,122 + 22 / 2 , -400 + 50   )

		p
	
	constructor: (x, y, h, direction) ->
		super()

		@merge @_EuroPalette()

		switch direction
			when "X" then direction = 0
			when "Y" then direction = 1
			when "-X" then direction = 2
			when "-Y" then direction = 3
			else throw new Error('Drehrichtung muss X, Y oder -X, -Y sein')
		
		@applyMatrix4 Helpers.matrix(10*x, 10*h + 50, 10*y, 'Y', -direction)
	
module.exports = EuroPalette
