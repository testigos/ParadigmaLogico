% disco(artista, nombreDelDisco, cantidad, año).
disco(floydRosa, elLadoBrillanteDeLaLuna, 1000000, 1973).
disco(tablasDeCanada, autopistaTransargentina, 500, 2006).
disco(rodrigoMalo, elCaballo, 5000000, 1999).
disco(rodrigoMalo, loPeorDelAmor, 50000000, 1996).
disco(rodrigoMalo, loMejorDe, 50000000, 2018).
disco(losOportunistasDelConurbano, ginobili, 5, 2018).
disco(losOportunistasDelConurbano, messiMessiMessi, 5, 2018).
disco(losOportunistasDelConurbano, marthaArgerich, 15, 2019).
disco(adele,21,1000000000,2012).
disco(adele,25,1000000,2015).
disco(florence,highAsHope,1000000,2018).
disco(florence,lungs,2000000,2018).
disco(florence,hbhbhb,500000,2015).
disco(kanyeWest,yeezus,10000000,2013).

%manager(artista, manager).
manager(floydRosa, normal(15)).
manager(tablasDeCanada, buenaOnda(cachito, canada)).
manager(rodrigoMalo, estafador).
manager(adele,buenaOnda(jake,estadosUnidos)).

porcentajePais(mexico,15).
porcentajePais(canada,5).
porcentajePais(argentina,10).
porcentajePais(francia,40).
porcentajePais(estadosUnidos,5).
porcentajePais(rwanda,9).
porcentajePais(qatar,7).
porcentajePais(armenia,10).

% normal(porcentajeComision) 
% buenaOnda(nombre, lugar)
% estafador     

% EJERCICIO 1 (Es inversible)

clasico(Artista) :-
    disco(Artista,loMejorDe,_,_).
clasico(Artista) :-
    disco(Artista,_,Copias,_),
    Copias > 1000000.

% EJERCICIO 2 (totalVentas es Inversible)

esArtista(Artista) :- disco(Artista,_,_,_).

totalVentas(Artista,Total) :-
    esArtista(Artista),
    findall(Ventas,disco(Artista,_,Ventas,_),Ventas),
    sumlist(Ventas,Total).

% EJERCICO 3 (gananciaArtista es inversible)

% Descuenta primero las unidades que el manager se queda y luego calcula la ganancia.
gananciaArtista(Artista,GananciaFinal) :-
    totalVentas(Artista,Total),
    evaluacionManager(Artista,Total,Ganancia),
    GananciaFinal is (Total * (10 / 100)).

evaluacionManager(Artista,Total,Ganancia) :-
    manager(Artista,CriterioManager),
    descuentaManager(CriterioManager,Total,Ganancia).
evaluacionManager(Artista,Total,Total) :-
    artistaSinManager(Artista).

artistaSinManager(Artista) :- not(manager(Artista,_)). % Este predicado no es inversible debido a que siempre lo utilizo como funcion auxiliar.

descuentaManager(normal(PorcentajeComision),Total,GananciaArtista) :-
    reducirPorcentaje(PorcentajeComision,Total,GananciaArtista).
descuentaManager(buenaOnda(_,Lugar),Total,GananciaArtista) :-
    porcentajePais(Lugar,Porcentaje),
    reducirPorcentaje(Porcentaje,Total,GananciaArtista).
descuentaManager(estafador,_,0).

reducirPorcentaje(Porcentaje,Total,GananciaArtista) :-
    GananciaArtista is (Total - (Total*(Porcentaje / 100))).

% EJERCICIO 4 (namberuan es inversible)

namberuan(Artista,Anio) :-
    disco(Artista,_,Unidades,Anio),
    artistaSinManager(Artista),
    forall((disco(Artista2,_,Unidades2,Anio),artistaSinManager(Artista2),Artista \= Artista2),
                Unidades > Unidades2).
    

/* 
EJERCICIO 5

El concepto que se utiliza para especificar que un artista no tiene manager es el de Universo Cerrado, si no esta definido un predicado
manager(Artista,Manager) significa que el artista no tiene manager.
Para especificar que un artista no tiene manager lo que se utiliza es el concepto de predicados de orden superior, que son justamente predicados
que reciben como parametros otros predicados. En este caso, yo utilicé el predicado de orden superior not/1 que devuelve el valor de verdad contrario
al predicado que se utiliza como variable. El predicado que realiza esto es artistaSinManager, que devuelve a los artistas que no tienen manager, haciendo
uso del not. El predicado no es inversible en este caso ya que siempre lo utilice como predicado auxiliar, bastaba con agregar esArtista(Artista) para 
hacerlo inversible.

Si se agrega un nuevo tipo de manager, lo unico que haría sería agregar un predicado más de descuentaManager, ya que este predicado utiliza 
el concepto de polimorfismo, esto quiere decir que dependiendo de los parametros que reciba el predicado va a realizar distintas cosas. Por ejemplo si el 
manager que recibe es normal le quita un porcentaje especificado a la ganancia, mientras que si recibe un manager estafador, devuelve 0 como ganancia.

*/