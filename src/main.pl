%livros

livro('A Arte da Guerra', 'Sun Tzu', -500, 'Estrategia').
livro('Dom Quixote', 'Miguel de Cervantes', 1605, 'Romance').
livro('O Príncipe', 'Nicolau Maquiavel', 1532, 'Politica').
livro('A Divina Comédia', 'Dante Alighieri', 1320, 'Poesia').
livro('Crime e Castigo', 'Fiódor Dostoiévski', 1866, 'Romance').
livro('O Processo', 'Franz Kafka', 1925, 'Ficção').
livro('Cem Anos de Solidão', 'Gabriel García Márquez', 1967, 'Realismo Magico').

%autores

autor('Sun Tzu', 'Chinesa').
autor('Miguel de Cervantes', 'Espanhola').
autor('Nicolau Maquiavel', 'Italiana').
autor('Dante Alighieri', 'Italiana').
autor('Fiódor Dostoiévski', 'Russa').
autor('Franz Kafka', 'Austro-Hungara').
autor('Gabriel García Márquez', 'Colombiana').

%users

pessoa('Ana Souza', 101).
pessoa('Carlos Mendes', 102).
pessoa('Beatriz Lima', 103).
pessoa('Rafael Oliveira', 104).
pessoa('Juliana Costa', 105).
pessoa('Fernando Alves', 106).
pessoa('Castro Alves', 107).

%livros_por_autor

livros_por_autor(A) :- auxlivros_por_autor(A, L),write(L).
auxlivros_por_autor(A, L) :- findall(T, livro(T, A, _, _), L).