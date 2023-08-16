THREE = require "THREE"
{ Helpers } = require "../Helpers"
Common = require "../Common"

class Treppenstufen extends THREE.Geometry
	
	_Treppenstufen: (height) ->
		BreiteStufe = 1250
		TiefeStufe = 270
		HoheStufe = 50
		BreiteFeld = 1500
		BreiteWange = ((BreiteFeld - BreiteStufe) / 2) - Common.RohrDurchmesserAussen
		switch height
			when 1000
				n = 6
				TiefeFeld = 1500
			when 2000
				n = 12
				TiefeFeld = 3000
			else return
		dh = height / n
		dx = (TiefeFeld - (2 * Common.RohrDurchmesserAussen)) / n

		s = new THREE.Geometry()

		# Stufen
		for i in [0..n - 1]
			st = new THREE.BoxGeometry(TiefeStufe,BreiteStufe,HoheStufe)
			st.applyMatrix4 Helpers.matrix((i * dx) + (TiefeStufe / 2) + Common.RohrDurchmesserAussen, (BreiteStufe / 2) + ((1500 - BreiteStufe) / 2), (i * dh))
			s.merge st
		
		s.applyMatrix4 Helpers.matrix(0,0,0, 'X', -1)
		s
	
	constructor: (length, x, y, height, direction) ->
		super()

		switch direction
			when "X" then direction = 0
			when "Y" then direction = 1
			when "-X" then direction = 2
			when "-Y" then direction = 3
			else throw new Error('Drehrichtung muss X, Y oder -X, -Y sein')

		@merge @_Treppenstufen(10 * length)
		
		@applyMatrix4 Helpers.matrix(10*x, 10*height, 10*y, 'Y', -direction)
	
module.exports = Treppenstufen
