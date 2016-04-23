% Nick Levitt
% Homework 7 -5a & 5c

%5a.) 
%   moving person causes person location change
%   moving person causes object location change if object carried by person
%   impossible person located at L1 and person located at L2 at time T.


#const n = 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sorts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#object = {claire_phone, rod_towel}.
#person = {claire, rod}.
#place = {home, library, school}.
#thing = #person + #object.

#inertial_fluent = carried(#object, #person) + located(#thing, #place).

% Note: there appear to be no defined fluents in this situation, so I will 
%   leave them out in the sorts.

#fluent = #inertial_fluent.
          
#action = moves(#person, #place).

#step = 0..n.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(#fluent,#step).
occurs(#action,#step).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Person P is in location L at I+1 if they move there at I
holds(located(P, L), I+1) :- occurs(moves(P, L), I).

% Person P is no longer in location L at I+1 if they moved from there at I
-holds(located(P,L), I+1) :- occurs(moves(P, L1), I),
                             L != L1.
% An object is located wherever the person carrying it is located
holds(located(O,L), I) :- holds(located(P,L), I),
                          holds(carried(O,P), I).
                          
% An object is no longer where it was if the person carrying it moves                          
-holds(located(O,L), I+1) :- holds(located(O,L), I),
                             occurs(moves(P, L1), I),
                             holds(carried(O,P), I),
                             L != L1.
% An object is not at location L if the person carrying it is not at location L                            
-holds(located(O,L), I) :- holds(carried(O,P),I),
                           -holds(located(P,L),I).

% Rod and Claire are never in the same location simultaneously.                         
-holds(located(rod,L),I) :- holds(located(claire, L),I).




%% General Inertia Axiom

holds(F,I+1) :- #inertial_fluent(F),
                holds(F,I),
                not -holds(F,I+1).

-holds(F,I+1) :- #inertial_fluent(F),
                 -holds(F,I),
                 not holds(F,I+1).
                 
%% CWA for Actions

-occurs(A,I) :- not occurs(A,I).

% Situation for testing
holds(located(claire, library), 0).
holds(carried(claire_phone, claire),0).
holds(carried(rod_towel, rod),0).
occurs(moves(claire,home),0).
holds(located(rod,library),1).
