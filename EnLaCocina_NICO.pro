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
/*
comparteElemento(Comida1,Comida2) :-
    lleva(Comida1,Ingrediente,_),
    lleva(Comida2,Ingrediente,_),
    Comida1 \= Comida2.
*/
comparteElemento(Comida1,Comida2) :-
    ingredientesDeUnaComida(Comida1,Ingredientes),
    ingredientesDeUnaComida(Comida2,Ingredientes2),
    member(Producto,Ingredientes),
    member(Producto,Ingredientes2),
    Comida1 \= Comida2.


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


    

