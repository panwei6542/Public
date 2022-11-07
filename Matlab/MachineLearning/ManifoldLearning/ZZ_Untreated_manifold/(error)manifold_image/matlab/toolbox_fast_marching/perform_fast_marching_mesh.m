function [D,S,Q] = perform_fast_marching_mesh(vertex, faces, start_points, options)

% perform_fast_marching_mesh - launch the Fast Marching algorithm on a 3D mesh.
%
%   [D,S,Q] = perform_fast_marching_mesh(vertex, faces, start_points, options)
%
%   vertex, faces: a 3D mesh
%   start_points(i) is the index of the ith starting point .
%
%   D is the distance function to the set of starting points.
%   S is the final state of the points : -1 for dead (ie the distance
%       has been computed), 0 for open (ie the distance is only a temporary
%       value), 1 for far (ie point not already computed). Distance function
%       for far points is Inf.
%   Q is the index of the closest point. Q is set to 0 for far points.
%       Q provide a Voronoi decomposition of the domain. 
%
%   Optional:
%   - You can provide non-uniform speed in options.W.
%   - You can provide special conditions for stop in options :
%       'options.end_points' : stop when these points are reached
%       'options.nb_iter_max' : stop when a given number of iterations is
%          reached.
%   - You can provide an heuristic in options.heuristic (typically that try to guess the distance
%       that remains from a given node to a given target).
%       This is an array of same size as W.
%   - You can provide a map L=options.constraint_map that reduce the set of
%       explored points. Only points with current distance smaller than L
%       will be expanded. Set some entries of L to -Inf to avoid any
%       exploration of these points.
%
%   Copyright (c) 2004-2006 Gabriel Peyr?


options.null = 0;
nverts = max(size(vertex));

if isfield(options,'end_points')
    end_points = options.end_points;
else
    end_points = [];
end

if isfield(options,'verbose')
    verbose = options.verbose;
else
    verbose = 1;
end

if isfield(options,'nb_iter_max')
    nb_iter_max = options.nb_iter_max;
else
    nb_iter_max = Inf;
end
if isfield(options,'W')
    W = options.W;
else
    W = ones(nverts,1);
end

if isfield(options,'constraint_map')
    L = options.constraint_map;
else
    L = [];
end
I = find(L==-Inf); L(I)=-1e9;
I = find(L==Inf); L(I)=1e9;

if isfield(options,'heuristic')
    H = options.heuristic;
else
	H = [];
end

nb_iter_max = min(nb_iter_max, 1.2*max(size(W)));



if size(vertex,1)>size(vertex,2)
    vertex = vertex';
end
if size(faces,1)>size(faces,2)
    faces = faces';
end
start_points = start_points(:);
end_points = end_points(:);


% use fast C-coded version if possible
if exist('perform_front_propagation_2d')~=0
    [D,S,Q] = perform_front_propagation_mesh(vertex, faces-1, W,start_points-1,end_points-1, nb_iter_max, H, L);
    Q = Q+1;
else
    error('You have to run compiler_mex before.');
end


% replace C 'Inf' value (1e9) by Matlab Inf value.
I = find( D>1e8 );
D(I) = Inf;
