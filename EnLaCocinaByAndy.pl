carta(milanesaConEnsalada).
carta(budinDePan).
carta(ensaladaMixta).

%Se conocen las recetas con la composición de los productos que elabora el restaurante, con la cantidad necesaria de cada uno.
lleva(milanesa,huevo,2).
lleva(milanesa,panRallado,100).
lleva(milanesa,carne,500).
lleva(ensaladaMixta,lechuga,2).
lleva(ensaladaMixta,tomate,1).
lleva(ensaladaMixta, pan, 45).
lleva(budinDePan,pan,200).
lleva(budinDePan,leche,5).
lleva(panRallado,pan,1).
lleva(milanesaConEnsalada,milanesa,1).
lleva(milanesaConEnsalada,ensaladaMixta,2).

%Además se conoce la información para calcular las calorías de cada ingrediente.
ingrediente(panificacion(pan,0.25,5)).
ingrediente(animal(huevo,5)).
ingrediente(animal(carne,4)).
ingrediente(animal(leche,2)).
ingrediente(vegetal(lechuga,verde,3)).
ingrediente(vegetal(tomate,rojo,1)).

porcentaje(verde,5).
porcentaje(rojo,10).

%Las calorías de un ingrediente se calculan según su origen:

%Para los productos de origen animal, es la indicada.
%Para los de origen vegetal, es la que se indica menos un porcentaje según el color.
%Para los de panificación, es la multiplicación entre ambos valores señalados.

%Definir los siguientes predicados totalmente inversibles:


%1) comparteElemento/2, que relaciona dos comidas de la carta que se hacen con algo en común, pero en diferente cantidad.  

%Comparten en forma directa el producto
%?- comparteElemento(milanesaConEnsalada,Producto).

%Comparten directa o indirectamente, es decir, puede que tengan en común algún ingrediente que se usa para elaborar algún componente del producto.
%?- comparteElemento(milanesaConEnsalada,Producto).

%Producto = budinDePan

comparteElemento(Comida1, Comida2):-
    carta(Comida1),
    carta(Comida2),
    Comida1 \= Comida2,
    lleva(Comida1,Ingrediente, Cant),
    lleva(Comida2, Ingrediente, Cant2),
    Cant \= Cant2.

contiene(Comida, Elemento , Cantidad):-
    lleva(Comida, Elemento, Cantidad).

contiene(Comida, Elemento, Cantidad):-
    lleva(Comida, OtraComida, CantidadOtra),
    contiene(OtraComida, Elemento, Cant),
    Cantidad is (CantidadOtra * Cant).

comparteElemento(Comida1, Comida2):-
    carta(Comida1),
    carta(Comida2),
    Comida1 \= Comida2,
    contiene(Comida1,Ing, Cant1),
    contiene(Comida2,Ing, Cant2),
    Cant1 \= Cant2.

%2) solito/1 son aquellos productos que se hacen con un sólo ingrediente. (importante: no se puede usar findall)

%?- solito(panRallado).
%True

solito(Producto):-
    lleva(Producto, Elemento, _),
    forall(lleva(Producto,Elemento2,_),
    Elemento = Elemento2).

%3) indispensable/1, es un ingrediente que en caso de faltar no se puede hacer ninguna comida de la carta. (ya sea que forma parte directa o indirectamente de la comida de la carta)

%?- indispensable(Ingrediente).

%False

indispensable(Ingrediente):-
    ingrediente(Ingrediente),
    forall(carta(Menu),
        esIngrediente(Menu,Ingrediente)).

esIngrediente(Menu, panificacion(Nombre,_,_)):-
    contiene(Menu, Nombre,_).

esIngrediente(Menu, animal(Nombre,_)):-
    contiene(Menu, Nombre,_).

esIngrediente(Menu, vegetal(Nombre,_,_)):-
    contiene(Menu, Nombre,_).

%4) caloriasTotal/2, que relaciona cualquier producto con su cantidad total de calorías

%?- caloriasTotal(panRallado,Calorias).
%Calorias = 1.25


convertirIngrediente(Nombre,Ingrediente):-
    ingrediente(Ingrediente),
    ingredientePorNombre(Nombre,Ingrediente).

ingredientePorNombre(Nombre, panificacion(Nombre,_,_)).
ingredientePorNombre(Nombre, animal(Nombre,_)).
ingredientePorNombre(Nombre, vegetal(Nombre,_,_)).

caloriasTotal(Producto,CaloriasTotal):-
    lleva(Producto,_,_),
    findall(Caloria,(contiene(Producto,Ingrediente,Cant),caloriasProducto(Ingrediente,Cant,Caloria)),Calorias),
    sumlist(Calorias,CaloriasTotal).

caloriasProducto(Producto,Cantidad,Calorias):-
    convertirIngrediente(Producto,Ingrediente),
    caloriasDe(Ingrediente, Calo),
    Calorias is (Cantidad * Calo).

caloriasDe(animal(_,Calorias), Calorias).

caloriasDe(vegetal(_,Color, Calo),CaloriasTotal):-
    porcentaje(Color,CalColor),
    CaloriasTotal is (Calo - CalColor).

caloriasDe(panificacion(_,Valor1,Valor2),Calorias):-
    Calorias is (Valor1 * Valor2).

%5) bomba/1, es la comida que más calorías tiene de la carta

bomba(Comida):-
    carta(Comida),
    caloriasTotal(Comida,Cantidad),
    forall((carta(Comida2),caloriasTotal(Comida2,Cantidad2),Comida \= Comida2),
        Cantidad > Cantidad2).


