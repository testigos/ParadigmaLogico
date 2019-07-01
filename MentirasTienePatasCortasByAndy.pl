%Se cuenta con información acerca de ciertas afirmaciones efectuadas en una determinada circunstancia histórica, en la que se indica el siglo, si es antes o después del año 0 y el lugar.
% seDiceQue(afirmacion, circunstancia).

seDiceQue(laTierraEstaSobreElefantes, historica(iii, dc, india)).
seDiceQue(romuloYRemoFundaronRoma, historica(vii, ac, europa)).
seDiceQue(joseHaceObraPublica, politica(2003)).
seDiceQue(elSegundoSemestreVaASerMejor, politica(2015)).
seDiceQue(mauriPagaSusImpuestos, politica(2015)).
seDiceQue(elTPLoHicimosEntreTodos,universitaria(junio,pdep)).
seDiceQue(laClaseLaTeniaPreparada,universitaria(abril,pdep)).

%refutacion(afirmacion, acontecimiento, momento).
refutacion(laTierraEstaSobreElefantes, viajeDeMagallanes, xvi).
refutacion(joseHaceObraPublica, revoleoGuitaEnConvento,2016).
refutacion(mauriPagaSusImpuestos, offShoreEnPanama, 2016).
refutacion(elTPLoHicimosEntreTodos, unoSoloAproboParcial,julio).
refutacion(laClaseLaTeniaPreparada, elEjemploNoFunciona,abril).


%Hacer un predicado mentira/3, que relaciona a una afirmación con la circunstancia en la que se efectuó y el momento en que se la refutó. Una afirmación se considera mentira sólo si fue refutada.

mentira(Afirmacion,Circunstancia,Momento):-
    seDiceQue(Afirmacion,Circunstancia),
    refutacion(Afirmacion,_,Momento).

%Hacer un predicado laMentiraTienePatasCortas/1 que analiza el tiempo transcurrido entre la circunstancia en que se efectuó una afirmación 
%y el momento en que se refutó. Una mentira se considera de patas cortas, si la demora fue de menos de un milenio. 

%(Se cuenta con un predicado romano2arabigo/3 que relaciona un siglo expresado en números romanas y la indicación ac/dc, 
%con el valor entero expresado en números arábigos, ejemplo: romano2arabigo(xiv, dc, 14))

%Por ejemplo:

%?laMentiraTienePatasCortas(laTierraEstaSobreElefantes)
%false

laMentiraTienePatasCortas(Afirmacion):-
    mentira(Afirmacion,Momento,Siglo),
    tienePatasCortas(Momento,Siglo).

romano2arabigo(xiv,dc,14).
romano2arabigo(iii,dc,3).
romano2arabigo(xvi,dc,16).

tienePatasCortas(historica(Siglo,ac,_),Siglo2):-
    romano2arabigo(Siglo,ac,Arabigo1),
    romano2arabigo(Siglo2,dc,Arabigo2),
    (Arabigo2+Arabigo1) < 10.


tienePatasCortas(historica(Siglo,dc,_),Siglo2):-
    romano2arabigo(Siglo,dc,Arabigo1),
    romano2arabigo(Siglo2,dc,Arabigo2),
    (Arabigo2-Arabigo1) < 10.

%Ahora aparecen afirmaciones hechas bajo otras circunstancias y que también pueden haber sido refutadas. Además de las circunstancias históricas, se identifican:
periodo(4).
%politica(año)
%universitaria(nombreDelMes, materia)
%Adecuar las soluciones anteriores para contemplar los nuevos requerimientos, sabiendo que una mentira se considera de patas cortas si la refutación:

%para las circunstancias políticas, demoró no más que lo que dura un período presidencial. (se cuenta con un hecho periodo(4) que representa que un período  presidencial dura 4 años)
%para las circunstancias universitarias, se produjo en el mismo mes o el siguiente. (se cuenta con un predicado meses/1 que tiene una lista ordenada con todos los nombres de los meses del año)
%Importante: No repetir logica, organizando adecuadamente el codigo.

meses([enero,febrero,marzo,abril,mayo,junio,julio,agosto,septiembre,octubre,noviembre,diciembre]).

tienePatasCortas(politica(Anio1),Anio2):-
    periodo(Per),
    (Anio2-Anio1) =< Per.

tienePatasCortas(universitaria(Mes,_),Mes).

tienePatasCortas(universitaria(Mes1,_),Mes2):-
    esSiguiente(Mes2,Mes1).

esSiguiente(Mes1,Mes2):-
    meses(Meses),
    nth1(NroMes2, Meses, Mes2),
    nth1(NroMes1, Meses, Mes1),
    NroMes1 is (NroMes2 + 1).

%Se quiere analizar la confiabilidad del refrán que titula el examen, ya que no es suficiente que haya alguna mentira 
%que tenga patas cortas (lo que ya se hizo en puntos anteriores), sino que sea más generalizado. Se plantean diferente formas de verificarlo, algunas más exigentes que otras:
%    confiabilidadRefranPobre/0 Si hay más de una mentira que tiene patas cortas
%    confiabilidadRefranAceptable/0 Si la mayoría de las mentiras tienen patas cortas
%    confiabilidadRefranExcelente/0 Si todas las mentiras tienen patas cortas.
%Importante: En solo uno de los ítems pedidos se puede utilizar findall.
    
confiabilidadRefranExcelente():-
    forall(mentira(Afirmacion,_,_),
        laMentiraTienePatasCortas(Afirmacion)).

confiabilidadRefranAceptable():-
    laMentiraTienePatasCortas(Afirmacion1),
    laMentiraTienePatasCortas(Afirmacion2),
    Afirmacion1 \= Afirmacion2.

confiabilidadRefranPobre():-  
    cantidadMentiras(Cantidad),
    cantidadMentirasPatasCortas(Cantidad2),
    Cantidad2 > (Cantidad / 2).

cantidadMentirasPatasCortas(Cantidad):-
    findall(Afirmacion,laMentiraTienePatasCortas(Afirmacion),Afirmaciones),
    length(Afirmaciones, Cantidad).

cantidadMentiras(Cantidad):-
    findall(Afirmacion,mentira(Afirmacion,_,_),Afirmaciones),
    length(Afirmaciones, Cantidad).
    

    



