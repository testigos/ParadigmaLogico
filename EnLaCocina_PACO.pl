carta(milanesaConEnsalada).
carta(budinDePan).
carta(ensaladaMixta).

lleva(milanesa,huevo,2).
lleva(milanesa,panRallado,100).
lleva(milanesa,carne,500).
lleva(ensaladaMixta,lechuga,2).
lleva(ensaladaMixta,tomate,1).
lleva(budinDePan,pan,200).
lleva(budinDePan,leche,5).
lleva(panRallado,pan,1).
lleva(milanesaConEnsalada,milanesa,1).
lleva(milanesaConEnsalada,ensaladaMixta,2).

ingrediente(panificacion(pan,0.25,5)).
ingrediente(animal(huevo,5)).
ingrediente(animal(carne,4)).
ingrediente(animal(leche,2)).
ingrediente(vegetal(lechuga,verde,3)).
ingrediente(vegetal(tomate,rojo,1)).

porcentaje(verde,5).
porcentaje(rojo,10).

% PUNTO 1

comparteElemento(Comida1,Comida2) :-
    carta(Comida1),
    carta(Comida2),
    elemento(Comida1,Comp,Cant1),
    elemento(Comida2,Comp,Cant2),
    Cant1 \= Cant2.

elemento(Comida,Elemento,Cantidad) :-
    lleva(Comida,Elemento,Cantidad).
elemento(Comida,Componente,Cantidad) :-
    lleva(Comida,Elemento,Cantidad1),
    elemento(Elemento,Componente,Cantidad2),
    Cantidad is (Cantidad1 * Cantidad2).

% PUNTO 2

solito(Comida) :-
    lleva(Comida,_,_),
    not(llevaDosOMasIng(Comida)).

llevaDosOMasIng(Comida) :-
    lleva(Comida,Ing1,_),
    lleva(Comida,Ing2,_),
    Ing1 \= Ing2.

% PUNTO 3

indispensable(Componente) :-
    elemento(_,Componente,_),
    forall(carta(Comida),
            elemento(Comida,Componente,_)).

% PUNTO 4

caloriasTotal(Comida,Calorias) :-
    queIngredienteEs(Comida,Ingrediente),
    caloriasIngrediente(Ingrediente,Calorias).
caloriasTotal(Comida,Calorias) :-
    not(queIngredienteEs(Comida,_)),
    findall(Cal,caloriasComida(Comida,Cal),ListaCal),
	sumlist(ListaCal, Calorias).

caloriasComida(Comida,Calorias):-
	lleva(Comida,Ingrediente,Cantidad), 
	caloriasTotal(Ingrediente,Cal),
	Calorias is (Cal * Cantidad).

queIngredienteEs(Producto,Ingrediente) :-
    ingrediente(Ingrediente),
    queIngredienteEs2(Producto,Ingrediente).

queIngredienteEs2(Producto,panificacion(Producto,_,_)).
queIngredienteEs2(Producto,animal(Producto,_)).
queIngredienteEs2(Producto,vegetal(Producto,_,_)).

caloriasIngrediente(panificacion(_,Cal1,Cal2),Calorias) :-
    Calorias is (Cal1 * Cal2).
caloriasIngrediente(animal(_,Calorias),Calorias).
caloriasIngrediente(vegetal(_,Color,Cantidad),Calorias) :-
    porcentaje(Color,N),
    Calorias is (Cantidad - (Cantidad *  N / 100)).

