# EGS Visualisierung

Diese WebApp visualisiert den Aufbau von EGS Konstruktionen.

Die WebApp ist erreichbar unter [http://visualisierung.thw-egs.de](http://visualisierung.thw-egs.de)

## Zweck und Nutzen

Der Aufbau von Gerüstkonstuktionen ist nicht immer trivial, deshalb kann eine Visualsierung die theoretische Ausbildung unterstützen. Der Aufbau kann in eine Vielzahl von Schritten zerlegt und Bauteile farblich hervorgehoben werden. Die automatische Rotation bzw. die manuelle Betrachtung von allen Seiten erlauben ein schnelleres Verständnis.

Wichtig ist, dass die Visualisierung in erster Linie ein Hilfsmittel für die Ausbildung ist, z.B. um verschiedene Aufbauweisen relativ einfach zu vergleichen. Die hinterlegten Pläne dürfen aber keinesfalls blind für reale Aufbauten genutzt werden.

In einem weiteren Entwicklungsschritt könnten aus der Aufbauanleitung auch Materiallisten abgeleitet werden. Zunächst, ob die Konstruktion mit dem vorhanden Material lösbar ist, und im zweiten Schritt in welcher Reihenfolge welches Teile benötigt werden.

## Bedienung

In der WebApp kann in der oberen Navigationszeile die Konstruktion aus der aktuell hinterlegten Datenquelle ausgewählt werden. Alternativ kann die Datenquelle (Google Tabelle) über den Button _Datenquelle wechseln_ umgeschaltet werden.

Im unteren Teil der Apo befinden sich die Bedienelemente für die Aufbauschritte und Anzeige.

**Aufbauschritte:** Standardmäßig wechselt die App alle 5 sec zum nächsten Aufbauschritt. Dieses Interval kann geändert, oder die Automatik ganz deaktiviert werden. Ebenso können die Schritte manuell angewählt werden.

**Rotation:** Standardmäßig rotiert die Konstruktion mit 2 Umdrehungen pro Minute. Diese Geschwindigkeit kann angepasst oder die Rotation ganz gestoppt werden. In diesem Fall ist es möglich die Kamera manuell zu rotieren und gezielt Bereiche heranzuzoomen.

**Höhe:** Die Normalansicht zeigt das Modell auf halber Höhe. Mit diesen Bedienelementen lässt sich die Ansicht auf andere Betrachtungshöhen umschalten.

## Hinterlegen von Konstuktionen

Die Datenquelle ist eine normale Google-Tabelle mit einer Liste von Konstuktionen. Die Konstuktionen ansich werden dann in den weiteren Blättern dieser Tabellen-Datei definiert.

Beispieldatei: https://docs.google.com/spreadsheets/d/1z0wPbfVoUCu6buGLWJPDcxtESDJJXNRvjhKQt6fDDqQ/edit#gid=0

Der Aufbau nach diesem Schema sollte überwiegend selbsterklärend sein, deshalb hier nur einige Stichpunkte:

- Konstruktionsliste - gid-Spalte: Die **gid** ist die Zahl, die in der Adresszeile bei jedem Tabellenblatt angezeigt wird. Über diese Ziffernfolge erfährt das Programm aus welchem Blatt die Konstruktion geladen werden soll. Dies geschieht nicht über den Namen des Blattes!
- Konstruktion - Anzeige: Diese Spalte gibt an bei welchen Schritten das Element angezeigt werden soll, und ggf. in welcher besonderen Farbe. Sie hat folgenden Aufbau (RegExp-Format) VON(-BIS)?(:#farbe)?(,VON(-BIS)?(:#farbe)?)\* zum Beispiel:
  - "1" - Zeige dieses Elemente nur in Schritt 1
  - "1-3" - Zeige dieses Element in den Schritten 1 bis 3
  - "1-3,5-" - Zeige dieses Element in den Schritten 1 bis 3 und ab 5 (bis zum Ende)
  - "2-3:#fff,4-" - Zeige dieses Element in den Schritten 2 und 3 in der Farbe Weiß (#fff), ab 4 in der normalen Farbe
- Konstruktion - Farbe: Diese Spalte muss eine Farbangabe im [langen oder kurzen hexadezimalen Format](https://de.wikipedia.org/wiki/Hexadezimale_Farbdefinition) enthalten.
- Konstruktion - Element siehe _Liste der gülten Elemente_
- Konstruktion - Richtung: In welche Richtung z.B. ein Riegel gehen soll
- Konstruktion - Besonderheit:
  - V - Vertikalstiel: hier kann _oRV_ eingetragen werden, wenn der Vertikalstiel keinen Rohrverbinder haben soll.
  - D - Diagonale: bei einer Diagonale gibt _neg_ oder _pos_ an auf welcher Seite diese angebaut werden soll.
  - B - Breiten: Welche Breiten an Belägen hier eingebaut werden sollen (_32_ cm oder _24_ cm)

### Liste der gültigen Elemente

Aktuell sind folgende Elemente implementiert:

| Kürzel    | Element                            | Richtung erforderlich | Besonderheit                                  |
| --------- | ---------------------------------- | --------------------- | --------------------------------------------- |
| AnfSt     | Anfangsstück                       | zukünftig (Bohrung)   |                                               |
| V50       | Vertikalstiel 50 cm                | zukünftig (Bohrung)   | _oRV_ wenn kein Rohrverbinder                 |
| V100      | Vertikalstiel 100 cm               | zukünftig (Bohrung)   | _oRV_ wenn kein Rohrverbinder                 |
| V150      | Vertikalstiel 150 cm               | zukünftig (Bohrung)   | _oRV_ wenn kein Rohrverbinder                 |
| V200      | Vertikalstiel 200 cm               | zukünftig (Bohrung)   | _oRV_ wenn kein Rohrverbinder                 |
| V250      | Vertikalstiel 250 cm               | zukünftig (Bohrung)   | _oRV_ wenn kein Rohrverbinder                 |
| V300      | Vertikalstiel 300 cm               | zukünftig (Bohrung)   | _oRV_ wenn kein Rohrverbinder                 |
| V400      | Vertikalstiel 400 cm               | zukünftig (Bohrung)   | _oRV_ wenn kein Rohrverbinder                 |
| R15       | Riegel 15 cm                       | ja                    |                                               |
| R25       | Riegel 25 cm                       | ja                    |                                               |
| R50       | Riegel 50 cm                       | ja                    |                                               |
| R75       | Riegel 75 cm                       | ja                    |                                               |
| R100      | Riegel 100 cm                      | ja                    |                                               |
| R125      | Riegel 125 cm                      | ja                    |                                               |
| R150      | Riegel 150 cm                      | ja                    |                                               |
| R200      | Riegel 200 cm                      | ja                    |                                               |
| R250      | Riegel 250 cm                      | ja                    |                                               |
| R400      | Riegel 400 cm                      | ja                    |                                               |
| R300      | Riegel 300 cm                      | ja                    |                                               |
| DR150     | Doppelrohr-Riegel 150 cm           | ja                    |                                               |
| DR200     | Doppelrohr-Riegel 200 cm           | ja                    |                                               |
| DR250     | Doppelrohr-Riegel 250 cm           | ja                    |                                               |
| DR300     | Doppelrohr-Riegel 300 cm           | ja                    |                                               |
| VD50/200  | Diagonale 50 cm x 200 cm           | ja                    | _pos_ oder _neg_ für Seite                    |
| VD75/200  | Diagonale 75 cm x 200 cm           | ja                    | _pos_ oder _neg_ für Seite                    |
| VD100/200 | Diagonale 100 cm x 200 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD150/200 | Diagonale 150 cm x 200 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD200/200 | Diagonale 200 cm x 200 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD250/200 | Diagonale 250 cm x 200 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD300/200 | Diagonale 300 cm x 200 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD50/150  | Diagonale 50 cm x 150 cm           | ja                    | _pos_ oder _neg_ für Seite                    |
| VD75/150  | Diagonale 75 cm x 150 cm           | ja                    | _pos_ oder _neg_ für Seite                    |
| VD100/150 | Diagonale 100 cm x 150 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD150/150 | Diagonale 150 cm x 150 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD200/150 | Diagonale 200 cm x 150 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD250/150 | Diagonale 250 cm x 150 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD300/150 | Diagonale 300 cm x 150 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD50/100  | Diagonale 50 cm x 100 cm           | ja                    | _pos_ oder _neg_ für Seite                    |
| VD75/100  | Diagonale 75 cm x 100 cm           | ja                    | _pos_ oder _neg_ für Seite                    |
| VD100/100 | Diagonale 100 cm x 100 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD150/100 | Diagonale 150 cm x 100 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD200/100 | Diagonale 200 cm x 100 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD250/100 | Diagonale 250 cm x 100 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD300/100 | Diagonale 300 cm x 100 cm          | ja                    | _pos_ oder _neg_ für Seite                    |
| VD100/50  | Diagonale 100 cm x 50 cm           | ja                    | _pos_ oder _neg_ für Seite                    |
| VD150/50  | Diagonale 150 cm x 50 cm           | ja                    | _pos_ oder _neg_ für Seite                    |
| VD200/50  | Diagonale 200 cm x 50 cm           | ja                    | _pos_ oder _neg_ für Seite                    |
| VD300/50  | Diagonale 300 cm x 50 cm           | ja                    | _pos_ oder _neg_ für Seite                    |
| F40       | Gewindefuß 40 cm                   | nein                  |                                               |
| F60       | Gewindefuß 60 cm                   | nein                  |                                               |
| B75       | Beläge 75 cm lang                  | ja                    | Liste Breiten, z.B. 32,24,14                  |
| B100      | Beläge 100 cm lang                 | ja                    | Liste Breiten, z.B. 32,24,14                  |
| B150      | Beläge 150 cm lang                 | ja                    | Liste Breiten, z.B. 32,24,14                  |
| B200      | Beläge 200 cm lang                 | ja                    | Liste Breiten, z.B. 32,24,14                  |
| B250      | Beläge 250 cm lang                 | ja                    | Liste Breiten, z.B. 32,24,14                  |
| B300      | Beläge 300 cm lang                 | ja                    | Liste Breiten, z.B. 32,24,14                  |
| T100      | Traverse 100 cm                    | ja                    |                                               |
| T200      | Traverse 200 cm                    | ja                    |                                               |
| T250      | Traverse 250 cm                    | ja                    |                                               |
| T300      | Traverse 300 cm                    | ja                    |                                               |
| T400      | Traverse 400 cm                    | ja                    |                                               |
| T500      | Traverse 500 cm                    | ja                    |                                               |
| T600      | Traverse 600 cm                    | ja                    |                                               |
| T700      | Traverse 700 cm                    | ja                    |                                               |
| T800      | Traverse 800 cm                    | ja                    |                                               |
| TRWL100   | Treppenwange (Links) 100 cm        | ja                    |                                               |
| TRWR100   | Treppenwange (Rechts) 100 cm       | ja                    |                                               |
| TRWL200   | Treppenwange (Links) 200 cm        | ja                    |                                               |
| TRWR200   | Treppenwange (Rechts) 200 cm       | ja                    |                                               |
| TRS100    | Treppenstufen 100 cm               | ja                    |                                               |
| TRS200    | Treppenstufen 200 cm               | ja                    |                                               |
| HV        | Hängegerüstverbinder               | ja                    |                                               |
| RO100     | Gerüstrohr 100 cm lang             | nein                  | Drehungen (RX, RY, RZ)                        |
| ROxxx     | Gerüstrohr xxx cm lang             | nein                  | z.B. "RZ = 90 / RX = -45"                     |
| KH100     | Kantholz (10x10) 100 cm lang       | nein                  | Drehungen (RX, RY, RZ)                        |
| KHxxx     | Kantholz (10x10) xxx cm lang       | nein                  | z.B. "RZ = 90 / RX = -45"                     |
|           |                                    |                       | Bei Höhe 0 liegt das Kantholz auf den Belägen |
|           |                                    |                       | Höhe -20 für Bodenhöhe                        |
|           |                                    |                       | Vorgeschlagene Farbe: #A1662F                 |
| BBS       | Betonblockstein (120 x 60 x 60 cm) | ja                    | Vorgeschlagene Farbe: #917f69                 |

### Daten ergänzen - eigene Konstruktionen

Die standardmäßig verknüpfte Datenquelle hat sehr liberale Freigabeeinstellungen. Hier können leicht weitere Konstruktionen eingefügt werden. Die Tabelle kann aber auch kopiert werden und als Grundlage für eine Tabelle eigener Konstruktionen verwendet werden.

Die aktuelle Datenquelle und die gewählte Konstruktion werden bei der Darstellung in der Adresszeile des Browsers hinterlegt. Dieser Link kann also einfach gespeichert oder geteilt werden.

## Technische Basis

### Aufgaben / Änderungswünsche / Bugs

Aufgaben, Änderungswünsche und Bugs werden als [Issues](https://github.com/theudebart/thw-egs/issues) gelistet.

### eingesetzte Software

- 3D-Darstellung: [ThreeJS](http://threejs.org/) und [ThreeJS Orbit Controls](https://github.com/mattdesl/three-orbit-controls)
- Datenquelle: [Google Visualization API - DataTable](https://developers.google.com/chart/interactive/docs/reference)
- Datenverwaltung [Backbone.JS](http://backbonejs.org/)
- UI [Bootstrap](http://getbootstrap.com/)
- Zusammenstellung: [Webpack](https://webpack.github.io/) und [Coffeescript](http://coffeescript.org/)
