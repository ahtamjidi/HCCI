function [output] = fiedler_value(Adj_mat)
%Calculates fiedler value for an adjacency matrix

no_nodes = size(Adj_mat,1);

if Adj_mat(1,1) ~=0
    Adj_mat = Adj_mat - eye(no_nodes); %removing self loops to calculate laplacian
end

G = graph(Adj_mat);
L = laplacian(G);
eig_vals = eig(L);

eig_vals = sort(eig_vals); 

output = eig_vals(2);
end

