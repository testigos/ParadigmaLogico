%fobia(persona, fobia).
fobia(maria, tecnofobia).
fobia(maria, cyberfobia).
fobia(julia, eufobia).
fobia(julia, fobofobia).
fobia(ana, nomofobia).
fobia(esteban, psicopatofobia).
fobia(esteban, anatidofobia).
fobia(juan, fobofobia).
fobia(gonzalo, arcofobia).

%experienciaTraumatica(persona, experienciaTraumatica).
experienciaTraumatica(esteban, serMiradoPorUnPato).
experienciaTraumatica(esteban, volverseLoco).
experienciaTraumatica(ana, roboDeCelular).

%desencadenante(experiencia, fobia).
desencadenante(serMiradoPorUnPato, anatidofobia).
desencadenante(volverseLoco, psicopatofobia).
desencadenante(aprobarUnParcial, eufobia).
desencadenante(messiVuelveALaSeleccion, eufobia).
desencadenante(roboDeCelular, nomofobia).
desencadenante(rendirParcial,prologfobia).

fobiasModernas([anacrofobia, cyberfobia, tecnofobia, nomofobia]).

% PRIMERA PARTE

moderno(Persona) :-
    fobia(Persona,Fobia),
    fobiasModernas(FobiasModernas),
    member(Fobia,FobiasModernas).

contradictorio(Persona) :-
    fobia(Persona,fobofobia),
    fobia(Persona,Fobia),
    Fobia \= fobofobia.

irracional(Persona,Fobia) :-
    fobia(Persona,Fobia),
    not(esDesencadenada(Persona,Fobia)).
esDesencadenada(Persona,Fobia) :-
    experienciaTraumatica(Persona,Experiencia),
    desencadenante(Experiencia,Fobia).

% SEGUNDA PARTE
%psicologo(nombre, orientacion).
%ORIENTACIONES
%chamuyero(universidad,promocion)
%especialista(fobiaPuntual)
%experimentado([experienciasTraumaticasAtendidas])

psicologo(juanCarlos, experimentado([roboDeCelular, volverseLoco])).
psicologo(marta, especialista(eufobia)).
psicologo(gustavo, especialista(fobofobia)).
psicologo(jose, chamuyero(universidadFobicaArgentina,1999)).
psicologo(ignacio, especialista(numerofobia)).

puedeAtender(Persona,Psicologo,Fobia) :-
    fobia(Persona,Fobia),
    psicologo(Psicologo,Orientacion),
    sirveElPsicologo(Orientacion,Fobia).

sirveElPsicologo(experimentado(Casos),Fobia) :-
    desencadenante(Caso,Fobia),
    member(Caso,Casos).
sirveElPsicologo(chamuyero(universidadFobicaArgentina,Anio),_) :-
    Anio > 1980.
sirveElPsicologo(especialista(Fobia),Fobia).

porcentajeDeDesempleo(Porcentaje) :-
    findall(Psicologo,psicologo(Psicologo,_),Psicologos),
    findall(Psico,noPuedeAtenderANadie(Psico),Psicologos2),
    length(Psicologos, CantidadTotalPsicologos),
    length(Psicologos2, CantidadDeDesempleados),
    Porcentaje is ((CantidadDeDesempleados/CantidadTotalPsicologos)*100).

noPuedeAtenderANadie(Psicologo) :-
    psicologo(Psicologo,_),
    forall(fobia(Persona,Fobia),
                not(puedeAtender(Persona,Psicologo,Fobia))).

esPersona(Persona) :-
    fobia(Persona,_).
personaSana(Persona) :-
    esPersona(Persona),
    forall(fobia(Persona,Fobia),
                (psicologo(Psicologo,_),puedeAtender(Persona,Psicologo,Fobia))).