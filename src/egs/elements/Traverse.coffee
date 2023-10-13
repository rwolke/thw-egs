THREE = require "THREE"
{ Helpers } = require "../Helpers"
Common = require "../Common"

class Traverse extends THREE.Geometry
	
	_Traverse: (length) ->
		AbstandVonVertikale = 150
		AbstandVonVertikalstreben = Common.RohrDurchmesserAussen

		# Oberer Riegel
		t = Common.rohr(length - 150)
		t.applyMatrix4 Helpers.matrix(75, 0, 0, 'Y', 1)
		t.merge Common.keilKupplungRiegel()
		t.merge Common.keilKupplungRiegel(), Helpers.matrix(length, 0, 0, 'Z', 2)

		# Unterer Riegel
		p = Common.rohr(length - 150)
		p.applyMatrix4 Helpers.matrix(75, 0, 0, 'Y', 1)
		p.merge Common.keilKupplungRiegel()
		p.merge Common.keilKupplungRiegel(), Helpers.matrix(length, 0, 0, 'Z', 2)
		p.applyMatrix4 Helpers.matrix(0, 0, -500)
		t.merge p

		# Vertikalstreben
		n = (length/1000)  # Anzahl Felder
		b = (length - (AbstandVonVertikale * 2)) / n # Feldbreite für Vertikalstreben
		for i in [0..n]
			f = Common.rohr(500)
			f.applyMatrix4 Helpers.matrix((i * b) + AbstandVonVertikale, 0, -500)
			t.merge f

		c = b - (2 * AbstandVonVertikalstreben) - (2 * Common.RohrDurchmesserAussen) # Feldbreite für Diagonalstreben
		# Diagonalstreben
		for i in [0..n - 1]
			f = Common.rohr(Math.sqrt(Math.pow(500,2) + Math.pow(c/2,2)))
			f.applyMatrix4 Helpers.matrix((i * b) + AbstandVonVertikale + AbstandVonVertikalstreben, 0, -500, 'Y', 1 * (Math.atan((c/2)/500) / Helpers.D90))
			t.merge f

			f = Common.rohr(Math.sqrt(Math.pow(c/2,2) + Math.pow(500,2)))
			f.applyMatrix4 Helpers.matrix((i * b) + AbstandVonVertikale + AbstandVonVertikalstreben + c + (2 * Common.RohrDurchmesserAussen), 0, -500, 'Y', -1 * (Math.atan((c/2)/500) / Helpers.D90))
			t.merge f
		
		t.applyMatrix4 Helpers.matrix(0,0,0, 'X', -1)
		t
	
	constructor: (length, x, y, h, direction) ->
		super()

		switch direction
			when "X" then direction = 0
			when "Y" then direction = 1
			when "-X" then direction = 2
			when "-Y" then direction = 3
			else throw new Error('Drehrichtung muss X, Y oder -X, -Y sein')

		@merge @_Traverse(10 * length)
		
		@applyMatrix4 Helpers.matrix(10*x, 10*h, 10*y, 'Y', -direction)
	
module.exports = Traverse
