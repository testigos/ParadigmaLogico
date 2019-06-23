% ciudad(Ciudad,Habitantes).
ciudad(buenosAires,1000000). 
ciudad(cordoba,800000).
ciudad(laPlata,750000).
ciudad(rosario,500000).
ciudad(sanSalvador,450000).
ciudad(iguazu,300000).
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

% transaccion(CiudadCompradora,CiudadVendedora,Producto,CantProducto,Transporte)
transaccion(buenosAires,cordoba,harina,5000,avion).
transaccion(cordoba,buenosAires,yerba,5000,avion).
%transaccion(laPlata,rosario,venta(madera,4000),tren(5,900)).
transaccion(iguazu,sanSalvador,yerba,9000,camion(mercedes)).
transaccion(sanSalvador,cordoba,madera,8000,avion).
transaccion(cordoba,rosario,auto,100,tren(4,700)).
transaccion(rosario,buenosAires,auto,100,tren(4,700)).
transaccion(iguazu,buenosAires,yerba,10000,camion(bmw)).

% costoProduccion(Producto,Costo)
costoProduccion(harina,4).
costoProduccion(yerba,1).
costoProduccion(auto,100000).
costoProduccion(madera,5).

% EJERCICIO 1

% EL PRECIO QUE PAGA ES UNITARIO POR PRODUCTO, NO SE TIENE EN CUENTA LA CANTIDAD A COMPRAR

cuantoPaga(CiudadCompradora,CiudadVendedora,Producto,CostoTotal) :-
    ciudad(CiudadCompradora,_),
    ciudad(CiudadVendedora,_),
    costoProduccion(Producto,CostoProduccion),
    transaccion(CiudadCompradora,CiudadVendedora,Producto,_,Transporte),
    ruta(CiudadCompradora,CiudadVendedora,Distancia),
    costoTransporte(CostoProduccion,Transporte,Distancia,CostoTransporte),
    CostoTotal is (CostoProduccion + CostoTransporte).

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