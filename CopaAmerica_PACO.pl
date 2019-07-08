% gol(Quien,AQueEquipo,tiempo(Tiempo,Minutos),Instancia).
% gol(Quien,AQueEquipo,penales(NumeroDePenal),Instancia).
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

equipo(arg,[higuain,dimaria,pastore,rojo,aguero,messi,tevez]).
equipo(parag,[barrios,valdez]).
equipo(jam,[marley,rastafari,bolt]).
equipo(uru,[suarez,cabani,francescoli,mugica,tabare,artigas]).
equipo(chile,[bravo,vargas,allende,neruda,jara,hurtado,mistral]).
equipo(peru,[guerrero]).
equipo(col,[falcao,rodriguez]).

grupo(1,[arg,parag,uru,jam]).
grupo(2,[chile,bol,mex,ecu]).
grupo(3,[bra,peru,col,vene]).

fase(grupos).
fase(cuartos).
fase(semi).
fase(final).

% PUNTO 1

partidoSinGoles(Equipo) :-
    grupo(_,EquiposDelGrupo),
    member(Equipo,EquiposDelGrupo),
    member(Equipo2,EquiposDelGrupo),
    Equipo \= Equipo2,
    forall((equipo(Equipo,Jugadores),member(Jugador,Jugadores)),
            not(gol(Jugador,Equipo2,_,grupos))),
    forall((equipo(Equipo2,Jugadores2),member(Jugador2,Jugadores2)),
            not(gol(Jugador2,Equipo,_,grupos))).