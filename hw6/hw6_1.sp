sorts
% Note: I've added a few other childrens books and authors to test with.
#childrens_book = {strange_happenings, the_giving_tree, the_lorax, poppy}.
#author = {avi, seus, silverstein}.
#default = d(#childrens_book).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predicates
written_by(#childrens_book,#author).
ab(#default).
is_creepy(#childrens_book).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rules

written_by(strange_happenings, avi).
written_by(poppy, avi).
written_by(the_giving_tree, silverstein).
written_by(the_lorax, seus).
is_creepy(strange_happenings).
 
%% default d: Childrens books are normally not creepy.
-is_creepy(X) :- not ab(d(X)),
                 not is_creepy(X).
           
%% A childrens book is abnormal with respect to d if it is written by Avi.
ab(d(X)) :- written_by(X, avi). 