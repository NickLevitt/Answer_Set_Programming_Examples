%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sorts

#class = {selmer, saxophone, part, key, spring}.
#object = {jake, mo, d, jake_spring, mo_spring}.
#default1 = d1(#object).
#default2 = d2(#object).
#default = #default1 + #default2. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predicates

is_subclass(#class,#class).
subclass(#class,#class).
is_a(#object,#class).
member(#object,#class).
siblings(#class,#class).
ab(#default).
broken(#object).
working(#object).
part_of(#object,#object).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rules

is_subclass(selmer,saxophone).
is_subclass(key,part).
is_subclass(spring,part).

%% Class C1 is a subclass of class C2 if C1 is a subclass of C2 or
%% if C1 is a subclass of C3 which is a subclass of C2.
subclass(C1,C2) :- is_subclass(C1,C2).
subclass(C1,C2) :- is_subclass(C1,C3),
                   subclass(C3,C2).

is_a(jake,selmer).
is_a(mo,selmer).
is_a(d,key).
is_a(jake_spring,spring).
is_a(mo_spring,spring).

part_of(mo_spring,mo).
part_of(jake_spring,jake).

broken(mo_spring).

%% Object X is a member of class C if X is a C or if X is a C0
%% and C0 is a subclass of C.
member(X,C) :- is_a(X,C).
member(X,C) :- is_a(X,C0),
               subclass(C0,C).
 
%% Sibling classes are disjoint unless we are specifically told otherwise.
siblings(C1,C2) :- is_subclass(C1,C),
                   is_subclass(C2,C),
                   C1 != C2.
-member(X,C2) :- member(X,C1),
                 siblings(C1,C2),
                 C1 != C2,
                 not member(X,C2). 
                 
%% default d1: Springs are not normally broken.
-broken(X) :- member(X,spring),
           not ab(d1(X)),
           not broken(X).
           
broken(X) :- member(X,saxophone),
           not working(X).
           
working(X) :- member(X,saxophone),
              part_of(Y,X),
              -broken(Y).
           
%% X is abnormal with respect to d1 if X is broken and might be a spring.
ab(d1(X)) :- not -member(X,spring),
             broken(X).
             

             
        


