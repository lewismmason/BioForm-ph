x = [1;2;3;4;5];
y = [1;2;3;4;5];
z = [1;2;3;4;5];


% plt = surf(Z);

dt = delaunayTriangulation(x,y) ;
tri = dt.ConnectivityList ;
xi = dt.Points(:,1) ; yi = dt.Points(:,2) ;
F = scatteredInterpolant(x,y,z);
zi = F(xi,yi) ;
trisurf(tri,xi,yi,zi)