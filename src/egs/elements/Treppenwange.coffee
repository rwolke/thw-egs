THREE = require "THREE"
{ Helpers } = require "../Helpers"
Common = require "../Common"

class Treppenwange extends THREE.Geometry
	
	_Treppenwange: (height, side) ->
		TiefeStufe = 270
		HoheStufe = 50
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
		switch side
			when 'R' then side = 1
			when 'L' then side = -1
			else return

		w = new THREE.Geometry()
		w.merge Common.keilKupplungDiagonale(-1, -1 * side)
		w.merge Common.keilKupplungDiagonale(-1, 1 * side), Helpers.matrix(TiefeFeld, 0, height, 'Z', 2)
		p = new THREE.CurvePath();
		p.add(new THREE.LineCurve3((new THREE.Vector3(0, Common.RohrDurchmesserAussen / 2, dh * 2)),(new THREE.Vector3(dx * n, Common.RohrDurchmesserAussen / 2, dh * 2 + height))));
		p.add(new THREE.LineCurve3((new THREE.Vector3(dx * n, Common.RohrDurchmesserAussen / 2, dh * 2 + height)),(new THREE.Vector3(dx * n, Common.RohrDurchmesserAussen / 2, height))));
		p.add(new THREE.LineCurve3((new THREE.Vector3(dx * n, Common.RohrDurchmesserAussen / 2, height)),(new THREE.Vector3(0, Common.RohrDurchmesserAussen / 2, 0))));
		p.add(new THREE.LineCurve3((new THREE.Vector3(0, Common.RohrDurchmesserAussen / 2, 0)),(new THREE.Vector3(0, Common.RohrDurchmesserAussen / 2, dh * 2))));
		r = Helpers.cubicPath Common.RohrDurchmesserAussen, Common.RohrDurchmesserAussen, p
		r.applyMatrix4 Helpers.matrix(Common.RohrDurchmesserAussen, side * 1.5 * Common.RohrDurchmesserAussen, -dh - dh/2)
		w.merge r

		dx = (TiefeFeld - (3 * Common.RohrDurchmesserAussen)) / n
		for i in [0..n - 1]
			t = TiefeStufe + 100
			if (i == 0 || i == (n - 1)) then t = TiefeStufe
			st = new THREE.BoxGeometry(t,Common.RohrDurchmesserAussen,HoheStufe)
			st.applyMatrix4 Helpers.matrix((i * dx) + (TiefeStufe / 2) + Common.RohrDurchmesserAussen, side * 1.5 * Common.RohrDurchmesserAussen, (i * dh))
			w.merge st

		w.applyMatrix4 Helpers.matrix(0,0,0, 'X', -1)
		w
	
	constructor: (length, side, x, y, height, direction) ->
		super()

		switch direction
			when "X" then direction = 0
			when "Y" then direction = 1
			when "-X" then direction = 2
			when "-Y" then direction = 3
			else throw new Error('Drehrichtung muss X, Y oder -X, -Y sein')

		@merge @_Treppenwange(10 * length, side)
		
		@applyMatrix4 Helpers.matrix(10*x, 10*height, 10*y, 'Y', -direction)
	
module.exports = Treppenwange
