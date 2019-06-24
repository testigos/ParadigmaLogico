% puertos(Nombre).
% ruta(Puerto1,Puerto2,Distancia).
% viaje(PuertoOrigen,PuertoDestino,ValorMercancia,Embarcacion). %% SOLO SE HACEN VIAJES ENTRE PUERTOS UNIDOS POR UNA RUTA
% functores de embarcacion: galeon(CantidadCaniones). carabela(CapacidadBodega,CantidadSoldados). galera(PaisBandera).
% capitanPirata(Nombre,NombreBarco,CantidadPiratas,ImpetuCombativo).

puerto(yatay).
puerto(lujan).
ruta(yatay,lujan,3).
viaje(yatay,lujan,1000,galeon(25)).
capitanPirata(jorge,holandesErrante,15111,31110).
capitanPirata(marcos,perlaNegra,0,0).

% PUNTO 1

abordar(CapitanPirata,Embarcacion) :-
    poderio(CapitanPirata,Poderio),
    viaje(PuertoOrigen,PuertoDestino,ValorMercancia,Embarcacion),
    ruta(PuertoOrigen,PuertoDestino,Distancia),
    resistencia(Distancia,ValorMercancia,Embarcacion,Resistencia),
    Poderio > Resistencia.

poderio(CapitanPirata,Poderio) :-
    capitanPirata(CapitanPirata,_,CantPiratas,ImpetuCombativo),
    Poderio is ((CantPiratas + 2) * ImpetuCombativo).

resistencia(Distancia,_,galeon(CantidadCaniones),Resistencia) :-
    Resistencia is ((CantidadCaniones * 100) / Distancia).
resistencia(_,ValorMercancia,carabela(_,CantidadSoldados),Resistencia) :-
    Resistencia is ((ValorMercancia / 10) + CantidadSoldados).
resistencia(Distancia,_,galera(espaniol),Resistencia) :-
    Resistencia is (100 / Distancia).
resistencia(_,ValorMercancia,galera(PaisBandera),Resistencia) :-
    PaisBandera \= espaniol,
    Resistencia is (ValorMercancia * 10).

% PUNTO 2

botin(CapitanPirata,Puerto,Valor) :-
    puerto(Puerto),
    capitanPirata(CapitanPirata,_,_,_),
    findall(ValorMercancia1,
            (viaje(_,Puerto,ValorMercancia1,Embarcacion),abordar(CapitanPirata,Embarcacion)),
            ListaValores1),
    sumlist(ListaValores1,Valor1),
    findall(ValorMercancia2,
            (viaje(Puerto,_,ValorMercancia2,Embarcacion),abordar(CapitanPirata,Embarcacion)),
            ListaValores2),
    sumlist(ListaValores2,Valor2),
    Valor is (Valor1 + Valor2).

% PUNTO 3

capitanDecadente(CapitanPirata) :-
    capitanPirata(CapitanPirata,_,CantidadPiratas,_),
    forall(viaje(_,_,_,Embarcacion),
            not(abordar(CapitanPirata,Embarcacion))),
    CantidadPiratas < 10.

capitanTerrorDelPuerto(CapitanPirata) :-
    capitanPirata(CapitanPirata,_,_,_),
    puerto(Puerto),
    abordaTodasLasEmbarcaciones(CapitanPirata,Puerto),
    forall(capitanPirata(CapitanPirata2,_,_,_),
            not(abordaTodasLasEmbarcaciones(CapitanPirata2,Puerto))).

abordaTodasLasEmbarcaciones(CapitanPirata,Puerto) :-
    puerto(Puerto),
    forall(viaje(_,Puerto,_,Embarcacion),
            abordar(CapitanPirata,Embarcacion)),
    forall(viaje(Puerto,_,_,Embarcacion),
            abordar(CapitanPirata,Embarcacion)).

capitanExcentrico(CapitanPirata) :-
    capitanPirata(CapitanPirata,_,_,_),
    findall(Valor,
            botin(CapitanPirata,_,Valor),
            Valores),
    sumlist(Valores,X),
    X > 1000.