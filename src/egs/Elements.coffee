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
			when "V300" then new VertikalStiel 300, x, y, h, special
			when "V400" then new VertikalStiel 400, x, y, h, special

			when "R25" then new Riegel 25, x, y, h, direction
			when "R50" then new Riegel 50, x, y, h, direction
			when "R100" then new Riegel 100, x, y, h, direction
			when "R200" then new Riegel 200, x, y, h, direction
			when "R300" then new Riegel 300, x, y, h, direction

			when "DR100" then new DoppelrohrRiegel 100, x, y, h, direction
			when "DR200" then new DoppelrohrRiegel 200, x, y, h, direction
			when "DR300" then new DoppelrohrRiegel 300, x, y, h, direction

			when "D100" then new VertikalDiagonale 100, 200, x, y, h, direction, special
			when "D150" then new VertikalDiagonale 150, 200, x, y, h, direction, special
			when "D200" then new VertikalDiagonale 200, 200, x, y, h, direction, special
			when "D300" then new VertikalDiagonale 300, 200, x, y, h, direction, special
			when "DS200" then new VertikalDiagonale 200, 100, x, y, h, direction, special

			when "B100" then new Belag 100, x, y, h, direction, special
			when "B200" then new Belag 200, x, y, h, direction, special
			when "B300" then new Belag 300, x, y, h, direction, special

			when "HV" then new HaengegeruestVerbinder x, y, h, direction

			else throw new Error('Unbekanntes Element')
	
module.exports = EGS_Elements
