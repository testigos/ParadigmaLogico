rata(remy,gusteaus).
rata(emile,bar).
rata(django,pizzeria).

cocina(linguini,ratatouille,3).
cocina(linguini,sopa,5). 
cocina(colette,salmonAsado,9).
cocina(colette,ratatouille,15).
cocina(horst,ensaladaRusa,8).

trabajaEn(gusteaus,linguini).
trabajaEn(gusteaus,colette).
trabajaEn(gusteaus,skinner).
trabajaEn(gusteaus,horst).
trabajaEn(cafeDes2Moulins,amelie).

restaurante(gusteaus).
restaurante(bar).
restaurante(pizzeria).
restaurante(cafeDes2Moulins).

inspeccionSatisfactoria(Restaurante) :-
    restaurante(Restaurante),
    not(rata(_,Restaurante)).

chef(Empleado,Restaurante) :-
    trabajaEn(Restaurante,Empleado),
    cocina(Empleado,_,_).

chefcito(Rata) :-
    rata(Rata,ViveEn),
    trabajaEn(ViveEn,linguini).

cocinaBien(Chef,Plato) :-
    cocina(Chef,Plato,Exp),
    Exp > 7.
cocinaBien(remy,Plato) :-
    cocina(_,Plato,_).

encargadoDe(Chef,Plato,Restaurante) :-
    cocina(Chef,Plato,Exp),
    trabajaEn(Restaurante,Chef),
    forall((trabajaEn(Restaurante,Chef2),cocina(Chef2,Plato,Exp2),Chef2 \= Chef),
            Exp > Exp2).

plato(ensaladaRusa,entrada([papa,zanahoria,arvejas,huevo,mayonesa])).
plato(bifeDeChorizo,principal(pure,20)).
plato(frutillasConCrema,postre(265)).

grupo(testigos).

saludable(Plato) :-
    plato(Plato,X),
    calorias(X,Cal),
    Cal < 75.
saludable(Plato) :-
    plato(Plato,postre(_)),
    grupo(Plato).

calorias(entrada(Lista),Cal) :-
    length(Lista,Cantidad),
    Cal is (Cantidad * 15).
calorias(principal(pure,Coccion),Cal) :-
    Cal is ((5 * Coccion) + 20).
calorias(principal(papasFritas,Coccion),Cal) :- %% ESTOY REPITIENDO LOGICA???
    Cal is ((5 * Coccion) + 50).
calorias(principal(ensalada,Coccion),Cal) :-
    Cal is ((5 * Coccion)).
calorias(postre(Cal),Cal).

criticaPositiva(Restaurante,Critico) :-
    inspeccionSatisfactoria(Restaurante),
    critico(Restaurante,Critico).

critico(Restaurante,antonEgo) :-
    forall(trabajaEn(Restaurante,Chef),
            cocinaBien(Chef,ratatouille)).
critico(Restaurante,cristophe) :-
    findall(Chef,
            trabajaEn(Restaurante,Chef),
            Chefs),
    length(Chefs,Cant),
    Cant > 3.
critico(Restaurante,cormillot) :-
    forall((trabajaEn(Chef,Restaurante),cocina(Chef,Plato,_)),
            saludable(Plato)),
    forall((trabajaEn(Chef,Restaurante),cocina(Chef,Plato,_),plato(Plato,entrada(Ingredientes))),
            member(zanahoria,Ingredientes)).