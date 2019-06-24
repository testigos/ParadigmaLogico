% DATOS

ciudad(buenosAires,1000000).
ciudad(cordoba,800000).
ciudad(laPlata,750000).
ciudad(rosario,500000).
ciudad(sanSalvador,450000).
ciudad(iguazu,300000).
ciudad(rawson,100000).
ciudad(alumine,5000).

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

transaccion(buenosAires,cordoba,venta(harina,5000),avion).
transaccion(cordoba,buenosAires,venta(yerba,5000),avion).
transaccion(laPlata,rosario,venta(madera,4000),tren(5,900)).
transaccion(iguazu,sanSalvador,venta(yerba,9000),camion(mercedes)).
transaccion(sanSalvador,cordoba,venta(madera,8000),avion).
transaccion(cordoba,rosario,venta(auto,100),tren(4,700)).
transaccion(rosario,buenosAires,venta(auto,100),tren(4,700)).
transaccion(iguazu,buenosAires,venta(yerba,10000),camion(bmw)).
transaccion(sanSalvador,rosario,venta(acero,500),avion).
transaccion(rosario,laPlata,venta(acero,500),avion).
transaccion(rosario,sanSalvador,venta(madera,100),avion).
transaccion(buenosAires,rawson,venta(madera,500),avion).
transaccion(rawson,sanSalvador,venta(madera,700),auto(marca)).

producto(harina,4).
producto(yerba,1).
producto(auto,100000).
producto(madera,5).
producto(acero,0.1).

% EJERCICIO 1
% El costo del producto es el precio unitario por la cantidad que se busca a comprar.

costoDeCompra(Compradora,Vendedora,ProductoAVender,Costo) :-
    producto(ProductoAVender,PrecioUnitario),
    transaccion(Compradora,Vendedora,venta(ProductoAVender,CantAComprar),Medio),
    ruta(Compradora,Vendedora,Distancia),
    costoProducto(CantAComprar,PrecioUnitario,CostoProducto),
    costoTransporte(Medio,CostoProducto,Distancia,CostoTransporte),
    Costo is (CostoProducto + CostoTransporte).

costoProducto(Cantidad,PrecioUnitario,CostoProducto) :-
    CostoProducto is (Cantidad*PrecioUnitario).

costoTransporte(avion,CostoProducto,_,CostoTransporte) :-
    CostoTransporte is (CostoProducto*1000).
costoTransporte(auto,CostoProducto,Distancia,CostoTransporte) :-
    CostoTransporte is (Distancia*CostoProducto).
costoTransporte(tren(Vagones,_),CostoProducto,Distancia,CostoTransporte) :-
    CostoTransporte is (CostoProducto*(Vagones+1)*Distancia).
costoTransporte(camion(Marca),CostoProducto,_,CostoTransporte) :-
    Marca \= mercedes,
    CostoTransporte is (CostoProducto*10).
costoTransporte(camion(mercedes),_,Distancia,Distancia).

% EJERCICIO 2

saldoComercial(CiudadA,CiudadB,Saldo) :-
    findall(ValorCompra,costoDeCompra(CiudadA,CiudadB,ProductoAVender,ValorCompra),ValoresCompra),
    findall(ValorVenta,costoDeCompra(CiudadB,CiudadA,ProductoAVender,ValorVenta),ValoresVenta),
    sumlist(ValoresCompra,ComprasTotales),
    sumlist(ValoresVenta,VentasTotales),
    Saldo is (VentasTotales-ComprasTotales).

% EJERCICIO 3

ciudadFantasma(Ciudad) :-
    ciudad(Ciudad,Habitantes),
    not(ruta(Ciudad,_,_)),
    Habitantes < 1000000.

ciudadDeTransito(Ciudad) :-
    transaccion(_,Ciudad,_,_),
    forall(transaccion(_,Ciudad,venta(Producto,_),_),
            transaccion(Ciudad,_,venta(Producto,_),_)).

ciudadMonopolica(Ciudad) :-
    transaccion(_,Ciudad,venta(Producto,_),_),
    forall((ciudad(Ciudad2,_),Ciudad \= Ciudad2),
            not(transaccion(_,Ciudad2,venta(Producto,_),_))).

% EJERCICIO 4

distancia(CiudadA,CiudadB,Distancia) :-
    ruta(CiudadA,CiudadB,Distancia).
distancia(CiudadA,CiudadB,Distancia) :-
    ruta(PtoMedio,CiudadA,Distancia1),
    distancia(CiudadB,PtoMedio,Distancia2),
    Distancia is (Distancia1+Distancia2).