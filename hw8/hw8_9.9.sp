% Nick Levitt
% HW 8 - 9.3


#const n = 3.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sorts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#activity = {assigned_hw, make_bed, tkd, wii}.

#inertial_fluent = done(#activity).

#fluent = #inertial_fluent.

#action = do(#activity).

#step = 0..n.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(#fluent,#step).
occurs(#action,#step).
success().
goal(#step).
something_happened(#step).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Laws %%
% Jonathon will play wii if he has done his assigned hw, made his bed, and done tkd.
occurs(do(wii), I) :-   holds(done(assigned_hw), I),
                        holds(done(make_bed), I),
                        holds(done(tkd), I).
               
%Jonathon's hw is done at I+1 if he does it at I
holds(done(assigned_hw), I+1) :- occurs(do(assigned_hw), I).
            
% Jonathon's bed is made at I+1 if he makes it at I
holds(done(make_bed),I+1) :- occurs(do(make_bed),I).

%Jonathon has practiced tkd at I+1 if he went to tkd at I
holds(done(tkd),I+1) :- occurs(do(tkd),I).
                            
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
-holds(done(assigned_hw), 0).
-holds(done(make_bed), 0).
-holds(done(tkd), 0).
-holds(done(wii),0).
                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Specific goal. 

goal(I) :- occurs(do(wii), I).
                     