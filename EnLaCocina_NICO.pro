%COMIDAS
carta(milanesaConEnsalada).
carta(budinDePan).
carta(ensaladaMixta).
carta(helado).

%PRODUCTOS
lleva(milanesa,huevo,2).
lleva(milanesa,panRallado,100).
lleva(milanesa,carne,500).
lleva(ensaladaMixta,lechuga,2).
lleva(ensaladaMixta,tomate,1).
lleva(budinDePan,pan,200).
lleva(helado,leche,3).
lleva(budinDePan,leche,5).
lleva(panRallado,pan,1).
lleva(milanesaConEnsalada,milanesa,1).
lleva(milanesaConEnsalada,ensaladaMixta,2).

%INGREDIENTES
ingrediente(panificacion(pan,0.25,5)).
ingrediente(animal(huevo,5)).
ingrediente(animal(carne,4)).
ingrediente(animal(leche,2)).
ingrediente(vegetal(lechuga,verde,3)).
ingrediente(vegetal(tomate,rojo,1)).

ingrediente(X) :-
    ingrediente(panificacion(X,_,_)).
ingrediente(X) :-
    ingrediente(animal(X,_)).
ingrediente(X) :-
    ingrediente(vegetal(X,_,_)).


porcentaje(verde,5).
porcentaje(rojo,10).

calorias(Ingrediente,Calorias) :-
    ingrediente(animal(Ingrediente,Calorias)).
calorias(Ingrediente,Calorias) :-
    ingrediente(vegetal(Ingrediente,Color,CalSinCuentas)),
    porcentaje(Color,Ajuste),
    Calorias is (CalSinCuentas-Ajuste).
calorias(Ingrediente,Calorias) :-
    ingrediente(panificacion(Ingrediente,A,B)),
    Calorias is (A*B).

% EJERCICIO 1

contieneIngrediente(Comida,Ingrediente) :-
    lleva(Comida,Ingrediente,_).
contieneIngrediente(Comida,X):-
    lleva(Comida,Ingrediente,_),
    contieneIngrediente(Ingrediente,X).

ingredientesDeUnaComida(Comida,Ingredientes) :-
    carta(Comida),
    findall(Ingrediente,contieneIngrediente(Comida,Ingrediente),Ingredientes).

comparteElemento(Comida1,Comida2) :-
    lleva(Comida1,Ingrediente,C1),
    lleva(Comida2,Ingrediente,C2),
    Comida1 \= Comida2,
    C1 \= C2.

comparteElemento(Comida1,Comida2) :-
    contieneIngrediente(Comida1,Producto),
    contieneIngrediente(Comida2,Producto),
    Comida1 \= Comida2,
    distintaCantidad(Comida1,Comida2,Producto).


distintaCantidad(C1,C2,Producto) :-
    lleva(Comida1,Producto,Cant),
    lleva(Comida2,Producto,Cant2),
    Cant \= Cant2.
% EJERCICIO 2

solito(Producto) :-
    contieneIngrediente(Producto,Ingrediente),
    forall(lleva(Producto,Ingrediente2,_),
                Ingrediente = Ingrediente2).

% EJERCICIO 3

indispensable(Ingrediente) :-
    carta(Comida),
    contieneIngrediente(Comida,Ingrediente),
    forall((carta(Comida2), Comida \= Comida2),
                contieneIngrediente(Comida2,Ingrediente)).

% EJERCICIO 5
