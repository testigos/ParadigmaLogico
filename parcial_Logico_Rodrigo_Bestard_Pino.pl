% disco(Artista,NombreDelDisco,Vendidas,Año).
disco(floydRosa,elLadoBrillanteDeLaLuna,1000000,1973).
disco(tablasDeCanada,autopistaTransargentina,500,2006).
disco(rodrigoMalo,elCaballo,5000000,1999).
disco(rodrigoMalo,loPeorDelAmor,50000000,1996).
disco(rodrigoMalo,loMejorDe,50000000,2018).
disco(losOportunistasDelConurbano,ginobili,5,2018).
disco(losOportunistasDelConurbano,messiMessiMessi,5,2018).
disco(losOportunistasDelConurbano,marthaArgerich,15,2019).
disco(elQuintetoDeVos,vida,7,2019).
disco(elQuintetoDeVos,marthaArgerich,20000,2019).

% manager(Artista,Manager).
% manager(Artista,normal(porcentajeComision)).
% manager(Artista,buenaOnda(Nombre,Lugar)).
% manager(Artista,estafador).
manager(floydRosa,normal(15)).
manager(tablasDeCanada,buenaOnda(cachito,canada)).
manager(rodrigoMalo,estafador).

% PUNTO 1

clasico(Artista) :-
    disco(Artista,loMejorDe,_,_).
clasico(Artista) :-
    disco(Artista,_,Ventas,_),
    Ventas > 1000000.

% PUNTO 2

totalVentas(Artista,VentasTotales) :-
    disco(Artista,_,_,_),
    findall(Ventas,disco(Artista,_,Ventas,_),VentasT),
    sumlist(VentasT,VentasTotales).

% PUNTO 3 (El predicado principal es inversible, los predicados auxiliares no)

% No hace falta unificar el artista para que sea inversible porque ya <totalVentas> lo hace.
gananciaArtista(Artista,GananciaReal) :-
    ganancia(Artista,GananciaReal),
    not(manager(Artista,_)).
gananciaArtista(Artista,GananciaReal) :-
    ganancia(Artista,GananciaBruta),
    manager(Artista,Manager),
    descuentoManager(Manager,GananciaBruta,GananciaReal).

ganancia(Artista,Ganancia) :-
    totalVentas(Artista,Ventas),
    Ganancia is (Ventas * 10).

descuentoManager(normal(Porcentaje),GananciaBruta,GananciaReal) :-
    gananciaReal(Porcentaje,GananciaBruta,GananciaReal).
descuentoManager(buenaOnda(_,Pais),GananciaBruta,GananciaReal) :-
    porcentajePais(Pais,Porcentaje),
    gananciaReal(Porcentaje,GananciaBruta,GananciaReal).
descuentoManager(estafador,_,0).

gananciaReal(Porcentaje,GananciaBruta,GananciaArtista) :-
    GananciaManager is ((Porcentaje * GananciaBruta) / 100),
    GananciaArtista is (GananciaBruta - GananciaManager).

porcentajePais(canada,5).
porcentajePais(mexico,15).
porcentajePais(argentina,20).

% PUNTO 4

namberuan(Artista,Anio) :-
    disco(Artista,_,Vendidas,Anio),
    not(manager(Artista,_)),
    forall((disco(Artista2,_,Vendidas2,Anio),Artista \= Artista2,not(manager(Artista2,_))),
            Vendidas > Vendidas2).

% PARA PENSAR

/*
A- ¿Cómo especificamos que un artista no tiene manager?
B- ¿Qué concepto es el que se aplica en el paradigma lógico para explicar esto?
C- Si se agrega un nuevo tipo de manager, ¿qué hay que hacer? ¿Qué concepto nos ayuda?

A- Un artista no tiene manager si no existe ningún predicado <manager(EseArtista,AlgúnManager)>.

B- El concepto que aplica ProLog para explicar lo anterior mencionado es el principio de universo cerrado. Que significa que lo que no está en la base
de conocimientos se considera falso de por sí. Entonces si no existe tal predicado <manager(EseArtista,AlgúnManager)>, ProLog infiere que dicho artista
NO tiene manager

C- Si se agregara un nuevo tipo de manager a la base de conocimiento, el único predicado que habría que modificar es el de <descuentoManager>, agregando el
nuevo caso con su respectiva cuenta para calcular la ganancia. El concepto que nos ayuda para facilitar esta tarea es el polimorfismo, que permite
hacer varios casos del mismo predicado recibiendo diferentes tipos de parámetros. En nuestro predicado, <descuentoManager> recibe distintos tipos
de manager por cada caso que está definido.
Por ejemplo si se agregara el <managerLoco> que si tu ganancia supera los 100000 se queda con un 10%
de la misma, de lo contrario no se queda con nada. Entonces el código del predicado <descuentoManager> quedaría así:
descuentoManager(normal(Porcentaje),GananciaBruta,GananciaReal) :-
    gananciaReal(Porcentaje,GananciaBruta,GananciaReal).
descuentoManager(buenaOnda(_,Pais),GananciaBruta,GananciaReal) :-
    porcentajePais(Pais,Porcentaje),
    gananciaReal(Porcentaje,GananciaBruta,GananciaReal).
descuentoManager(estafador,_,0).
descuentoManager(managerLoco,GananciaBruta,GananciaReal) :-
    GananciaBruta > 100000,
    gananciaReal(10,GananciaBruta,GananciaReal).
descuentoManager(managerLoco,GananciaBruta,GananciaBruta) :-
    GananciaBruta <= 100000.
*/