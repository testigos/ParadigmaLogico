% zona(oceano,[lugares]).
zona(pacifico,[anemona,fosa,arrecife]).
zona(atlantico,[bahia]).

% habitante(oceano,pez(nombre,tipo,dondeNacio)).
habitante(pacifico,pez(nemo,payaso,anemona)).
habitante(pacifico,pez(marlin,payaso,anemona)).
habitante(pacifico,pez(dory,cirujano,fosa)).

% habitante(oceano,pajaro(nombre,[cosasEnElPico])).
habitante(pacifico,pajaro(becky,[pochoclo,balde,brujula])).

% habitante(oceano,pulpo(nombre,cantTentaculosPerdidos)).
habitante(atlantico,pulpo(hank,1)).

% habitante(oceano,ballenaotortuga(nombre)).
habitante(atlantico,ballena(bailey)).
habitante(atlantico,ballena(destiny)).
habitante(pacifico,tortuga(crush)).

% PUNTO 1

dondePuedeEstarDory(Lugares) :-
    habitante(Oceano,pez(dory,_,_)),
    zona(Oceano,Lugares).

% PUNTO 2

vecinos(Animal1,Animal2) :-
    habitante(Lugar,Animal1),
    habitante(Lugar,Animal2),
    Animal1 \= Animal2.

% PUNTO 3

unidas(Especie) :-
    habitante(_,pez(_,Especie,_)),
    forall((habitante(_,pez(Pez1,Especie,_)),habitante(_,pez(Pez2,Especie,_)),Pez1 \= Pez2),
                vivenEnLaMismaZona(Pez1,Pez2)).

vivenEnLaMismaZona(Pez1,Pez2) :-
    habitante(Zona,pez(Pez1,_,_)),
    habitante(Zona,pez(Pez2,_,_)),
    Pez1 \= Pez2.

% PUNTO 4

hablanCetaceo(Animales) :-
    findall(Animal,hablaCetaceo(Animal),Animales).

hablaCetaceo(Animal) :-
    habitante(_,ballena(Animal)).
hablaCetaceo(dory).

% PUNTO 5

buscados(Zona,Habitante,Cantidad) :-
    habitante(Zona,Habitante),
    cuantosBusca(Zona,Habitante,Cantidad).

cuantosBusca(Zona,tortuga(_),Cantidad) :-
    findall(Pez,habitante(Zona,pez(Pez,_,_)),Peces),
    length(Peces,Cantidad).
cuantosBusca(_,pulpo(_,N),Cantidad) :-
    Cantidad is (8 - N).
cuantosBusca(_,pajaro(_,Objetos),1) :-
    member(brujula,Objetos).
cuantosBusca(Zona,ballena(_),Cantidad) :-
    noHayTortugas(Zona),
    cuantosBusca(Zona,tortuga(_),Cant1),
    Cantidad is (2 * Cant1).
cuantosBusca(_,pez(_,_,_),1).

noHayTortugas(Zona) :-
    zona(Zona,_),
    forall(habitante(Zona,Animal),
        Animal \= tortuga(_)).

% PUNTO 6

quienPuedeBuscarADory(Animal) :-
    habitante(Zona,Animal),
    vecinos(Animal,pez(dory,_,_)),
    buscados(Zona,Animal,Cantidad),
    Cantidad >= 1,
    nombreDeAnimal(Animal,Nombre),
    not(hablaCetaceo(Nombre)).

nombreDeAnimal(pez(Nombre,_,_),Nombre).
nombreDeAnimal(pajaro(Nombre,_),Nombre).
nombreDeAnimal(pulpo(Nombre,_),Nombre).
nombreDeAnimal(ballena(Nombre),Nombre).
nombreDeAnimal(tortuga(Nombre),Nombre).