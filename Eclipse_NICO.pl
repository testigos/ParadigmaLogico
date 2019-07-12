
lugar(arrecifes,buenosAires,horario(17,44),2.5,duracion(0,40)).
lugar(bellaVista,sanJuan,horario(17,41),11.5,duracion(2,27)).
lugar(carmenDeAreco,buenosAires,horario(17,44),2.1,duracion(1,30)).
lugar(chacabuco,buenosAires,horario(17,43),2.6,duracion(2,07)).
lugar(chepes,laRioja,horario(17,42),8.9,duracion(2,03)).
lugar(ezeiza,buenosAires,horario(17,44),0.9,duracion(1,01)).
lugar(jachal,sanJuan,horario(17,41),11.1,duracion(1,39)).
lugar(pergamino,buenosAires,horario(17,44),2.9,duracion(0,56)).
lugar(quines,sanLuis,horario(17,42),7.8,duracion(2,13)).
lugar(rodeo,sanJuan,horario(17,41),11.5,duracion(2,16)).
lugar(rioCuarto,cordoba,horario(17,42),6.3,duracion(1,54)).
lugar(venadoTuerto,santaFe,horario(17,43),4.1,duracion(2,11)).
lugar(merlo,sanLuis,horario(17,42),7.1,duracion(2,19)).

duracionEnSegundos(duracion(Minutos,Segundos),DuracionSegundos) :-
    DuracionSegundos is (Minutos*60 + Segundos).

servicio(telescopio,[bellaVista,chepes,ezeiza]).
servicio(reposerasPublicas,[chacabuco,arrecifes,chepes,venadoTuerto]).
servicio(observatorioAstronimoco,[quines]).
servicio(lentes,[quines,rodeo,rioCuarto,merlo]).

% EJERCICIO 1

lugaresAltos(Lugar) :-
    lugar(Lugar,_,Horario,_,_),
    mayorHorario(Horario,horario(17,42)).
lugaresAltos(Lugar) :-
    lugar(Lugar,_,_,Altura,_),
    Altura > 10.

mayorHorario(horario(Horas,_),horario(Horas2,_)):-Horas>Horas2.
mayorHorario(horario(Horas,Min1),horario(Horas,Min2)):-Min1>Min2.

noTieneServicio(Ciudad) :-
    lugar(Ciudad,_,_,_,_),
    not(tieneServicio(_,Ciudad)).

tieneServicio(Servicio,Ciudad) :-
    servicio(Servicio,Ciudades),
    member(Ciudad,Ciudades).

unicaProvincia(Provincia) :-
    lugar(Ciudad,Provincia,_,_,_),
    not((lugar(Ciudad2,Provincia,_,_,_),Ciudad \= Ciudad2)).

lugarDondeDuraMas(Ciudad) :-
    lugar(Ciudad,_,_,_,Duracion),
    duracionEnSegundos(Duracion,DuracionSegundos),
    forall((lugar(Ciudad2,_,_,_,Duracion2),duracionEnSegundos(Duracion2,DurSeg2),Ciudad \= Ciudad2) ,
                DuracionSegundos > DurSeg2).

promedioPais(Promedio) :-
    findall(Duracion,criterioFindAll(Duracion),Duraciones),
    calculoPromedio(Duraciones,Promedio).

promedioProvincia(Provincia,Promedio) :-
    esProvincia(Provincia),
    findall(Duracion,criterioFindAll(Provincia,Duracion),Duraciones),
    calculoPromedio(Duraciones,Promedio).

promedioTelescopio(Promedio) :-
    findall(Duracion,(esCiudad(Ciudad),criterioFindAll(Ciudad,Duracion)),Duraciones),
    calculoPromedio(Duraciones,Promedio).

criterioFindAll(Provincia,DuracionSegundos) :-
    lugar(_,Provincia,_,_,Duracion),
    duracionEnSegundos(Duracion,DuracionSegundos).
criterioFindAll(Duracion) :-
    lugar(_,_,_,_,DuracionSeg),
    duracionEnSegundos(DuracionSeg,Duracion).
criterioFindAll(Ciudad,Duracion) :-
    lugar(Ciudad,_,_,_,DuracionSeg),
    tieneServicio(telescopio,Ciudad),
    duracionEnSegundos(DuracionSeg,Duracion).

calculoPromedio(Duraciones,X) :-
    sumlist(Duraciones, DuracionTotal),
    length(Duraciones, CantTiempos),
    X is (DuracionTotal / CantTiempos).

esCiudad(X) :- lugar(X,_,_,_,_).
esProvincia(Provincia) :- lugar(_,Provincia,_,_,_).