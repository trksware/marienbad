% Auteur:
% Date: 2017-10-15

%État initaile: prédicat avec le nombre de batonnées par rangé et le joueur x qui debute le jeu
etat_initial(marienbad(1,3,5,7,x)).

%Prédicat pour vérifier si c'est le joueur 1 ou 2 (ordi) qui doit jouer
etat_user(marienbad(_,_,_,_,x)).
etat_ordi(marienbad(_,_,_,_,o)).

%Prédicat d'affichage
disp( marienbad(A,B,C,D,_) ) :- nl,
writef('R1%r', ['|', A]), nl,
writef('R2%r', ['|', B]), nl,
writef('R3%r', ['|', C]), nl,
writef('R4%r', ['|', D]), nl.

%États finaux: 1 batonné restant dans l'ensemble des rangées, et joueur qui doit jouer (retourne le perdant)
etat_final( marienbad(1,0,0,0,J), J):- J \= v.
etat_final( marienbad(0,1,0,0,J), J):- J \= v.
etat_final( marienbad(0,0,1,0,J), J):- J \= v.
etat_final( marienbad(0,0,0,1,J), J):- J \= v.

%Operation de prendre un certain nombre de batonnées d'un rangées
operation( marienbad(A,B,C,D,J), prendre(J,1,N), marienbad(A1,B,C,D,K) ):- A>=1, N@=<A, A1 is A - N, n(J,K).
operation( marienbad(A,B,C,D,J), prendre(J,2,N), marienbad(A,B1,C,D,K) ):- B>=1, N@=<B, B1 is B - N, n(J,K).
operation( marienbad(A,B,C,D,J), prendre(J,3,N), marienbad(A,B,C1,D,K) ):- C>=1, N@=<C, C1 is C - N, n(J,K).
operation( marienbad(A,B,C,D,J), prendre(J,4,N), marienbad(A,B,C,D1,K) ):- D>=1, N@=<D, D1 is D - N, n(J,K).

%Prédicat pour éviter de boucler
n(x,o).
n(o,x).

%Cas de base pour le prédicat jeu (cas ou c'est le joueur 1 qui gagne)
jeu( ETAT, GAGNANT, M ):-
etat_final( ETAT, PERDANT ),
n(GAGNANT, PERDANT),
GAGNANT == 'x',
write('Le gagnant est : '),
write('Joueur 1'),
nl.

%Cas de base pour le prédicat jeu (cas ou c'est le joueur 2 qui gagne)
jeu( ETAT, GAGNANT, M ):-
etat_final( ETAT, PERDANT ),
n(GAGNANT, PERDANT),
GAGNANT == 'o',
M == 1,
write('Le gagnant est : '),
write('Joueur 2'),
nl.

%Cas de base pour le prédicat jeu (cas ou c'est l'ordinateur qui gagne)
jeu( ETAT, GAGNANT, M ):-
etat_final( ETAT, PERDANT ),
n(GAGNANT, PERDANT),
GAGNANT == 'o',
M == 2,
write('Le gagnant est : '),
write('Ordinateur'),
nl.

%Prédicat (jeu) récursif pour le tour du joueur 1
jeu( ETAT, GAGNANT, M ) :-
etat_user(ETAT),
write('Votre tour (J1): (numero de ranger, nombre de batonneés)'),
nl,
read(R),
read(N),
operation( ETAT, prendre(x,R,N), ETAT_SUIVANT ),
write(prendre(x,R,N)),
disp( ETAT_SUIVANT ),
write(ETAT_SUIVANT),
nl,
jeu( ETAT_SUIVANT, GAGNANT, M ).       %Appelle recursif pour passer la main


%Prédicat (jeu) récursif pour le tour du joueur 2
jeu( ETAT, GAGNANT, M ) :-
etat_ordi(ETAT),
M == 1,                  %Verification du mode multijoueur
write('Votre tour (J2): (numero de ranger, nombre de batonneés)'),
nl,
read(R),
read(N),
operation( ETAT, prendre(o,R,N), ETAT_SUIVANT ),
write(prendre(o,R,N)),
disp( ETAT_SUIVANT ),
write(ETAT_SUIVANT),
nl,
jeu( ETAT_SUIVANT, GAGNANT, M ).          %Appelle recursif pour passer la main


%Prédicat (jeu) récursif pour le tour du l'ordinateur
jeu( ETAT, GAGNANT, M ):-
etat_ordi(ETAT),
write('Lordinateur joue'),
nl,
choisir_operation( ETAT, R, N ),                %Appelle du predicat choisir_operation pour la IA
operation( ETAT, prendre(o,R,N), ETAT_SUIVANT ),
write(prendre(o,R,N)),
disp( ETAT_SUIVANT ),
write(ETAT_SUIVANT),
nl,
jeu( ETAT_SUIVANT, GAGNANT, M ).      %Appelle recursif pour passer la main



%Choix de l'operation pour le tour de l'ordinateur
choisir_operation( marienbad(A,B,C,D,o), R, N ):-
E is max(max(max(A,B),C),D),      %E : nombre de batonnées max par rangées
(                                 %R : index de la rangé avec le nombre de batonné max
R is 1, nth1(1, [A,B,C,D], E);
R is 2, nth1(2, [A,B,C,D], E);
R is 3, nth1(3, [A,B,C,D], E);
R is 4, nth1(4, [A,B,C,D], E)
),
(
N is E - 1, E>1;                  %On prends le nombre de batonné E - 1
N is E                            %Ou un batonné s'il en reste que un
).

%Prédicat de lancement du jeu
start :-
write('Selctionner "1." Joueur Vs Joueur '), nl,
write('Selctionner "2." Joueur Vs Ordinateur '), nl,
read(M),
(M == 1 ; M == 2),
etat_initial( E ),
disp( E ),
jeu(E,GAGNANT, M).        %Demarrage du jeu






