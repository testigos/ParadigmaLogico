% seDiceQue(afirmacion, circunstancia).
seDiceQue(laTierraEstaSobreElefantes, historica(iii, dc, india)). 
seDiceQue(romuloYRemoFundaronRoma, historica(vii, ac, europa)). 
%politica(año)
%universitaria(nombreDelMes, materia)
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

romano2arabigo(xvi,dc,16).
romano2arabigo(iii,dc,3).
romano2arabigo(vii,ac,-7).

periodo(4).

meses([enero,febrero,marzo,abril,mayo,junio,julio,agosto,septiembre,octubre,noviembre,diciembre]).

mentira(Afirmacion,Circunstancia,Refutacion):-
    seDiceQue(Afirmacion,Circunstancia),
    refutacion(Afirmacion,_,Refutacion).

laMentiraTienePatasCortas(Afirmacion) :-
    mentira(Afirmacion,Circunstancia,MomentoRefutacion),
    tienePatasCortas(Circunstancia,MomentoRefutacion).


tienePatasCortas(historica(Siglo,Ind,_),MomentoRefutacion):-
    romano2arabigo(Siglo,Ind,MomAfirm),
    romano2arabigo(MomentoRefutacion,dc,MomRefut),
    (MomRefut-MomAfirm) =< 10.
tienePatasCortas(politica(Periodo),Anio) :-
    periodo(Cant),
    (Anio - Periodo) =< Cant.
tienePatasCortas(universidad(_,Mes),MesRefut) :-
    meses(Meses),
    nth1(Index1, Meses, Mes),
    nth1(Index2, Meses, MesRefut),
    1 >= (Index2 - Index1).

confiabilidadRefranExcelentePobre:-
    forall(mentira(_,Circunstancia,Refutacion),tienePatasCortas(Circunstancia,Refutacion)).

confiabilidadRefranAceptable:-
    cantMentiras(CantMentiras),
    cantMentirasPatasCortas(CantPatasCortas),
    CantPatasCortas > (CantMentiras / 2).

cantMentiras(CantMentiras):-
    findall(Afirmacion,seDiceQue(Afirmacion,_),Mentiras),
    length(Mentiras,CantMentiras).

cantMentirasPatasCortas(CantMentiras) :-
    findall(Afirmacion,(seDiceQue(Afirmacion,_),laMentiraTienePatasCortas(Afirmacion)),MentirasPatasCortas),
    length(MentirasPatasCortas,CantMentiras).

confiabilidadRefranPobre:-
    laMentiraTienePatasCortas(Afirmacion),
    laMentiraTienePatasCortas(Afirmacion2),
    Afirmacion \= Afirmacion2.
