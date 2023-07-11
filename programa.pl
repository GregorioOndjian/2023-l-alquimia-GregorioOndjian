% Aquí va el código.
tiene(ana,agua).
tiene(ana,vapor).
tiene(ana,tierra).
tiene(ana,hierro). 

tiene(beto,Objeto):-
    tiene(ana,Objeto).

tiene(cata,fuego).
tiene(cata,tierra).
tiene(cata,agua).
tiene(cata,aire).

jugador(Jugador):-
    tiene(Jugador,_).


compuesto(pasto,[agua,tierra]).
compuesto(hierro,[fuego]).
compuesto(huesos,[pasto,agua]).
compuesto(presion,[hierro,vapor]).
compuesto(vapor,[agua,fuego]).
compuesto(play,[silicio,hierro,plastico]).
compuesto(silicio,[tierra]).
compuesto(plastico,[huesos,presion]).

herramienta(ana, circulo(50,3)).
herramienta(ana, cuchara(40)).
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).

elemento(Elemento):-
    compuesto(Elemento,_).

elemento(agua).
elemento(tierra).
elemento(fuego).
elemento(aire).


%2


ingredientesPara(Elemento, Jugador) :-
    jugador(Jugador),
    compuesto(Elemento, _),
    forall(necesita(Elemento, Ingrediente), tiene(Jugador, Ingrediente)).

   


necesita(Elemento,Ingrediente):-
    compuesto(Elemento,ListaIngredientes),
    member(Ingrediente, ListaIngredientes).

%3

estaVivo(agua).
estaVivo(fuego).

estaVivo(Elemento):-
    necesita(Elemento,Objeto),
    estaVivo(Objeto).

%4

puedenConstruir(Elemento,Jugador):-
    ingredientesPara(Elemento,Jugador),
    tieneHerramientaPara(Elemento,Jugador).

tieneHerramientaPara(Elemento,Jugador):-
    herramienta(Jugador,Herramienta),
    sirveParaContruir(Elemento,Herramienta).

sirveParaContruir(Elemento,libro(vida)):-
    estaVivo(Elemento).

sirveParaContruir(Elemento,libro(inerte)):-
    elemento(Elemento),
    not(estaVivo(Elemento)).

sirveParaContruir(Elemento,cuchara(Largo)):-
    cantidadDeIngredientes(Elemento,Cantidad),
    Largo >= Cantidad.

sirveParaContruir(Elemento,circulo(Diametro,Nivel)):-
    cantidadDeIngredientes(Elemento,Cantidad),
    Diametro*Nivel>= Cantidad.


cantidadDeIngredientes(Elemento,Cantidad):-
    findall(Ingrediente,necesita(Elemento,Ingrediente), ListaIngredientes),
    length(ListaIngredientes, Cantidad).
    
    

noEstaVivo(Elemento):-
    elemento(Elemento),
    not(estaVivo(Elemento)).

%5
/*
todoPoderoso(Jugador):-
    tieneElementosPrimitivos(Jugador),
    herrmientasParaConstruirTodo(Jugador).
*/


tieneSoloElementosPrimitivos_(Jugador):-
    forall(elementoPrimitivo(Elemento),tiene(Jugador,Elemento)).

tieneSoloElementosPrimitivos(Jugador):-
    forall(tiene(Jugador,Elemento),elementoPrimitivo(Elemento)).


estodoPoderoso(Jugador):-
    tiene(Jugador,Elemento),
    elementoPrimitivo(Elemento),
    tieneHerramientasNecesarias(Jugador).

elementoPrimitivo(Elemento):-
    elemento(Elemento),
    not(compuesto(Elemento,_)).


elementosQueNoTiene(Jugador,Elemento):-
    elemento(Elemento),
    not(tiene(Jugador,Elemento)).

tieneHerramientasNecesarias(Jugador):-
    forall(elementosQueNoTiene(Jugador,Elemento), tieneHerramientaPara(Elemento,Jugador)).
