%Contamos información sobre cada zona del océano y sus lugares:

zona(pacifico,[anemona,fosa, arrecife]).
zona(atlantico,[bahia]).

%Los habitantes del mar son numerosos y cada uno se encuentra en una zona. Entre ellos hay peces, pajaros, pulpos y ballenas.

%De un pez se conoce el nombre, la especie y su lugar de nacimiento
habitante(pacifico, pez(nemo, payaso, anemona)).
habitante(pacifico, pez(marlin, payaso, anemona)).
habitante(pacifico, pez(dory, cirujano, fosa)).

%De los pajaros se sabe el nombre y las cosas que llevan en el pico
habitante(pacifico, pajaro(becky,[pochoclo, balde, brujula])).

%De los pulpos, el nombre y la cantidad de tentáculos que perdieron
habitante(atlantico, pulpo(hank,1)).

%De las ballenas y tortugas se sabe el nombre
habitante(atlantico, ballena(bailey)).
habitante(atlantico, ballena(destiny)).
habitante(pacifico, tortuga(crush)).

%Queremos saber los lugares donde puede estar Dory, que son todos los lugares de la zona del mar donde habita ella y su lugar de nacimiento.
puedeEstarDory(Lugar):-
    habitante(Zona,pez(dory,_,_)),
    zona(Zona,Lugares),
    member(Lugar,Lugares).

puedeEstarDory(Lugar):-
    habitante(_,pez(dory,_,Lugar)).

%Averiguar los vecinos de cualquier animal, que son los que habitan la misma zona.

esVecino(Animal, Vecino):-
    habitante(Zona,Animal),
    habitante(Zona,Vecino),
    Animal \= Vecino.

%Queremos saber si una especie de peces es unida, lo que sucede cuando todos sus miembros viven en la misma zona.

esUnida(Especie):-
    habitante(Zona,pez(_,Especie,_)),
    forall(habitante(Zona2,pez(_,Especie,_)),
        Zona == Zona2).

%Obtener los nombres de los animales que hablan cetáceo, sabiendo que tanto Dory como las ballenas son capaces de hacerlo.

hablaCetaceo(Nombre):-
    habitante(_,ballena(Nombre)).

hablaCetaceo(dory).

%Los animales pueden buscar peces pero no todos buscan la misma cantidad.
%Las tortugas buscan tantos peces como haya en su zona del océano.
%Los pulpos pueden buscar tantos peces como tentáculos tengan (ocho menos la cantidad que hayan perdido).
%Los pájaros pueden buscar un pez si tienen una brújula
%Las ballenas pueden buscar el doble de peces que las tortugas, pero sólo si no hay tortugas en su zona.
%Los peces pueden buscar a un solo pez.
%Se necesita saber la cantidad total de peces que podría ser buscados por todos los habitantes de una zona del mar.

buscarPeces(Zona, Cantidad):-
    zona(Zona,_),
    findall(Cant,(habitante(Zona, Animal),buscaEseAnimal(Animal, Cant)),Cantidades),
    sumlist(Cantidades, Cantidad).

buscaEseAnimal(tortuga(Nombre),Cantidad):-
    habitante(Zona,tortuga(Nombre)),
    cantidadDePeces(Zona,Cantidad).

cantidadDePeces(Zona,Cantidad):-
    findall(Pez,habitante(Zona,pez(Pez,_,_)),Pecez),
    length(Pecez, Cantidad).

buscaEseAnimal(pulpo(_,Tenta),Cantidad):-
    Tenta < 8,
    Cantidad is (8-Tenta).

buscaEseAnimal(pajaro(_,CosasLleva),Cantidad):-
    member(brujula,CosasLleva),
    Cantidad is 1.

buscaEseAnimal(ballena(Nombre),Cantidad):-
    habitante(Zona,ballena(Nombre)),
    not(hayTortugas(Zona)),
    cantidadDePeces(Zona,Cant),
    Cantidad is (Cant*2).

hayTortugas(Zona):-
    habitante(Zona,ballena(_)).

buscaEseAnimal(pez(_,_,_),1).

%Se quiere averiguar quiénes pueden buscar a Dory, que son aquellos animales que son vecinos, que no hablan cetáceo y que pueden buscar al menos un pez. Mostrar ejemplos de consulta.  

puedeBuscarADory(Animal):-
    esVecino(Animal, pez(dory,_,_)),
    not(hablaCetaceo(Animal)),
    buscaEseAnimal(Animal, _).
