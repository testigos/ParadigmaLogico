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

comparteElemento(Comida1,Comida2) :-
    carta(Comida1),
    carta(Comida2),
    elemento(Comida1,Comp,Cant1),
    elemento(Comida2,Comp,Cant2),
    Cant1 \= Cant2.

elemento(Comida,Elemento,Cantidad) :-
    lleva(Comida,Elemento,Cantidad).
elemento(Comida,Componente,Cantidad) :-
    lleva(Comida,Elemento,_),
    elemento(Elemento,Componente,Cantidad),
    Componente \= Elemento.