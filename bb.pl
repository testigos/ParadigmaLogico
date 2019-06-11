puntaje(maria,[3,10,8],disciplina(canto,folklore)).

puntaje(sofia,[3,6,9],disciplina(canto,folklore)).

puntaje(juan,[3,10,10,8],disciplina(canto,folklore)).

puntaje(sofia,[3,6,9],disciplina(canto,folklore)).

puntaje(maria,[5,1],disciplina(baile,clasico)).

puntaje(sofia,[10,9,7,5],disciplina(baile,folklore)).

persona(maria).
persona(sofia).

compitio(Alguien):-
    puntaje(Alguien,_,_).

promedio(Alguien,Disciplina,P):-
    puntaje(Alguien,Lista,Disciplina),
    sum_list(Lista, Suma),
    length(Lista, Cantidad),
    P is (Suma/Cantidad).

campeon(Alguien,Disciplina):-
    persona(Alguien),
    persona(Alguien2),
    forall(compitio(Alguien2),
          (promedio(Alguien,Disciplina,P),promedio(Alguien2,Disciplina,P2),P>P2)).
