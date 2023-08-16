GewindeFussPlatte = require("./elements/GewindeFussPlatte")
AnfSt = require("./elements/AnfStk")
VertikalStiel = require("./elements/VertikalStiel")
Riegel = require("./elements/Riegel")
DoppelrohrRiegel = require("./elements/DoppelrohrRiegel")
VertikalDiagonale = require("./elements/VertikalDiagonale")
Belag = require("./elements/Belag")
HaengegeruestVerbinder = require("./elements/HaengegeruestVerbinder")

class EGS_Elements
	
	getGeometry: (element) ->
		name = element.get 'element'
		x = element.get 'x'
		y = element.get 'y'
		h = element.get 'h'
		direction = element.get 'direction'
		special = element.get 'special'
		
		switch name
			when "F40" then new GewindeFussPlatte 40, x, y, h, special
			when "F60" then new GewindeFussPlatte 60, x, y, h, special

			when "AnfSt" then new AnfSt x, y, h

			when "V50" then new VertikalStiel 50, x, y, h, special
			when "V100" then new VertikalStiel 100, x, y, h, special
			when "V150" then new VertikalStiel 150, x, y, h, special
			when "V200" then new VertikalStiel 200, x, y, h, special
			when "V250" then new VertikalStiel 250, x, y, h, special
			when "V300" then new VertikalStiel 300, x, y, h, special
			when "V400" then new VertikalStiel 400, x, y, h, special

			when "R15" then new Riegel 15, x, y, h, direction
			when "R25" then new Riegel 25, x, y, h, direction
			when "R50" then new Riegel 50, x, y, h, direction
			when "R75" then new Riegel 75, x, y, h, direction
			when "R100" then new Riegel 100, x, y, h, direction
			when "R125" then new Riegel 125, x, y, h, direction
			when "R150" then new Riegel 150, x, y, h, direction
			when "R200" then new Riegel 200, x, y, h, direction
			when "R250" then new Riegel 250, x, y, h, direction
			when "R300" then new Riegel 300, x, y, h, direction
			when "R400" then new Riegel 400, x, y, h, direction

			when "DR150" then new DoppelrohrRiegel 150, x, y, h, direction
			when "DR200" then new DoppelrohrRiegel 200, x, y, h, direction
			when "DR250" then new DoppelrohrRiegel 250, x, y, h, direction
			when "DR300" then new DoppelrohrRiegel 300, x, y, h, direction

			when "VD50/200" then new VertikalDiagonale 50, 200, x, y, h, direction, special
			when "VD75/200" then new VertikalDiagonale 75, 200, x, y, h, direction, special
			when "VD100/200" then new VertikalDiagonale 100, 200, x, y, h, direction, special
			when "VD150/200" then new VertikalDiagonale 150, 200, x, y, h, direction, special
			when "VD200/200" then new VertikalDiagonale 200, 200, x, y, h, direction, special
			when "VD250/200" then new VertikalDiagonale 250, 200, x, y, h, direction, special
			when "VD300/200" then new VertikalDiagonale 300, 200, x, y, h, direction, special

			when "VD50/150" then new VertikalDiagonale 50, 150, x, y, h, direction, special
			when "VD75/150" then new VertikalDiagonale 75, 150, x, y, h, direction, special
			when "VD100/150" then new VertikalDiagonale 100, 150, x, y, h, direction, special
			when "VD150/150" then new VertikalDiagonale 150, 150, x, y, h, direction, special
			when "VD200/150" then new VertikalDiagonale 200, 150, x, y, h, direction, special
			when "VD250/150" then new VertikalDiagonale 250, 150, x, y, h, direction, special
			when "VD300/150" then new VertikalDiagonale 300, 150, x, y, h, direction, special

			when "VD50/100" then new VertikalDiagonale 50, 100, x, y, h, direction, special
			when "VD75/100" then new VertikalDiagonale 75, 100, x, y, h, direction, special
			when "VD100/100" then new VertikalDiagonale 100, 100, x, y, h, direction, special
			when "VD150/100" then new VertikalDiagonale 150, 100, x, y, h, direction, special
			when "VD200/100" then new VertikalDiagonale 200, 100, x, y, h, direction, special
			when "VD250/100" then new VertikalDiagonale 250, 100, x, y, h, direction, special
			when "VD300/100" then new VertikalDiagonale 300, 100, x, y, h, direction, special

			when "VD100/50" then new VertikalDiagonale 100, 50, x, y, h, direction, special
			when "VD150/50" then new VertikalDiagonale 150, 50, x, y, h, direction, special
			when "VD200/50" then new VertikalDiagonale 200, 50, x, y, h, direction, special
			when "VD300/50" then new VertikalDiagonale 300, 50, x, y, h, direction, special

			# Für Rückwärtskompatibilität
			when "D100" then new VertikalDiagonale 100, 200, x, y, h, direction, special
			when "D150" then new VertikalDiagonale 150, 200, x, y, h, direction, special
			when "D200" then new VertikalDiagonale 200, 200, x, y, h, direction, special
			when "D300" then new VertikalDiagonale 300, 200, x, y, h, direction, special
			when "DS200" then new VertikalDiagonale 200, 100, x, y, h, direction, special

			when "B75" then new Belag 75, x, y, h, direction, special
			when "B100" then new Belag 100, x, y, h, direction, special
			when "B150" then new Belag 150, x, y, h, direction, special
			when "B200" then new Belag 200, x, y, h, direction, special
			when "B250" then new Belag 250, x, y, h, direction, special
			when "B300" then new Belag 300, x, y, h, direction, special

			when "HV" then new HaengegeruestVerbinder x, y, h, direction

			else throw new Error('Unbekanntes Element')
	
module.exports = EGS_Elements
