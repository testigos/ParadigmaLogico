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

