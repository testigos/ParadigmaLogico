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

%Es importante conocer la conformación de los equipos, por ejemplo:
equipo(arg, [higuain,dimaria,pastore,rojo,aguero,messi,tevez]).
equipo(parag, [barrios,valdez]).
equipo(jam, [marley,rastafari,bolt]).
equipo(uru, [suarez,cabani,francescoli,mugica,tabare,artigas]).
equipo(chile, [bravo,vargas,allende,neruda,jara,hurtado,mistral]).
equipo(peru, [guerrero]).
equipo(col, [falcao,rodriguez]).

%También se conoce la conformación de las zonas y las fases con hechos como los siguientes.
grupo(1,[arg,parag,uru,jam]).
grupo(2,[chile,bol,mex,ecu]).
grupo(3,[bra,peru,col,vene]).

fase(grupos).
fase(cuartos).
fase(semi).
fase(final).

%Partidos sin goles
%Se quiere saber qué equipos jugaron partidos de la fase de grupos que terminaron empatados sin goles.
%Pista: tomar como referencia el fixture completo de los partidos de la fase de grupos.

sinGoles(Equipo):-
    equipo(Equipo,_),
    forall(gol(Jugador,_,_,grupos),
        not(perteneceAEquipo(Jugador,Equipo))).

perteneceAEquipo(Jugador, Equipo):-
    equipo(Equipo,Jugadores),
    member(Jugador,Jugadores).

cantidadDeGoles(Equipo1,Equipo2,Fase,Cantidad):-
    findall(Jugador,(perteneceAEquipo(Jugador,Equipo1),gol(Jugador,Equipo2,_,Fase)),Goles),
    length(Goles, Cantidad).
    
%Ganador
%Relaciona al equipo ganador y perdedor de un partido de una fase del campeonato, si es que lo hubiera.   
    
    %? ganador(arg,parag,grupos).
    %false
    
    
    %? ganador(arg,Equipo,semi).
    %Equipo = parag

ganador(EquipoGanador, EquipoPerdedor, Fase):-
    equipo(EquipoGanador,_),
    equipo(EquipoPerdedor,_),
    EquipoGanador \= EquipoPerdedor,
    cantidadDeGoles(EquipoGanador,EquipoPerdedor,Fase,Cantidad1),
    cantidadDeGoles(EquipoPerdedor,EquipoGanador,Fase,Cantidad2),
    Cantidad1 > Cantidad2.

%Invicto
%Permite averiguar si hay equipos que terminaron invictos la fase de grupos.


%? invicto(arg).
%True

invicto(Equipo):-
    equipo(Equipo,_),
    forall((ganador(_, Equipo2, grupos),equipo(Equipo2,_)),
        Equipo \= Equipo2).

%Ganó por penales
%Permite averiguar si existe algún equipo que ganó por penales, y en caso afirmativo quién fue el que hizo el penal decisivo.

%? porPenales(Equipo,Jugador)   
%Equipo = arg
%Jugador = tevez

porPenales(Equipo,Jugador):-
    ganador(Equipo,Perdedor,Fase),
    perteneceAEquipo(Jugador,Equipo),
    gol(Jugador,Perdedor,penales(NumJ),Fase),
    forall((gol(Jugador2,Perdedor,penales(Num),Fase),Jugador \= Jugador2),
        NumJ > Num).


%Premios conmebol
%La Conmebol decidió otorgar premios a los jugadores en función de su desempeño, fiel a su estilo, mediante una operatorio un tanto extraña y arbitraria:
%   Por cada gol convertido en el primer tiempo, son 50 unidades
%   Para los del segundo tiempo, tantas unidades como el minuto en que se haya convertido.
%   Para los de la definición de penales, 10 unidades por el número de orden del penal.
%   En cualquier modalidad, la final duplica los valores
%Los jugadores reciben 100 dólares por cada unidad acumulada a lo largo del campeonato.
%Se quiere saber el premio total para cualquier jugador.
unidadesPorGol(Jugador,UnidadesTot):-
    gol(Jugador,_,Gol,Fase),
    tipoDeUnidades(Jugador,Gol,Unidad),
    esFaseFinal(Fase,Cant),
    UnidadesTot is (Unidad*Cant).

esFaseFinal(final,2).

esFaseFinal(Fase,1):-
    Fase \= final.

tipoDeUnidades(_,tiempo(1,_),50).

tipoDeUnidades(_,penales(Uni),Unidades):-
    Unidades is (Uni*10).

tipoDeUnidades(_,tiempo(_,Unidades),Unidades).

premios(Jugador,Premio):-
    findall(Unidad,unidadesPorGol(Jugador,Unidad),Unidades),
    sumlist(Unidades,Prem),
    Premio is (Prem * 100).
