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

%livros_por_autor

livrosPorAutor(A) :- auxLivrosPorAutor(A, L),write(L).
auxLivrosPorAutor(A, L) :- findall(T, livro(T, A, _, _), L).

%livros_antigos

livrosAntigos(A) :- auxLivrosAntigos(A,L),write(L).
auxLivrosAntigos(A, L) :- findall(T,(livro(T, _, B, _), B < A),L).

%add_autor

createAutor(N,C) :- atom(N),atom(C),assertz(autor(N,C)).

%autor_exists

existeAutor(N) :- autor(N,_).

%add_livro

createBook(T, A, Y, G) :- existeAutor(A),atom(T), atom(A), integer(Y),atom(G),assertz(livro(T, A, Y, G)).