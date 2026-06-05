:- use_module(library(readutil)).

livro('A Arte da Guerra', 'Sun Tzu', -500, 'Estrategia').
livro('Dom Quixote', 'Miguel de Cervantes', 1605, 'Romance').
livro('O Príncipe', 'Nicolau Maquiavel', 1532, 'Politica').
livro('A Divina Comédia', 'Dante Alighieri', 1320, 'Poesia').
livro('Crime e Castigo', 'Fiódor Dostoiévski', 1866, 'Romance').
livro('O Processo', 'Franz Kafka', 1925, 'Ficcao').
livro('Cem Anos de Solidão', 'Gabriel García Márquez', 1967, 'Realismo Magico').
livro('1984', 'George Orwell', 1949, 'Distopia').
livro('A Revolução dos Bichos', 'George Orwell', 1945, 'Satira').
livro('Orgulho e Preconceito', 'Jane Austen', 1813, 'Romance').
livro('O Hobbit', 'J. R. R. Tolkien', 1937, 'Fantasia').
livro('O Senhor dos Anéis', 'J. R. R. Tolkien', 1954, 'Fantasia').
livro('Harry Potter e a Pedra Filosofal', 'J. K. Rowling', 1997, 'Fantasia').
livro('Harry Potter e a Câmara Secreta', 'J. K. Rowling', 1998, 'Fantasia').
livro('O Código Da Vinci', 'Dan Brown', 2003, 'Suspense').
livro('O Alquimista', 'Paulo Coelho', 1988, 'Ficcao').
livro('Memórias Póstumas de Brás Cubas', 'Machado de Assis', 1881, 'Romance').
livro('Dom Casmurro', 'Machado de Assis', 1899, 'Romance').
livro('Capitães da Areia', 'Jorge Amado', 1937, 'Romance').
livro('Vidas Secas', 'Graciliano Ramos', 1938, 'Romance').

:- dynamic livro/4.

autor('Sun Tzu', 'Chinesa').
autor('Miguel de Cervantes', 'Espanhola').
autor('Nicolau Maquiavel', 'Italiana').
autor('Dante Alighieri', 'Italiana').
autor('Fiódor Dostoiévski', 'Russa').
autor('Franz Kafka', 'Austro-Hungara').
autor('Gabriel García Márquez', 'Colombiana').
autor('George Orwell', 'Britanica').
autor('Jane Austen', 'Britanica').
autor('J. R. R. Tolkien', 'Britanica').
autor('J. K. Rowling', 'Britanica').
autor('Dan Brown', 'Estadunidense').
autor('Paulo Coelho', 'Brasileira').
autor('Machado de Assis', 'Brasileira').
autor('Jorge Amado', 'Brasileira').
autor('Graciliano Ramos', 'Brasileira').

:- dynamic autor/2.


pessoa('Ana Souza', 101).
pessoa('Carlos Mendes', 102).
pessoa('Beatriz Lima', 103).
pessoa('Rafael Oliveira', 104).
pessoa('Juliana Costa', 105).
pessoa('Fernando Alves', 106).
pessoa('Castro Alves', 107).
pessoa('Mariana Silva', 108).
pessoa('João Pereira', 109).
pessoa('Lucas Martins', 110).
pessoa('Camila Rocha', 111).
pessoa('Patricia Gomes', 112).
pessoa('Eduardo Santos', 113).
pessoa('Gabriela Ferreira', 114).
pessoa('Leonardo Costa', 115).

:- dynamic pessoa/2.


emprestimo(101, '1984', '2026-05-01').
emprestimo(103, 'Dom Quixote', '2026-05-03').
emprestimo(104, 'O Hobbit', '2026-05-05').
emprestimo(105, 'Crime e Castigo', '2026-05-08').
emprestimo(109, 'Dom Casmurro', '2026-05-10').
emprestimo(112, 'O Alquimista', '2026-05-15').
emprestimo(114, 'Harry Potter e a Pedra Filosofal', '2026-05-18').

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