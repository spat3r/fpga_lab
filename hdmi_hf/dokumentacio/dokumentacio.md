
// A parancsszavakat választhatjuk, tehát lehet külön F és H parancs szó, vagy ragaszkodni kell a specifikációhoz?
// Az órán megavalósított perifériakódot használjuk fel átírva vagy sajátot írjunk a nulláról?
// Mennyi dokumentációt szükséges készíteni?

// feladat leuras bolkkvazlat, milyen priferiskat hasznaltam, leirassal, sajat ip reszletes dokumentácio
// forraskod nem kell, szoftver mukodeserol kell irni

// Milyen módon lesz ellenőrízve a házi? Automatizált, vagy kézzel kerül ellenőrzésra?
// be kell mutatni a házi feladatot

// lehet plusz karaktert használni, ezt is dokumentálni kell

// lehet használni az orai megoldásokat is nyugodtan



Járhat e a cpu is a pixelórajelről, akkor nem kellene metastabil szűrés és hasonlók

> :memo: note: ha a fir2coeff_r jönne de még nem fejeződött be az axi írás, hibát dobunk

Közönbös-e hogy a berkezést követő képkocka histje kerül-e ki vagy
 - lehet e esetleg az, hogy csak a legutóbbi kerül ki
 - lehet e az hogy ha a látható kép után jön be a jel, akkor csak a kettővel későbbi képet tesszük ki
 - lehet e hogy inkozisztens, hogy pontosan melyik kép kerül ki 



A képet úgy alakítottuk át fejben, hogy a frontporch már a következő képhez tartozik, így ha ott érkezik meg a hist kiolvasás, akkor nem a következő, hanem az azt követő kép kerül kiolvasásra. Az abszolút értelemben vett következő látható kép kiolvasására túl komplex lenne az állapotgép amely be tudja határolni, hol is vagyunk pontosan.


A hardveresen pergésmentesített kapcsolók és nyomógombokra milyen bemeneti constraint kell definiálni?
