% DATOS

%puerto(Nombre,Pais).

puerto(buenosAires,argentina).
%puerto(puerto2,bahiaBlanca).
%puerto(puerto3,florida).
%puerto(puerto4,rioDeJaneiro).
%puerto(puerto5,nicaragua).
puerto(yatay,argentina).
puerto(lujan,argentina).

ruta(buenosAires,bahiaBlanca,800).
ruta(bahiaBlanca,florida,3000).
ruta(bahiaBlanca,rioDeJaneiro,1500).
ruta(nicaragua,florida,1000).
ruta(yatay,lujan,3).

viaje(yatay,lujan,1000,galeon(2500)).
viaje(buenosAires,lujan,100000,galera(espania)).
%viaje(puerto1,puerto2,10000,galeon(10)).
%viaje(puerto2,puerto3,80000,carabela(700,60)).
%viaje(puerto4,puerto5,9000,galera(reinoUnido)).

pirata(jackSparrow,barco1,350).
%pirata(nicolas,barco2,800).
%pirata(rodrigo,barco3,900).
%pirata(julian,barco4,400).
pirata(jorge,holandesErrante,15111).
pirata(marcos,perlaNegra,0).

impetuCombativo(holandesErrante,31110).
impetuCombativo(perlaNegra,0).
impetuCombativo(barco1,100).
impetuCombativo(barco2,300).
impetuCombativo(barco3,200).
impetuCombativo(barco4,500).

% EJERCICIO 1

abordarEmbarcacion(Pirata,Embarcacion) :-
    pirata(Pirata,NombreBarco,Soldados),
    impetuCombativo(NombreBarco,Impetu),
    ruta(P1,P2,Distancia),
    viaje(P1,P2,ValorMercancia,Embarcacion),
    poderioPirata(Soldados,Impetu,PoderioPirata),
    resistenciaEmbarcacion(Embarcacion,Distancia,ValorMercancia,PoderioEmbarcacion),
    PoderioPirata > PoderioEmbarcacion.

poderioPirata(Soldados,Impetu,PoderioPirata) :-
    PoderioPirata is ((Soldados+2)*Impetu).

resistenciaEmbarcacion(galeon(CantCanion),Distancia,_,PoderioEmbarcacion) :-
    PoderioEmbarcacion is ((CantCanion*100)/Distancia).
resistenciaEmbarcacion(carabela(_,CantSoldados),_,ValorMercancia,PoderioEmbarcacion) :-
    PoderioEmbarcacion is (ValorMercancia / 10 + CantSoldados).
resistenciaEmbarcacion(galera(_),Distancia,_,PoderioEmbarcacion) :-
    PoderioEmbarcacion is (100/Distancia).
resistenciaEmbarcacion(galera(espania),_,ValorMercancia,PoderioEmbarcacion) :-
    PoderioEmbarcacion is (ValorMercancia*10).

% EJERCICIO 2

botinTotal(Pirata,Puerto,Botin) :-
    pirata(Pirata,_,_),
    puerto(Puerto,_),
    findall(Mercancia,(viaje(_,Puerto,Mercancia,Embarcacion),abordarEmbarcacion(Pirata,Embarcacion)),Mercancias1),
    findall(Mercancia,(viaje(Puerto,_,Mercancia,Embarcacion),abordarEmbarcacion(Pirata,Embarcacion)),Mercancias2),
    sumlist(Mercancias1, Suma1),
    sumlist(Mercancias2, Suma2),
    Botin is (Suma1+Suma2).

% EJERCICIO 3

capitanDecadente(Pirata) :-
    pirata(Pirata,_,Soldados),
    not(abordarEmbarcacion(Pirata,_)),
    Soldados < 10.

capitanTerrorifico(Pirata) :-
    pirata(Pirata,_,_),
    puerto(Puerto,_),
    abordaTodo(Pirata,Puerto),
    forall((pirata(Pirata2,_,_),Pirata \= Pirata2),
                not(abordaTodo(Pirata2,Puerto))).

abordaTodo(Pirata,Puerto) :-
    puerto(Puerto,_),
    pirata(Pirata,_,_),
    forall(viaje(Puerto,_,_,Embarcacion),
                abordarEmbarcacion(Pirata,Embarcacion)),
    forall(viaje(_,Puerto,_,Embarcacion),
                abordarEmbarcacion(Pirata,Embarcacion)).

capitanExcentrico(Pirata) :-
    pirata(Pirata,_,_),
    findall(CantSoldados,viaje(_,_,_,carabela(_,CantSoldados)),SoldadosTotales),
    sumlist(SoldadosTotales,Suma),
    Suma > 1000.

% EJERCICIO 4

puedeIr(Pirata,CiudadA,CiudadB) :-
    ruta(CiudadA,CiudadB,Distancia),
    impetuCombativo(Pirata,Impetu),
    poderioPirata(Pirata,Impetu,Poderio),
    Poderio > Distancia.
puedeIr(Pirata,CiudadA,CiudadB) :-
    pirata(Pirata,_,_),
    ruta(PtoMedio,CiudadB,_),
    puedeIr(Pirata,CiudadA,PtoMedio).