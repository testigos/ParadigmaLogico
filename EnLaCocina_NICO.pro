%COMIDAS
carta(milanesaConEnsalada).
carta(budinDePan).
carta(ensaladaMixta).
carta(helado).

%COMPONENTES
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


porcentaje(verde,5).
porcentaje(rojo,10).

% EJERCICIO 1

contieneIngrediente(Comida,Ingrediente,Cantidad) :-
    lleva(Comida,Ingrediente,Cantidad).
contieneIngrediente(Comida,X,Cantidad):-
    lleva(Comida,Ingrediente,CantidadA),
    contieneIngrediente(Ingrediente,X,CantidadB),
    Cantidad is (CantidadA*CantidadB).

comparteElemento(Comida1,Comida2) :-
    lleva(Comida1,Ingrediente,C1),
    lleva(Comida2,Ingrediente,C2),
    Comida1 \= Comida2,
    C1 \= C2.

comparteElemento(Comida1,Comida2) :-
    contieneIngrediente(Comida1,Producto,Cant),
    contieneIngrediente(Comida2,Producto,Cant2),
    Comida1 \= Comida2,
    Cant \= Cant2.
% EJERCICIO 2

solito(Producto) :-
    contieneIngrediente(Producto,Ingrediente,_),
    forall(lleva(Producto,Ingrediente2,_),
                Ingrediente = Ingrediente2).

% EJERCICIO 3

indispensable(Ingrediente) :-
    carta(Comida),
    contieneIngrediente(Comida,Ingrediente,_),
    forall((carta(Comida2), Comida \= Comida2),
                contieneIngrediente(Comida2,Ingrediente,_)).

% EJERCICIO 4

caloriasTotal(Producto,Cals) :-
    findall(Caloria,(contieneIngrediente(Producto,SubProducto,Cantidad),caloriasProd(SubProducto,Caloria,Cantidad)),Calorias),
    sumlist(Calorias,Cals).

caloriasProd(Producto,Calorias,Cantidad) :-
    ingredienteAPartirDeNombre(Producto, Ingrediente),
    calculoCalorias(Ingrediente,Cals),
    Calorias is (Cantidad*Cals).

ingredienteAPartirDeNombre(NombreIng, Ingrediente):-
	ingrediente(Ingrediente),
	ingredientePorNombre(NombreIng, Ingrediente).

ingredientePorNombre(Nombre, panificacion(Nombre, _, _)).
ingredientePorNombre(Nombre, animal(Nombre, _)).
ingredientePorNombre(Nombre, vegetal(Nombre, _, _)).


calculoCalorias(animal(_,Calorias),Calorias).
calculoCalorias(vegetal(_,Color,CalSinCuentas),Calorias) :-
    porcentaje(Color,Ajuste),
    Calorias is (CalSinCuentas - (CalSinCuentas * Ajuste / 100)).
calculoCalorias(panificacion(_,A,B),Calorias) :-
    Calorias is (A*B).


% EJERCICIO 5

bomba(Comida) :-
    carta(Comida),
    caloriasTotal(Comida,X),
    forall((carta(Comida2), Comida2 \= Comida, caloriasTotal(Comida2,Y)),
                X > Y).

