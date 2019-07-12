% eclipse(Ciudad,Provincia,horario(Horas,Minutos),Altura,duracion(Minutos,Segundos)).
eclipse(arrecifes,buenosAires,horario(17,44),2.5,duracion(0,40)).
eclipse(bellaVista,sanJuan,horario(17,41),11.5,duracion(2,27)).
eclipse(carmenDeAreco,buenosAires,horario(17,44),2.1,duracion(1,30)).
eclipse(chacabuco,buenosAires,horario(17,43),2.6,duracion(2,07)).
eclipse(chepes,laRioja,horario(17,42),8.9,duracion(2,03)).
eclipse(ezeiza,buenosAires,horario(17,44),0.9,duracion(1,01)).
eclipse(jachal,sanJuan,horario(17,41),11.1,duracion(1,39)).
eclipse(pergamino,buenosAires,horario(17,44),2.9,duracion(0,56)).
eclipse(quines,sanLuis,horario(17,42),7.8,duracion(2,13)).
eclipse(rodeo,sanJuan,horario(17,41),11.5,duracion(2,16)).
eclipse(rioCuarto,cordoba,horario(17,42),6.3,duracion(1,54)).
eclipse(venadoTuerto,santaFe,horario(17,43),4.1,duracion(2,11)).
eclipse(merlo,sanLuis,horario(17,42),7.1,duracion(2,19)).

% servicio(Servicio,Lugares).
servicio(telescopio,[bellaVista,chepes,ezeiza]).
servicio(reposerasPublicas,[chacabuco,arrecifes,chepes,venadoTuerto]).
servicio(observatorioAstronomico,[quines]).
servicio(lentesDeSol,[quines,rodeo,rioCuarto,merlo]).

% PUNTO 1

lugares1(Ciudad) :-
    eclipse(Ciudad,_,_,Altura,_),
    Altura > 10.
lugares1(Ciudad) :-
    eclipse(Ciudad,_,horario(Hora,Minutos),_,_),
    pasadasLas1742(Hora,Minutos).

pasadasLas1742(Hora,_) :-
    Hora > 17.
pasadasLas1742(Hora,Minutos) :-
    Hora = 17,
    Minutos > 42.

% PUNTO 2

lugares2(Ciudad) :-
    eclipse(Ciudad,_,_,_,_),
    not(tieneServicio(Ciudad)).

tieneServicio(Ciudad) :-
    servicio(_,Ciudades),
    member(Ciudad,Ciudades).

% PUNTO 3

provinciasConUnaCiudad(Provincia) :-
    eclipse(_,Provincia,_,_,_),
    not(tieneDosCiudades(Provincia)).

tieneDosCiudades(Provincia) :-
    eclipse(Ciudad1,Provincia,_,_,_),
    eclipse(Ciudad2,Provincia,_,_,_),
    Ciudad1 \= Ciudad2.

% PUNTO 4

duraMas(Ciudad) :-
    eclipse(Ciudad,_,_,_,duracion(Min,Seg)),
    forall((eclipse(Ciudad2,_,_,_,duracion(Min2,Seg2)),Ciudad \= Ciudad2),
            mayorDuracion(Min,Seg,Min2,Seg2)).

mayorDuracion(Min,_,Min2,_) :-
    Min > Min2.
mayorDuracion(Min,Seg,Min2,Seg2) :-
    Min = Min2,
    Seg > Seg2.

% PUNTO 5

promedioPais(Promedio) :-
    findall(Duracion,(eclipse(_,_,_,_,Dur),duracionEnSegundos(Dur,Duracion)),Duraciones),
    promedio(Duraciones,Promedio).

promedioProvincia(Provincia,Promedio) :-
    eclipse(_,Provincia,_,_,_),
    findall(Duracion,(eclipse(_,Provincia,_,_,Dur),duracionEnSegundos(Dur,Duracion)),Duraciones),
    promedio(Duraciones,Promedio).

promedioTelescopio(Promedio) :-
    findall(Duracion,(eclipse(Ciudad,_,_,_,Dur),servicio(telescopio,Ciudades),member(Ciudad,Ciudades),duracionEnSegundos(Dur,Duracion)),Duraciones),
    promedio(Duraciones,Promedio).

promedio(Duraciones,Promedio) :-
    sumlist(Duraciones,DurT),
    length(Duraciones,Leng),
    Promedio is (DurT / Leng).

duracionEnSegundos(duracion(Min,Seg),Duracion) :-
    Duracion is ((Min * 60) + Seg).

% PUNTO 6

% Mi vieja lo analizo y dijo que estaba todo bien.