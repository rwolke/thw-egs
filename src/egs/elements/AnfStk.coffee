THREE = require "THREE"
{ Helpers } = require "../Helpers"
Common = require "../Common"

class AnfStk extends THREE.Geometry

	_AnfStk: ->
		a = new THREE.Geometry
		a.merge Common.rohr(165), Helpers.matrix(0,0,-65)
		a.merge Common.teller()
		a.merge Helpers.cylinder(55,49,170), Helpers.matrix(0,0,95)
		a.applyMatrix4 Helpers.matrix(0,0,0, 'X', -1)
		a
	
	constructor: (x, y, h) ->
		super()

		@merge @_AnfStk()
		
		@applyMatrix4 Helpers.matrix(10*x, 10*h, 10*y)
	
module.exports = AnfStk
