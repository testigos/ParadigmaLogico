% PUNTO 1

% EL PRECIO QUE DA ES EL PRECIO UNITARIO POR PRODUCTO, NO TIENE EN CUENTA LA CANTIDAD DEL MISMO

cuantoPaga(CiudadCompradora,CiudadVendedora,Producto,Costo) :-
    costoProduccion(Producto,CostoProducto),
    transaccion(CiudadCompradora,CiudadVendedora,Producto,_,Transporte),
    ruta(CiudadCompradora,CiudadVendedora,Distancia),
    costoTransporte(CostoProducto,Transporte,Distancia,CostoTransporte),
    Costo is (CostoProducto + CostoTransporte).

costoTransporte(CostoProduccion,tren(CantVagones,_),Distancia,CostoTransporte) :-
    CostoTransporte is (CostoProduccion * (CantVagones + 1) * Distancia).
costoTransporte(_,camion(mercedes),Distancia,CostoTransporte) :-
    CostoTransporte is Distancia.
costoTransporte(CostoProduccion,camion(Marca),_,CostoTransporte) :-
    Marca \= mercedes,
    CostoTransporte is (CostoProduccion * 10).
costoTransporte(CostoProduccion,avion,_,CostoTransporte) :-
    CostoTransporte is (CostoProduccion * 1000).

% PUNTO 2

saldoComercial(Ciudad1,Ciudad2,Saldo) :-
    ciudad(Ciudad1,_),
    ciudad(Ciudad2,_),
    Ciudad1 \= Ciudad2,
    findall(Costo1,cuantoPaga(Ciudad2,Ciudad1,Producto,Costo1),ListaGanancia),
    sumlist(ListaGanancia,Ganancia),
    findall(Costo2,cuantoPaga(Ciudad1,Ciudad2,Producto,Costo2),ListaInversion),
    sumlist(ListaInversion,Inversion),
    Saldo is (Ganancia - Inversion).

% PUNTO 3

ciudadFantasma(Ciudad) :-
    ciudad(Ciudad,Habitantes),
    not(ruta(Ciudad,_,_)),
    not(ruta(_,Ciudad,_)),
    Habitantes < 1000000.

ciudadTransito(Ciudad) :-
    transaccion(_,Ciudad,_,_,_),
    forall(transaccion(_,Ciudad,Producto,_,_),
            transaccion(Ciudad,_,Producto,_,_)).

ciudadMonopolica(Ciudad) :-
    transaccion(_,Ciudad,Producto,_,_),
    forall((ciudad(Ciudad2,_),Ciudad \= Ciudad2),
            not(transaccion(_,Ciudad2,Producto,_,_))).

% PUNTO 4

distancia(Ciudad1,Ciudad2,Distancia) :-
    ruta(Ciudad1,Ciudad2,Distancia).
distancia(Ciudad1,Ciudad2,Distancia) :-
    ruta(CiudadMedia,Ciudad2,Distancia1),
    distancia(Ciudad1,CiudadMedia,Distancia2),
    Distancia is (Distancia1 + Distancia2).

% PUNTO 5

% Es una boludez, que lo haga otro.

% PUNTO 6

% ciudad(Nombre,Habitantes)
ciudad(buenosAires,1000000).
ciudad(cordoba,800000).
ciudad(laPlata,750000).
ciudad(rosario,500000).
ciudad(sanSalvador,450000).
ciudad(iguazu,300000).
ciudad(rawson,100000).
ciudad(alumine,5000).

% ruta(Ciudad1,Ciudad2,Distancia)
ruta(buenosAires,cordoba,600).
ruta(cordoba,buenosAires,600).
ruta(buenosAires,laPlata,300).
ruta(buenosAires,rosario,700).
ruta(rosario,buenosAires,700).
ruta(iguazu,buenosAires,1000).
ruta(cordoba,rosario,200).
ruta(sanSalvador,cordoba,600).
ruta(laPlata,rosario,700).
ruta(iguazu,sanSalvador,400).
ruta(buenosAires,rawson,600).
ruta(rawson,sanSalvador,500).

% transaccion(CiudadCompradora,CiudadVendedora,Producto,CantProducto,Transporte)
transaccion(buenosAires,cordoba,harina,5000,avion).
transaccion(cordoba,buenosAires,yerba,5000,avion).
transaccion(laPlata,rosario,madera,4000,tren(5,900)).
transaccion(iguazu,sanSalvador,yerba,9000,camion(mercedes)).
transaccion(sanSalvador,cordoba,madera,8000,avion).
transaccion(cordoba,rosario,auto,100,tren(4,700)).
transaccion(rosario,buenosAires,auto,100,tren(4,700)).
transaccion(iguazu,buenosAires,yerba,10000,camion(bmw)).
transaccion(sanSalvador,rosario,acero,500,avion).
transaccion(rosario,laPlata,acero,500,avion).
transaccion(rosario,sanSalvador,madera,100,avion).
transaccion(buenosAires,rawson,madera,500,avion).
transaccion(rawson,sanSalvador,madera,700,auto(marca)).

% costoProduccion(Producto,Costo)
costoProduccion(harina,4).
costoProduccion(yerba,1).
costoProduccion(auto,100000).
costoProduccion(madera,5).
costoProduccion(acero,0.1).

% PUNTO 7

% Pensala vos nomas, es una pregunta teorica. Excepto el predicado <distancia> todos los demas son totalmente inversibles.

% PUNTO 8

% Lo mismo que la anterior, explicalo vos nomas. Polimorfismo es lo que se uso en el predicado <costoTransporte>.