/********************************************
 *                                          *
 * Proyeto:                                 *
 *  Mundo de los bloques                    *
 *                                          *
 *                                          *
 * Autores:                                 *
 *  Beatriz Pérez Vera                      *
 *  Roman A. Pozas Peñate                   *
 *                                          *
 * Grupo:				    *
 *  C-412                                   *
 *                                          *
 * Correos:                                 *
 *  b.vera@estudiantes.matcom.uh.cu         *
 *  r.pozas@estudiantes.matcom.uh.cu        *
 *                                          *
 ********************************************
 */


 /*
     objetivo( MesaFinal,MesaActual)triunfa si todos los elementos de MesaFinal
				    estan contenidos en MesaActual

     (las pilas de bloques de la mesa final estan contenidos en la mesa actual)

 */
objetivo([Pila_de_bloques], MesaActual) :-
    member(Pila_de_bloques, MesaActual).

objetivo([Pila|Resto_de_Mesa], MesaActual) :-
    member(Pila, MesaActual),
    objetivo(Resto_de_Mesa, MesaActual).



/*

    Mueve(MesaActual,NuevaMesa) triunfa si existe una transición de
    del estado MesaActual al estado NuevaMesa

 */
mueve(MesaActual, NuevaMesa) :-
    select([Tope|Pila1], MesaActual,Resto),
    select(Pila2, Resto, RestoPilas),
    NuevaMesa=[Pila1,[Tope|Pila2]|RestoPilas].


/*
    para evitar que existan ciclos producto al cambio en estados ya
    visitados

    mueve_sin_cilco(Visitados,EstadoActual,PróximoEstado)
    triunfa si existe una atransició entre EstadoActual y PróximoEstado
    sin que el PróximoEstado este en Visitados

 */
mueve_sin_ciclo(NodosVisitados, Nodo, ProximoNodo) :-
    mueve(Nodo, ProximoNodo),
    not(member(ProximoNodo, NodosVisitados)).


/*
    algoritmo de busqueda a lo ancho

    bfs(Ef,Cola,Top) triunfa si el estado Ef es el Top de la Cola
    (si el estado que esta el el top de la cola es un estado final)

 */

bfs(EstadoFinal, [[Nodo|Camino]|_], [Nodo,Camino]) :-
    objetivo(EstadoFinal, Nodo).

bfs(EstadoFinal, [Camino|Caminos], CaminoSolucion) :-
    expande_bfs(Camino, ExpandeCamino),
    borra_iguales(ExpandeCamino, CaminosExpandidosNoIguales),
    append(Caminos, CaminosExpandidosNoIguales, NuevoCamino),
    bfs(EstadoFinal, NuevoCamino, CaminoSolucion).


/*
    expande_bfs(EstadoActual,CaminosPosibles)
    busca todos los CaminosPosibles que se Pueden alcanzar desde
    EstadoActual

 */
expande_bfs([Nodo|Camino], CaminosExpandidos) :-
    findall([NuevoNodo, Nodo|Camino],
            mueve_sin_ciclo(Camino, Nodo, NuevoNodo),
	    CaminosExpandidos ).

/*

    al expandir los posibles caminos alcanzables desde un estado E
    existen caminos iguales representados por estado diferentes

    borrar_iguales(Caminos,CaminosDiferentes)
    triunfa si CaminosDiferentes es la lista de Caminos sin
    elementos repetidos

 */

borra_iguales([],[]).
borra_iguales([X|E],[X|R]) :-
    delete(E,X,T),
    borra_iguales(T,R).

/*
    adicionando_espacios_en_la_mesa(Cantidad_De_Bloques,Mesa,Mesa_Con_Espacios)

    triunfa si Mesa_Con_Espacios es la Mesa con Cantidad_De_Bloques como
    posibles espacios a colocar un bloque ues en el pero de los casos se
    necesitará poner todos los bloques sobre la mesa

 */

adcionando_espacios_en_la_mesa(Cantidad_De_Bloques, Estado, Estado) :-
    length(Estado, Length),
    Length = Cantidad_De_Bloques,
    !.

adcionando_espacios_en_la_mesa(1, [], [[]]) :- !.

adcionando_espacios_en_la_mesa(Cantidad_De_Bloques, [Estado|Y], [Estado|R]) :-
    M is Cantidad_De_Bloques-1,
    adcionando_espacios_en_la_mesa(M, Y, R),
    !.

adcionando_espacios_en_la_mesa(Cantidad_De_Bloques, [], [[]|R]) :-
    M is Cantidad_De_Bloques-1,
    adcionando_espacios_en_la_mesa(M, [], R).

% borra_innecesario(X, Y) triunfa si Y es el resultado d e eliminar
% listas vac韆s de X

borra_espacios_en_la_mesa_innecesario([X|[Y]], [W|T]) :-
    delete(X, [], W),
    borra_espacios_en_la_mesa_innecesario_aux(Y, T).


borra_espacios_en_la_mesa_innecesario_aux([], []) :- !.

borra_espacios_en_la_mesa_innecesario_aux([X|Y], [W|T]) :-
    delete(X, [], W),
    borra_espacios_en_la_mesa_innecesario_aux(Y, T).


/*

    mundo_de_los_bloques(N,Ei,Ef,S) triunfa si con N cajas en la mesa
    existe un conjunto de transiciones S que de un estado Ei se alcance
    estado Ef

 */

mundo_de_los_bloques(Cantidad_De_Bloques, EstadoInicial, EstadoFinal , Solucion) :-
    adcionando_espacios_en_la_mesa(Cantidad_De_Bloques, EstadoInicial, Estado_Inicial_con_Espacios),
    adcionando_espacios_en_la_mesa(Cantidad_De_Bloques, EstadoFinal, EstadoFinal_con_Espacios),
    bfs(Estado_Inicial_con_Espacios, [[EstadoFinal_con_Espacios]], Solucion_con_espacios),
    borra_espacios_en_la_mesa_innecesario(Solucion_con_espacios,Solucion).


















