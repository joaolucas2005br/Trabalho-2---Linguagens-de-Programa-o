:- use_module(library(readutil)).

%livros

livro('A Arte da Guerra', 'Sun Tzu', -500, 'Estrategia').
livro('Dom Quixote', 'Miguel de Cervantes', 1605, 'Romance').
livro('O Príncipe', 'Nicolau Maquiavel', 1532, 'Politica').
livro('A Divina Comédia', 'Dante Alighieri', 1320, 'Poesia').
livro('Crime e Castigo', 'Fiódor Dostoiévski', 1866, 'Romance').
livro('O Processo', 'Franz Kafka', 1925, 'Ficção').
livro('Cem Anos de Solidão', 'Gabriel García Márquez', 1967, 'Realismo Magico').
:- dynamic livro/4.

%autores

autor('Sun Tzu', 'Chinesa').
autor('Miguel de Cervantes', 'Espanhola').
autor('Nicolau Maquiavel', 'Italiana').
autor('Dante Alighieri', 'Italiana').
autor('Fiódor Dostoiévski', 'Russa').
autor('Franz Kafka', 'Austro-Hungara').
autor('Gabriel García Márquez', 'Colombiana').
:- dynamic autor/2.

%users

pessoa('Ana Souza', 101).
pessoa('Carlos Mendes', 102).
pessoa('Beatriz Lima', 103).
pessoa('Rafael Oliveira', 104).
pessoa('Juliana Costa', 105).
pessoa('Fernando Alves', 106).
pessoa('Castro Alves', 107).
:- dynamic pessoa/2.

:- dynamic emprestimo/3.

%livros_por_autor

livrosPorAutor(A) :- auxLivrosPorAutor(A, L),write(L).
auxLivrosPorAutor(A, L) :- findall(T, livro(T, A, _, _), L).

%livros_antigos

livrosAntigos(A) :- auxLivrosAntigos(A,L),write(L).
auxLivrosAntigos(A, L) :- findall(T,(livro(T, _, B, _), B =< A),L).

%autor_exists

existeAutor(N) :- autor(N,_).

%add_autor

createAutor(N,C) :- \+ existeAutor(N),atom(N),atom(C),assertz(autor(N,C)).

%add_livro

createBook(T, A, Y, G) :- existeAutor(A), \+ existeLivro(T, A, Y), atom(T), atom(A), integer(Y),atom(G),assertz(livro(T, A, Y, G)).

%livro_exists

existeLivro(T, A, Y) :- livro(T, A, Y, _).

%existe_id

existeId(I) :- pessoa(_, I).

%add_pessoa

add(N,I) :-  \+ existeId(I),assertz(pessoa(N, I)).

%disponivel

disponivel(T) :-  existeLivro(T, _, _),\+ emprestimo(T,_,_).

%emprestimo

addEmprestimo(T,I,D) :- existeLivro(T, _, _),disponivel(T),existeId(I), assertz(emprestimo(T,I,D)).

%devolucao

returnBook(T,I) :- emprestimo(T,I,_), retract(emprestimo(T,I,_)).

%emprestimo_por_pessoa_id

emprestimosAtivosPorId(I) :- auxemprestimosAtivosPorId(I,L),write(L).
auxemprestimosAtivosPorId(I,L) :- findall(T,emprestimo(T,I,_),L).

%emprestimo_por_pessoa

emprestimosAtivos(N) :-  pessoa(N,I),emprestimosAtivosPorId(I).

%interface

menu :-
    nl,
    write('===== BIBLIOTECA ====='), nl,
    write('1 - Livros por autor'), nl,
    write('2 - Livros antigos'), nl,
    write('3 - Verificar disponibilidade'), nl,
    write('4 - Emprestar livro'), nl,
    write('5 - Devolver livro'), nl,
    write('6 - Emprestimos por pessoa'), nl,
    write('0 - Sair'), nl,
    read_line_to_string(user_input, S),
    number_string(Op, S),
    executar(Op).

executar(1) :-
    write('Autor: '),
    read_line_to_string(user_input, S),
    atom_string(A, S),
    livrosPorAutor(A),
    nl,
    read_line_to_string(user_input, _),
    menu.

executar(2) :-
    write('Ano maximo: '),
    read_line_to_string(user_input, S),
    number_string(Ano, S),
    livrosAntigos(Ano),
    nl,
    read_line_to_string(user_input, _),
    menu.

executar(3) :-
    write('Titulo: '),
    read_line_to_string(user_input, S),
    atom_string(T, S),
    ( disponivel(T)
      -> write('Livro disponivel')
      ;  write('Livro indisponivel')
    ),
    nl,
    read_line_to_string(user_input, _),
    menu.

executar(4) :-
    write('Titulo: '),
    read_line_to_string(user_input, S1),
    atom_string(T, S1),

    write('Id Pessoa: '),
    read_line_to_string(user_input, S2),
    number_string(I, S2),

    write('Data: '),
    read_line_to_string(user_input, D),

    ( addEmprestimo(T, I, D)
      -> write('Emprestimo realizado')
      ;  write('Falha no emprestimo')
    ),
    nl,
    read_line_to_string(user_input, _),
    menu.

executar(5) :-
    write('Titulo: '),
    read_line_to_string(user_input, S1),
    atom_string(T, S1),

    write('Id Pessoa: '),
    read_line_to_string(user_input, S2),
    number_string(I, S2),

    ( returnBook(T, I)
      -> write('Livro devolvido')
      ;  write('Falha na devolucao')
    ),
    nl,
    read_line_to_string(user_input, _),
    menu.

executar(6) :-
    write('Nome: '),
    read_line_to_string(user_input, S),
    atom_string(N, S),
    emprestimosAtivos(N),
    nl,
    read_line_to_string(user_input, _),
    menu.

executar(0) :-
    write('Encerrando...'), nl.

executar(_) :-
    write('Opcao invalida'), nl,
    menu.