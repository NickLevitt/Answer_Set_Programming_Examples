% Nick Levitt
% HW 8 - 9.3


#const n = 2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sorts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#block = [b][0..7].
#color = {white, red}.

#location = #block + {t}.

#inertial_fluent = on(#block(X),#location(Y)):X!=Y.

#defined_fluent = above(#block(X),#location(Y)):X!=Y + occupied(#block)  + wrong_config(#block) + {wrong_set}. 

#fluent = #inertial_fluent + #defined_fluent.
          
#action = put(#block(X),#location(Y)):X!=Y.

#step = 0..n.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(#fluent,#step).
occurs(#action,#step).
success().
goal(#step).
something_happened(#step).
is_color(#block, #color).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Laws %%

%% Putting block B on location L at step I
%% causes B to be on L at step I+1:
%% put(B,L) causes on(B,L)
holds(on(B,L),I+1) :- occurs(put(B,L),I).

%% A block cannot be in two locations at once:
%% -on(B,L2) if on(B,L1), L1 != L2
-holds(on(B,L2),I) :- holds(on(B,L1),I), 
                      L1 != L2.

%% Only one block can be set directly on top of another:
%% -on(B2,B) if on(B1,B), B1 != B2
-holds(on(B2,B),I) :- #block(B), 
                      holds(on(B1,B),I),
                      B1 != B2.

%% B is above L if it is directly on top of it or on top of 
%% another block that is above L:
%% above(B,L) if on (B,L)
%% above(B,L) if on(B,B1), above(B1,L)
holds(above(B2,B1),I) :- holds(on(B2,B1),I).

holds(above(B2,B1),I) :- holds(on(B2,B),I),
                         holds(above(B,B1),I).
                  
%% It is impossible to move an occupied block:       
%% impossible put(B,L) if on (B1,B)
-occurs(put(B,L),I) :- holds(on(B1,B),I).

%% It is impossible to move a block onto an occupied block:
%% impossible put(B1,B) if on(B2,B).
-occurs(put(B1,B),I) :- #block(B),
                        holds(on(B2,B),I).

% Block B is occupied if there is a block on top of it
holds(occupied(B),I) :- #block(B),
                        holds(on(B1,B),I).
                        
% A block can only be one color
-is_color(B,C) :-  #block(B),
                    is_color(B,C1),
                    C != C1.
                    
% The configuration is wrong if there is an unoccupied block that is not red         
holds(wrong_config(B),I) :- #block(B),
                            -holds(occupied(B),I),
                            -is_color(B,red).
                            
holds(wrong_set, I) :- holds(wrong_config(B),I).
                            
                            
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
                
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
%% Simple Planning Module using Disjunctive Rule:   
  
success :- goal(I).
:- not success.

occurs(A,I) | -occurs(A,I) :- not goal(I).
                              
%% Do not allow concurrent actions:
:- occurs(A1,I),
   occurs(A2,I),
   A1 != A2.

%% An action occurs at each step before
%% the goal is achieved:

something_happened(I) :- occurs(A,I).

:- goal(I), goal(I-1),
   J < I,
   not something_happened(J).
                                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Specific initial situation.
%% Change at will:

%% holds(on(B,L),I): a block B is on location L at step I.
holds(on(b0,t),0).   
holds(on(b1,t),0).
holds(on(b2,b1),0).
holds(on(b3,b2),0).
holds(on(b4,t),0).
holds(on(b5,b4),0).
holds(on(b6,b5),0).
holds(on(b7,b6),0).   

is_color(b0, red).
is_color(b1, red).
is_color(b2, white).
is_color(b3, red).
is_color(b4, red).
is_color(b5, red).
is_color(b6, white).
is_color(b7, white).


%% If block B is not known to be on location L at step 0,
%% then we assume it is not.
-holds(on(B,L),0) :- not holds(on(B,L),0). 
                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Specific goal. 

goal(I) :- -holds(wrong_set,I).  


                     
            