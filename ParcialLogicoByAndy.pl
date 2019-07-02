%PARCIAL CABRERA
%El dia del gran eclipse en argentina, buscamos un buen lugar para verlo.

%  Contamos con información de lugares

%lugar(Ciudad,Provincia,Horario(Horas,Minutos),Altura,Duracion(Minutos,Segundos)).
lugar(arrecifes,buenosAires,horario(17,44), 2.5,duracion(0, 40)).
lugar(bellaVista,buenosAires,horario(17,41), 11.5,duracion(2, 27)).
lugar(carmenDeAreco,buenosAires,horario(17,44), 2.1,duracion(1, 30)).
lugar(chepes,laRioja,horario(17,42), 8.9,duracion(2, 03)).
lugar(chacabuco,buenosAires,horario(17,43), 2.6,duracion(2, 07)).
lugar(ezeiza,buenosAires,horario(17,44), 0.9,duracion(1, 01)).
lugar(jachal,sanJuan,horario(17,41), 11.1,duracion(1, 39)).
lugar(pergamino,buenoAires,horario(17,44), 2.9,duracion(0, 56)).
lugar(jachal,sanJuan,horario(17,41), 11.1,duracion(1, 39)).
lugar(quines,sanLuis,horario(17,42), 7.8,duracion(2, 13)).
lugar(rodeo,sanJuan,horario(17,41), 11.5,duracion(2, 16)).
lugar(rioCuarto,cordoba,horario(17,42), 6.3,duracion(1, 54)).
lugar(venadoTuerto,santaFe,horario(17,43), 4.1,duracion(2, 11)).
lugar(merlo,sanLuis,horario(17,42), 7.1,duracion(2, 19)).

%servicio(Nombre,Ciudades).
servicio(telescopio,[bellaVista,chepes,ezeiza]).
servicio(reposerasPublicas,[chacabuco,arrecifes,chepes,venadoTuerto]).
servicio(observatorioAstronomico,[quines]).
servicio(lentesParaSol,[quines]).

%Los lugares donde la altura del sol es más de 10º o empieza después de las 17:42.
alturaDelSol(Lugar):-
    lugar(Lugar,_,_,Altura,_),
    Altura > 10.

alturaDelSol(Lugar):-
    lugar(Lugar,_,Horario,_,_),
    esMayorHorario(Horario,horario(17,42)).

esMayorHorario(horario(Horas1,_),horario(Horas2,_)):- Horas1 > Horas2.
esMayorHorario(horario(Horas,Min1),horario(Horas,Min2)):- Min1 > Min2.

%Los lugares que no tienen ningún servicio.

noTieneServicio(Lugar):-
    lugar(Lugar,_,_,_,_),
    forall(servicio(_,Servicios),
        not(member(Lugar,Servicios))).

%Las provincias que tienen un sola ciudad donde verlo.

soloUnaCiudad(Provincia):-
    lugar(_,Provincia,_,_,_),
    cantidadCiudades(Provincia,1).

cantidadCiudades(Provincia,Cantidad):-
    findall(Ciudad,lugar(Ciudad,Provincia,_,_,_),Ciudades),
    length(Ciudades, Cantidad).

%lugar(Ciudad,Provincia,Horario(Horas,Minutos),Altura,Duracion(Minutos,Segundos)).


%El lugar donde dura más.
duraMas(Ciudad):-
    lugar(Ciudad,_,_,_,Duracion),
    duracionEnMinutos(Duracion,Minutos1),
    forall((lugar(Ciudad2,_,_,_,_),Ciudad \= Ciudad2,duracionPorLugar(Ciudad2,Minutos2)),
        Minutos1 > Minutos2).

duracionEnMinutos(duracion(Minu,Segundos),Minutos):-
    Minutos is (Segundos/60+Minu).

duracionPorLugar(Lugar,Minutos):-
    lugar(Lugar,_,_,_,Duracion),
    duracionEnMinutos(Duracion,Minutos).


%La duración promedio del eclipse:
%   en todo el pais
%   en cada provincia
%   en las ciudades con telescopio

promedioPais(Promedio):-
    findall(Duracion,(lugar(Lugar,_,_,_,_),duracionPorLugar(Lugar,Duracion)),Duraciones),
    hacerPromedio(Duraciones,Promedio).

promedioCiudadesTele(Promedio):-
    findall(Duracion,(tieneTelescopio(Lugar),duracionPorLugar(Lugar,Duracion)),Duraciones),
    hacerPromedio(Duraciones,Promedio).

promedioProvincia(Provincia,Promedio):-
    lugar(_,Provincia,_,_,_),
    findall(Duracion,(lugar(_,Provincia,_,_,Tiempo),duracionEnMinutos(Tiempo,Duracion)),Duraciones),
    hacerPromedio(Duraciones,Promedio).

hacerPromedio(Duraciones,Promedio):-
    length(Duraciones,CantidadLugares),
    sumlist(Duraciones,DuracionesTot),
    CantidadLugares \= 0,
    Promedio is (DuracionesTot/CantidadLugares).

tieneTelescopio(Ciudad):-
    servicio(telescopio,Ciudades),
    member(Ciudad,Ciudades).

    

%Analizar la inversibilidad de los predicados del item 2 y 5. Justificar.
%PREDICADO 2
%El predicado noTieneServicio(Lugar) es inversible ya que se puede realizar una consulta existencial, en el caso que el predicado sea el siguiente:

%noTieneServicio(Lugar):-
%    forall(servicio(_,Servicios),
%        not(member(Lugar,Servicios))).

%No seria inversible

%PREDICADO 5
%La funcion hacerPromedios no es inversible ya que en si queremos consulta por un determinado Promedio, no se podria llegar a hacer una consulta existencial
%Ya que existe infinitos casos en que le realizamos el promedio a la lista Duraciones y nos podria dar el Promedio que buscabamos.

%En cambio la funcion promedioProvincia es inversible ya que se puede realizar una consulta en la cual pregunte por un promedio y devuelva las provincias que cumple con dicho promedio.

