%%% PRIMERA PARTE

% fobia(persona,fobia).
fobia(maria,tecnofobia).
fobia(maria,cyberfobia).
fobia(julia,eufobia).
fobia(julia,fobofobia).
fobia(ana,nomofobia).
fobia(esteban,psicopatofobia).
fobia(esteban,anatidofobia).
fobia(juan,fobofobia).
fobia(gonzalo,arcofobia).

% experienciaTraumatica(persona,experienciaTraumatica).
experienciaTraumatica(esteban,serMiradoPorUnPato).
experienciaTraumatica(esteban,volverseLoco).
experienciaTraumatica(ana,roboDeCelular).

% desencadenante(experiencia,fobia).
desencadenante(serMiradoPorUnPato,anatidofobia).
desencadenante(volverseLoco,psicopatofobia).
desencadenante(aprobarUnParcial,eufobia).
desencadenante(messiVuelveALaSeleccion,eufobia).
desencadenante(roboDeCelular,nomofobia).
desencadenante(rendirParcial,prologfobia).

fobiasModernas([anacrofobia,cyberfobia,tecnofobia,nomofobia]).

% PUNTO 1

moderno(Persona) :-
    fobia(Persona,Fobia),
    fobiasModernas(FobiasModernas),
    member(Fobia,FobiasModernas).

% PUNTO 2

contradictorio(Persona) :-
    fobia(Persona,_),
    findall(Fobia,fobia(Persona,Fobia),Fobias),
    member(fobofobia,Fobias),
    length(Fobias,Cantidad),
    Cantidad > 1.
    
% PUNTO 3

irracional(Persona,Fobia) :-
    fobia(Persona,Fobia),
    forall(experienciaTraumatica(Persona,Exp),
            not(desencadenante(Exp,Fobia))).

%%% SEGUNDA PARTE

% psicologo(nombre,chamuyero(universidad,promocion)).
% psicologo(nombre,especialista(fobiaPuntual)).
% psicologo(nombre,experimentado([experienciasTraumaticasAtendidas])).
psicologo(juanCarlos,experimentado([roboDeCelular, volverseLoco])).
psicologo(marta,especialista(eufobia)).
psicologo(gustavo,especialista(fobofobia)).
%psicologo(jose,chamuyero(universidadFobicaArgentina,1999)).
psicologo(ignacio,especialista(numerofobia)).

% PUNTO 1

puedeAtender(Psicologo,Persona,Fobia) :-
    fobia(Persona,Fobia),
    psicologo(Psicologo,Orientacion),
    puedeTratar(Orientacion,Fobia).

puedeTratar(chamuyero(_,_),_).
puedeTratar(experimentado(ExperienciasTraumaticasAtendidas),Fobia) :-
    experienciaTraumatica(_,ExperienciaTraumatica),
    desencadenante(ExperienciaTraumatica,Fobia),
    member(ExperienciaTraumatica,ExperienciasTraumaticasAtendidas).
puedeTratar(especialista(Fobia),Fobia).

% PUNTO 2

porcentajeDeDesempleo(Porcentaje) :-
    findall(Nombre,psicologo(Nombre,_),Psicologos),
    length(Psicologos,Cant1),
    findall(Nombre,(psicologo(Nombre,_),not(puedeAtender(Nombre,_,_))),PsicologosSinLaburo),
    length(PsicologosSinLaburo,Cant2),
    Porcentaje is ((Cant2 / Cant1) * 100).

% PUNTO 3

personaSana(Persona) :-
    fobia(Persona,_),
    forall(fobia(Persona,Fobia),
            puedeAtender(_,Persona,Fobia)).

%%% TERCERA PARTE

% Tu vieja va a hacer esa justificacion