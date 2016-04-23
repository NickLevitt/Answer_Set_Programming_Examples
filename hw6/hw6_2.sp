% Note: Obviously,this program will return no answer set if the graph in question
% is connected in such a way that a set of vertices all have more than two edges to/from them.
% To make this work, You would have to add additonal colors to the color sort 
% and update the rule at line 41, which the program is designed to allow.

sorts
#vertex = {a, b, c, d, e}.
#color = {green, purple, gold}.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predicates

edge(#vertex, #vertex). 
has_color(#vertex, #color).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rules

% edge(X,Y) -- There is an edge from vertex X to vertex Y.
% If an edge isn't listed, it doesn't exist.
% Edges are undirected.
edge(a,b).
edge(b,c).
edge(c,d).
edge(d,a).
edge(a,a).
edge(a,e).


-edge(X,Y) :- not edge(X,Y).

edge(X,Y) :- edge(Y,X).

% I specify a color for the starting vertex so the program has something to go off of,
% otherwise, there would be no way to start assigning the colors.
%has_color(a, green).

% A vertex must have a color
has_color(X, green) | has_color(X, gold) | has_color(X, purple).

% A vertex can not have more than one color.
-has_color(X,C1) :- has_color(X,C2),
                    C1 != C2.
                    
% A vertex can not have the same color as a vertex it has an edge with, unless it is a loop edge 
-has_color(X,C) :- edge(X,Y),
                    X != Y,
                    has_color(Y,C).
                       
                       
                       