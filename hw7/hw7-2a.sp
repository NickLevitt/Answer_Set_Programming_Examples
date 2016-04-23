% Nick Levitt
% Homework 7 - 2a.

#const n = 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sorts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#inertial_fluent = {f,g}.

#defined_fluent = {h}.

#fluent = #inertial_fluent + #defined_fluent.
          
#action = {a}.

#step = 0..n.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(#fluent,#step).
occurs(#action,#step).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(f, I+1) :- holds(g,I),
                         occurs(a,I).
                         
holds(h, I):- holds(g,I),
              holds(f,I).

%% CWA for Defined Fluents
-holds(F,I) :- #defined_fluent(F),
               not holds(F,I).

%% General Inertia Axiom

holds(F,I+1) :- #inertial_fluent(F),
                holds(F,I),
                not -holds(F,I+1).

-holds(F,I+1) :- #inertial_fluent(F),
                 -holds(F,I),
                 not holds(F,I+1).
                 
%% CWA for Actions

-occurs(A,I) :- not occurs(A,I).

% Starting state for testing.
-holds(f,0).
holds(g,0).
occurs(a,0).

