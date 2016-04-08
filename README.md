# EGS Visualisierung

Diese WebApp visualisiert den Aufbau von EGS Konstruktionen. 

## Zweck und Nutzen

Der Aufbau von Gerüstkonstuktionen ist nicht immer trivial, deshalb kann eine Visualsierung die theoretische Ausbildung unterstützen. Der Aufbau kann in eine Vielzahl von Schritten zerlegt werden und Bauteile farblich hervorgehoben werden. Die automatische Rotation bzw. die manuelle Betrachtung von allen Seiten erlauben ein schnelleres Verständnis. 

Wichtig ist, dass die Visualisierung in erster Linie ein Hilfsmittel für die Ausbildung ist. So können verschiedene Aufbauweisen relativ einfach verglichen werden.

Die hinterlegten Pläne dürfen aber keinesfalls blind für reale Aufbauten genutzt werden. 

## Bedienung

Oben kann die Konstruktion aus der akutell hinterlegten Datenquelle ausgewählt werden. Diese wird dann sofort geladen. Alternativ kann die Datenquelle (Google Tabelle) über den Button *Datenquelle wechseln* umgeschaltet werden.

Im unteren Teil befinden sich die Bedienelemente für die Aufbauschritte und Anzeige. 

**Aufbauschritte:** Standardmäßig wechselt die App alle 5 sec zum nächsten Aufbauschritt. Dieses Interval kann hier geändert, oder die Automatik ganz deaktiviert werden. Ebenso können die schritte manuell angewählt werden.

**Rotation:** Standardmäßig rotiert die Konstruktion mit 2 Umdrehungen pro Sekunde. Diese Geschwindigkeit kann hier angepasst werden oder die Rotation ganz gestoppt werden. In diesem Fall kann die Kamera manuell rotiert werden und gezielt Bereiche herangezoom werden.


## Hinterlegen von Konstuktionen

Die Datenquelle ist eine normale Google-Tabelle mit einer Liste von Konstuktionen. Die Konstuktionen ansich werden dann in den weiteren Blättern dieser Tabellen-Datei definiert.

Beispieldatei: https://docs.google.com/spreadsheets/d/1z0wPbfVoUCu6buGLWJPDcxtESDJJXNRvjhKQt6fDDqQ/edit#gid=0

Der Aufbau nach diesem Schema sollte überwiegend selbsterklärend sein, deshalb hier nur einige Stichpunkte:

- Konstruktionsliste - gid-Spalte: Die **gid** ist die Zahl die in der Adresszeile bei Wechsel auf ein bestimmtes Tabellenblatt angezeigt wird. Über diesen Eintrag erfährt das Programm aus welchem Blatt die Konstruktion geladen werden soll. Dies geschieht nicht über den Namen des Blattes!
- Konstruktion - Anzeige: Diese Spalte hat folgenden Aufbau (RegExp-Format) VON(-BIS)?(:#farbe)?(,VON(-BIS)?(:#farbe)?)*  zum Beispiel:
  - "1" - Zeige dieses Elemente nur in Schritt 1
  - "1-3" - Zeige dieses Element in den Schritten 1 bis 3
  - "1-3,5-" - Zeige dieses Element in den Schritten 1 bis 3 und ab 5 (bis zum Ende)
  - "2-3:#fff,4-" - Zeige dieses Element in den Schritten 2 und 3 in der Farbe Weiß (#fff), ab 4 in der normalen Farbe
- Konstruktion - Farbe: Diese Spalte muss eine Farbangabe im [langen oder kurzen hexadezimalen Format](https://de.wikipedia.org/wiki/Hexadezimale_Farbdefinition) haben. 
- Konstruktion - Element siehe *Liste der gülten Elemente*
- Konstruktion - Richtung: In welche Richtung z.B. ein Riegel gehen soll
- Konstruktion - Besonderheit: 
	- V - Vertikalsteil: hier kann *oRV* eingetragen werden, wenn der Vertikalstiel keinen Rohrverbinder haben soll. 
	- D - Diagonale: bei einer Diagonale gibt *neg* oder *pos* an auf welcher Seite diese angebaut werden soll.
	- B - Breiten: Welche Breiten an Belägen hier eingebaut werden sollen (*32* cm oder *24* cm)

### Liste der gülten Elemente

Aktuell sind folgende Elemente implementiert:
 
| Kürzel  | Element               | Richtung erforderlich | Besonderheit                  |
| ------- | -----------------     | --------------------- | ----------------------------- |
| AnfSt   | Anfangsstück          |   zukünfig (Bohrung)  |                               |
| V100    | Vertikalstiel         |   zukünfig (Bohrung)  | *oRV* wenn kein Rohrverbinder |
| V150    | Vertikalstiel         |   zukünfig (Bohrung)  | *oRV* wenn kein Rohrverbinder |
| V200    | Vertikalstiel         |   zukünfig (Bohrung)  | *oRV* wenn kein Rohrverbinder |
| V300    | Vertikalstiel         |   zukünfig (Bohrung)  | *oRV* wenn kein Rohrverbinder |
| R100    | Riegel 1 m            |          ja           |                               |
| R200    | Riegel 2 m            |          ja           |                               |
| R300    | Riegel 3 m            |          ja           |                               |
| DR200   | Doppelrohr-Riegel 2 m |          ja           |                               |
| DR300   | Doppelrohr-Riegel 3 m |          ja           |                               |
| D100    | Diagonale 1 x 2 m     |          ja           | *pos* oder *neg* für Seite    |
| D100    | Diagonale 2 x 2 m     |          ja           | *pos* oder *neg* für Seite    |
| D100    | Diagonale 3 x 2 m     |          ja           | *pos* oder *neg* für Seite    |
| F40     | Gewindefuß 40 cm      |         nein          |                               |
| F60     | Gewindefuß 60 cm      |         nein          |                               |
| B100    | Beläge 100 cm lang    |          ja           | Liste Breiten, z.B. 32,32,24  |
| B300    | Beläge 300 cm lang    |          ja           | Liste Breiten, z.B. 32,32,24  |

### Daten ergänzen - eigene Konstruktionen

Die standardmäßig verknüpfte Datenquelle hat sehr liberale Freigabeeinstellungen. Hier können leicht weitere Konstruktionen eingefügt werden. Die Tabelle kann aber auch kopiert werden und für Liste eigener Konstruktionen genutzt werden.

Die Aktuelle Datenquelle und die gewählte Konstruktion werden bei der Darstellung in der Adresszeile des Browsers hinterlegt. Dieser Link kann also einfach gespeichert oder geteilt werden.

## Technische Basis

### eingesetzte Software

- 3D-Darstellung: [ThreeJS](http://threejs.org/) und [ThreeJS Orbit Controls](https://github.com/mattdesl/three-orbit-controls)
- Datenquelle: [Google Visualization API - DataTable](https://developers.google.com/chart/interactive/docs/reference)
- Datenverwaltung [Backbone.JS](http://backbonejs.org/)
- UI [Bootstrap](http://getbootstrap.com/)
- Zusammenstellung: [Webpack](https://webpack.github.io/) und [Coffeescript](http://coffeescript.org/)

### Zielstellung

Ursprünglich PoC: Aus Tabelle mach 3d-Animation

### Ausblick

- Verbesserungen UI: 
	- Tastaturbedienung
	- größere Schrittanzeige
	- besser bewegbare Kamera (z.B. Rotation in verschiedenen Höhen)
- verbleibende Gerüstelemente implementieren