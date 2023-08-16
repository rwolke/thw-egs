THREE = require "THREE"
{ Helpers } = require "../Helpers"
Common = require "../Common"

class HaengegeruestVerbinder extends THREE.Geometry
	
	_HaengegeruestVerbinder: ->
		rv = new THREE.BoxGeometry(10,50,550)
		rv.applyMatrix4 Helpers.matrix(82, 0, 250)
		rv.merge Common.keilKupplungRiegel(), Helpers.matrix(0, 0, 0)
		rv.merge Common.keilKupplungRiegel(), Helpers.matrix(0, 0, 500)
		rv.applyMatrix4 Helpers.matrix(0,0,0, 'X', -1)
		rv
	
	constructor: (x, y, h, direction) ->
		super()

		switch direction
			when "X" then direction = 0
			when "Y" then direction = 1
			when "-X" then direction = 2
			when "-Y" then direction = 3
			else throw new Error('Drehrichtung muss X, Y oder -X, -Y sein')

		@merge @_HaengegeruestVerbinder()
		
		@applyMatrix4 Helpers.matrix(10*x, 10*h, 10*y, 'Y', -direction)
	
module.exports = HaengegeruestVerbinder
