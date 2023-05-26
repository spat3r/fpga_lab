

// TODO add prameters

// TODO: add code


// todo: csinálni ezt azt



// TODO: A main.c-ben a parancsok jelenjenek a hf specnek megfelelően : H karakter majd (kocsi vissza + új sor) az egyes hisztogram bin-ek értéke vesszővel elválasztva.
// TODO: A fir paramétereket háziban leírtak szerint fogadjuk
// TODO: A fir paramétereket átt kell alakítani
// TODO: Kell készíteni egy AXI interfész modult (nem tudom fel lehet e használni a fluid leveleset.)
// TODO: Ellenőrízni kell hogy a conv module alkalmas-e a paraméterek fogadására.
// MEMO: A conv modul elvileg úgy fogadná az új paramétereket, hogy a VSYNC jelváltásnál 25 órajelciklus alatt végigprget egy [33:0] [24:0] regisztertömböt és feltölti az együtthatókkal
// TODO: Az együtthatók s7.8, ennek megfelelően kell trimmelni a DSP kimenetet.
// TODO: Le kell ellenőrízni, hogy a conv blokk jól számol-e.



//MEMO: a pixel órajel miatt a microblaze másik órajeltartományban lesz.

//TODO: a top modulben az infók átadásánál metastabil szűrés és handshake kell.






// TODO: ezeket átalakítani todoba

// A parancsszavakat választhatjuk, tehát lehet külön F és H parancs szó, vagy ragaszkodni kell a specifikációhoz?
// Az órán megavalósított perifériakódot használjuk fel átírva vagy sajátot írjunk a nulláról?
// Mennyi dokumentációt szükséges készíteni?

// feladat leuras bolkkvazlat, milyen priferiskat hasznaltam, leirassal, sajat ip reszletes dokumentácio
// forraskod nem kell, szoftver mukodeserol kell irni

// Milyen módon lesz ellenőrízve a házi? Automatizált, vagy kézzel kerül ellenőrzésra?
// be kell mutatni a házi feladatot

// lehet plusz karaktert használni, ezt is dokumentálni kell

// lehet használni az orai megoldásokat is nyugodtan