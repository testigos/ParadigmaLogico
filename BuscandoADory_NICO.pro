zona(pacifico,[anemona,fosa, arrecife]).
zona(atlantico,[bahia]).

habitante(pacifico, pez(nemo, payaso, anemona)).
habitante(pacifico, pez(marlin, payaso, anemona)).
habitante(pacifico, pez(dory, cirujano, fosa)).
habitante(atlantico, pez(max, cirujano, fosa)).
habitante(pacifico, pajaro(becky,[pochoclo, balde, brujula])).
habitante(pacifico, pajaro(paula,[pochoclo, balde])).
habitante(atlantico, pulpo(hank,1)).
habitante(atlantico, ballena(baCl1iley)).
habitante(atlantico, ballena(destiny)).
habitante(pacifico, tortuga(crush)).
habitante(atlantico, tortuga(crush)).

% EJERCICIO 1

dondePuedeEstar(dory,Lugar) :-
    habitante(_,pez(dory,_,Lugar)).
dondePuedeEstar(dory,Lugar) :-
    habitante(Zona,pez(dory,_,_)),
    zona(Zona,LugaresDeLaZona),
    member(Lugar,LugaresDeLaZona).

% EJERCICIO 2

vecinoDeUnAnimal(Animal,Vecino) :-
    habitante(Zona,Animal),
    habitante(Zona,Vecino),
    Animal \= Vecino.

% EJERCICIO 3

especieUnida(Especie) :-
    habitante(_,pez(Nombre,Especie,_)),
    forall((habitante(_,pez(Nombre2,Especie,_)),Nombre \= Nombre2),
                vecinoDeUnAnimal(pez(Nombre,Especie,_),pez(Nombre2,Especie,_))).


% EJERCICIO 4

hablarCetaceo(dory).
hablarCetaceo(NombreAnimal) :-
    habitante(_,ballena(NombreAnimal)).

% EJERCICIO 5

cantidadTotalDePeces(Zona,Cantidad) :-
    zona(Zona,_),
    findall(Cantidad,(habitante(Zona,Animal),cantidadPeces(Animal,Cantidad)),Cantidades),
    sumlist(Cantidades, Cantidad).

cantidadPeces(pez(_,_,_),1).
cantidadPeces(pulpo(_,TentPerdidos),Cantidad) :-
    Cantidad is (8-TentPerdidos).
cantidadPeces(pajaro(_,Cosas),1) :-
    member(brujula,Cosas).
cantidadPeces(tortuga(Nombre),Cantidad) :-
    habitante(Zona,tortuga(Nombre)),
    cantidadPecesEnZona(Zona,Cantidad).
cantidadPeces(ballena(Nombre),0) :-
    vecinoDeUnAnimal(ballena(Nombre),tortuga(_)).
cantidadPeces(ballena(Nombre),CantidadTotal) :-
    habitante(Zona,ballena(Nombre)),
    noVecinoDeTortugas(ballena(Nombre)),
    cantidadPecesEnZona(Zona,Cantidad),
    CantidadTotal is (2*Cantidad).

cantidadPecesEnZona(Zona,Cantidad) :-
    zona(Zona,_),
    findall(Pez,habitante(Zona,pez(Pez,_,_)),Peces),
    length(Peces, Cantidad).
noVecinoDeTortugas(Animal) :-
    not(vecinoDeUnAnimal(Animal,tortuga(_))).
    

% EJERCICIO 6

buscandoADory(Animal) :-
    habitante(_,Animal),
    vecinoDeUnAnimal(pez(dory,_,_),Animal),
    not(animalQueHablaCetaceo(Animal)),
    cantidadPeces(Animal,Cantidad),
    Cantidad >= 1.

animalQueHablaCetaceo(Animal) :-
    nombre(Animal,Nombre),
    hablarCetaceo(Nombre).

nombre(pez(Nombre,_,_),Nombre).
nombre(ballena(Nombre),Nombre).
    