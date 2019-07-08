gol(higuain,parag,tiempo(2,38),semi).
gol(dimaria,parag,tiempo(2,8),semi).
gol(dimaria,parag,tiempo(1,47),semi).
gol(pastore,parag,tiempo(1,27),semi).
gol(rojo,parag,tiempo(1,15),semi).
gol(aguero,parag,tiempo(2,30),semi).
gol(barrios,arg,tiempo(1,43),semi).
gol(vargas,peru,tiempo(1,42),semi).
gol(vargas,peru,tiempo(2,19),semi).
gol(guerrero,chile,tiempo(2,15),semi).
gol(tevez,col,penales(8),cuartos).
gol(messi,col,penales(1),cuartos).
gol(falcao,arg,penales(2),cuartos).

gol(aguero,uru,tiempo(2,21),grupos).
gol(higuain,jam,tiempo(1,11),grupos).
gol(messi,parag,tiempo(1,36),grupos).
gol(aguero,parag,tiempo(1,29),grupos).
gol(valdez,arg,tiempo(2,15),grupos).
gol(barrios,arg,tiempo(2,45),grupos).

equipo(arg, [higuain,dimaria,pastore,rojo,aguero,messi,tevez]).
equipo(parag, [barrios,valdez]).
equipo(jam, [marley,rastafari,bolt]).
equipo(uru, [suarez,cabani,francescoli,mugica,tabare,artigas]).
equipo(chile, [bravo,vargas,allende,neruda,jara,hurtado,mistral]).
equipo(peru, [guerrero]).
equipo(col, [falcao,rodriguez]).

grupo(1,[arg,parag,uru,jam]).
grupo(2,[chile,bol,mex,ecu]).
grupo(3,[bra,peru,col,vene]).

fase(grupos).
fase(cuartos).
fase(semi).
fase(final).

% PARTIDOS SIN GOL

partidoFaseGrupos(Equipo1,Equipo2) :-
    grupo(_,Equipos),
    member(Equipo1,Equipos),
    member(Equipo2,Equipos),
    Equipo1 \= Equipo2.

partidoSinGol(Equipo1) :-
    partidoFaseGrupos(Equipo1,Equipo2),
    not(huboGol(Equipo1,Equipo2,grupos)),
    not(huboGol(Equipo2,Equipo1,grupos)).

huboGol(Equipo,Equipo2,Fase) :-
    gol(Jugador,Equipo2,_,Fase),
    golDelEquipo(Jugador,Equipo).

golDelEquipo(Jugador,Equipo):-
    equipo(Equipo,Jugadores),
    member(Jugador,Jugadores).

% GANADOR

golesDeUnPartido(Equipo1,Equipo2,Fase,Goles) :-
    fase(Fase),
    equipo(Equipo1,_),
    equipo(Equipo2,_),
    Equipo1 \= Equipo2,
    findall(Gol,(gol(Jugador,Equipo2,Gol,Fase),golDelEquipo(Jugador,Equipo1)),Goles).

cantGolesPartido(E1,E2,Fase,CantGols):-
    golesDeUnPartido(E1,E2,Fase,Goles),
    length(Goles,CantGols).

ganadorPartido(Equipo1,Equipo2,Fase) :-
    equipo(Equipo1,_),
    equipo(Equipo2,_),
    Equipo1 \= Equipo2,
    cantGolesPartido(Equipo1,Equipo2,Fase,Goles1),
    cantGolesPartido(Equipo2,Equipo1,Fase,Goles2),
    Goles1 > Goles2.

% INVICTO

invicto(Equipo) :-
    equipo(Equipo,_),
    not(ganadorPartido(_,Equipo,grupos)).

% GANO POR PENALES

porPenales(Equipo,Jugador) :-
    golDelEquipo(Jugador,Equipo),
    ganadorPartido(Equipo,Equipo2,Fase),
    gol(Jugador,Equipo2,penales(Ord1),Fase),
    forall(gol(_,Equipo2,penales(Ord2),Fase),
            Ord1>=Ord2).
    
%5 PREMIOS CONMEBOL

premioTotal(Jugador,Premio) :-
    golDelEquipo(Jugador,_),
    findall(Valor,calculoPorGol(Jugador,Valor),UnidadesPorGol),
    sumlist(UnidadesPorGol,Unidades),
    Premio is (100*Unidades).

calculoPorGol(Jugador,Valor):-
    gol(Jugador,_,Situacion,Fase),
    esFinal(Fase,Coef),
    valorGol(Situacion,ValorSinCoef),
    Valor is (Coef*ValorSinCoef).

valorGol(tiempo(1,_),50).
valorGol(tiempo(2,Minutos),Minutos).
valorGol(penales(Orden),Valor):-
    Valor is (Orden*10).

esFinal(final,2).
esFinal(Fase,1):- Fase \= final.