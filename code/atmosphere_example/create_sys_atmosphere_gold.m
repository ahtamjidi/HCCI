function [Ar,x0,Br,Cr,Trt] = create_sys_atmosphere_gold(reduced_system_dim,n_receptors)
if(nargin==0) 
    reduced_system_dim = 80;
end   
        
%Source and receptors are not on the boundaries (except z = 0)
%10^5 system, Full State Measurements
global opt_dist
%%
%SET PARAMETERS : Parameters can be changed
%Computational domain
xlim                            =   [ 0, 2000];  %[600m - 3000m]
ylim                            =   [-100, 400];
zlim                            =   [0, 50];
%Wind Profile parameters
Uwind                           =   4;    % wind speed (m/s) between 1-5 (m/s)
alp                             =   0/180 * pi;
beta                            =   0/180 * pi;
%Diffusion parameters
ay                              =   0.08*0.1;
by                              =   0.0001*0.1;
az                              =   0.06*0.1;
bz                              =   0.0015*0.1;
%discretization dimension
nx                              =   10;
ny                              =   10;
nz                              =   10;
dt                              =   1;

%%
%U = (U cos(alp)cos(beta), U cos(alpha) sin(beta), U sin(alp));
Ux = Uwind * cos(alp)*cos(beta); %Components of wind in x,y,z directions. 
Uy = Uwind * cos(alp)*sin(beta);
Uz = Uwind * sin(alp);

%Finite difference Scheme parameters
dx =( xlim(2) - xlim(1))/nx;
dy = (ylim(2) - ylim(1))/ny;
dz = (zlim(2) - zlim(1))/nz;

%creation of 3D grid points
x0 = xlim(1) + [0 : nx]*dx;           % distance along wind direction (m)
y0 = ylim(1) + [0 : ny]*dy;           % cross-wind distance (m)
z0 = zlim(1) + [0 : nz]*dz;
[xmesh, ymesh] = meshgrid(x0,y0);

Ky = zeros(nx+1,1); %??
Kz = zeros(nx+1, 1);
for i = 1 : nx+1
    Ky(i,1) = Uwind * ay^2/2 * (2 * x0(i) + by *(x0(i))^2)/(1+by*x0(i))^2;
    Kz(i,1) = Uwind * az^2/2 * (2 * x0(i) + bz *(x0(i))^2)/(1+bz*x0(i))^2;
end

sy = Ky * dt/(dy^2); %??
sz = Kz * dt/(dz^2);
cx = Ux * dt/dx;
cy = Uy * dt/(dy);
cz = Uz * dt/(dz);

NUM_SYS = (ny-1)*(nx-1)*(nz); %??

%Primal system
[SR, S, SC] = atmo3dlax2 (Uwind, alp, beta, nx, ny, nz, xlim, ylim, zlim, Ky, Kz, dt); %atmosphere model. 

% size(SR) %1x5148
% size(S)  %1x5148
% size(SC) %1x5148

%Adjoint system : Sad = S;
SRad = SC;
SCad = SR;
%%

%Source and receptor locations and discretization
% Stack emission source data:
source.n = 10;                         % # of sources
source.x = [280, 300, 900, 1100, 500,1300,500,1700,1400,700];     % x-location (m)
source.y = [ 75, 205, 25,  185,  250,230, 330,170, 240, 200];     % y-location (m)
source.z = [ 15,  35,  15,   15, 10, 10, 10, 10, 15, 20];     % height (m)
%source.label=['S1'; ' S2'; ' S3'; ' S4'; 'S5';'S6';'S7';'S8';'S9';'S10'];

tpy2kgps = 1.0 / 31536;               % conversion factor (tonne/yr to kg/s)
source.Q = 1.5*[35, 80, 100, 50, 80, 50, 85, 100, 5, 110] * tpy2kgps ; % emission rate (kg/s)
%source.Q = 1;

% Stack discrete source data: Transfer from continuous to discrete
dissource.n = source.n;
dissource.x = floor((source.x - xlim(1))/dx)+1;
dissource.y = floor((source.y - ylim(1))/dy)+1;
dissource.z = floor((source.z - zlim(1))/dz)+1;
%%
%USE IF NUM_SYS IS SMALL.

%disp('NUM_SYS:'); disp(NUM_SYS); %810
%disp('SR:'); disp(SR);
%disp('SC:'); disp(SC);
%disp('S:'); disp(S);

A = sparse(NUM_SYS, NUM_SYS); 
for i = 1 : length(S)
    A(SR(i), SC(i)) = S(i);
end
%Receptors
recept.n = n_receptors;   % 9 change  % # of receptors
%{
recept.x = [  60,  76, 267, 331, 514, 904, 1288, 1254, 972 ]; % x location (m)
recept.y = [ 130,  70, -21, 308, 182,  75,  116,  383, 507 ]; % y location (m)
recept.z = [   0,  10,  10,   1,  15,   2,    3,   12,  12 ]; % height (m)
recept.label=[ ' R1 '; ' R2 '; ' R3 '; ' R4 '; ' R5 '; ' R6 '; ...
    ' R7 '; ' R8 '; ' R9 ' ];
%}
recept.x = [  60,  76, 267, 331, 514, 904, 1288, 1254, 972, randsample(xlim(1)+11 : xlim(2)-11,recept.n-9)]; %randsample to avoid repetition
recept.y = [ 130,  70, -21, 308, 182,  75,  116,  383, 507, randi(ylim + [11, -11],1,recept.n-9)];
recept.z = [   0,  10,  10,   1,  15,   2,    3,   12,  12, randi(zlim + [11, -11],1,recept.n-9)];
recept.label = strings(1,recept.n);
for i=1:recept.n
    recept.label(i) = ['R', num2str(i)]; 
end

disrecept.x = floor((recept.x - xlim(1))/dx)+1;
disrecept.y = floor((recept.y - ylim(1))/dy)+1;
disrecept.z = floor((recept.z - zlim(1))/dz)+1;


NUM_OUT                 = recept.n;
NUM_IN                  = source.n;

B = sparse(NUM_SYS, source.n);
for ns = 1 : source.n
    B((nx-1)*(ny-1)*(dissource.z(1,ns)-1)+(nx-1)*(dissource.y(1,ns)-2)+dissource.x(1,ns)-1, ns) = 1;
end

Ft = (1 - (source.x - x0(dissource.x))/dx).*(1 -(source.y - y0(dissource.y))/dy) .* (1- (source.z - z0(dissource.z))/dz) .* source.Q *dt/(dx*dy*dz);

C = sparse(recept.n, NUM_SYS);  

for ns = 1 : recept.n
    C(ns,(nx-1)*(ny-1) * (disrecept.z(1,ns)-1) + (nx-1) * (disrecept.y(1,ns) -2) + disrecept.x(1,ns)-1) = 1;
end

%{
for ns = 1 : recept.n
    C(ns,:) = ones(1,size(C,2)); %TODO commented above
end
%}

%{ %redundant
source.n = 10;                         % # of sources
source.x = [280, 300, 900, 1100, 500,1300,500,1700,1400,700];     % x-location (m)
source.y = [ 75, 205, 25,  185,  250,230, 330,170, 240, 200];     % y-location (m)
source.z = [ 15,  35,  15,   15, 10, 10, 10, 10, 15, 20]; % height (m)
%}
source.label=[' S1'; ' S2'; ' S3'; ' S4'; ' S5';' S6';' S7';' S8';' S9';'S10'];

opt_dist.recept = recept;
opt_dist.source = source;

%{
%plot receptor and source locations.
fig = figure;
plot(source.x,source.y,'o','MarkerFaceColor', 'g')
text(source.x,source.y,source.label,'VerticalAlignment','bottom','HorizontalAlignment','right')
hold on
plot(recept.x,recept.y,'x','Color','k')
text(recept.x,recept.y,recept.label,'VerticalAlignment','bottom','HorizontalAlignment','right')
uiwait(fig)
%}

TIME_STEP = 10;
NUM_ROUND = 401; %??

Xt = zeros(NUM_SYS, 1);
for iall = 1 : NUM_ROUND
    X = zeros(NUM_SYS,TIME_STEP);
    X(:,1) = Xt;
    for k= 1 : TIME_STEP - 1
        for i = 1  : length(SR)
            X(SR(i),k+1) = X(SR(i),k+1)+S(i)*X(SC(i),k);
        end
        X(:,k+1) = X(:,k+1) + B*randn(NUM_IN,1);
    end
    Xt = X(:,end);
    Xs(:, iall) = X(:,end); %Pick (X(TIME_STEP, 2*TIME_STEP,..., NUM_ROUND*TIME_STEP))
end

Yt = zeros(NUM_SYS, 1);
for iall = 1 : NUM_ROUND
    Y = zeros(NUM_SYS,TIME_STEP);
    Y(:,1) = Yt;
    for k= 1 : TIME_STEP - 1
        for i = 1  : length(SC)
            Y(SC(i),k+1) = Y(SC(i),k+1)+S(i)*Y(SR(i),k);
            
        end
        %Y(:,k+1) = Y(:,k+1) + F(:, TIME_STEP*(iall-1)+k);
        Y(:,k+1) = Y(:,k+1) + (randn(NUM_SYS,1));
    end
    Yt = Y(:,end);
    Ys(:, iall) = Y(:,end);
end
clear Xt Yt X Y
Xp = Xs(:, 1:end);
Yp = Ys(:, 1:end);
Ht =Yp' * Xp;
%%
[Ut, St, Vt] = svd(Ht); %singular value decomposition
%disp('St');
diag_St = zeros(size(St,1),1);

for i=1:size(St,1) 
    
    %disp('i='); disp(i);
    diag_St(i) = St(i,i);  
    
end
%{
figure(1) %plotting singular values
i=1:10;
plot(i,diag_St(1:10),'Linewidth',4)
%}
NUM_NON = reduced_system_dim;
Unt = Ut(:, 1:NUM_NON);
Snt = St(1:NUM_NON, 1:NUM_NON);
Vnt = Vt(:,1:NUM_NON);

%{
disp('Ut'); disp(size(Ut)); %401x401
disp('St'); disp(size(St)); %401x401
disp('Vt'); disp(size(Vt)); %401x401
disp('Ht'); disp(size(Ht)); %401x401
%}

Trt= Xp* Vnt* Snt^(-1/2);
Tlt = Snt^(-1/2) * Unt' * Yp';

Temp = zeros(NUM_SYS,NUM_NON);
for j = 1 : NUM_NON
    for i = 1 : length(SR)
        Temp (SR(i), j) = Temp (SR(i),j) + S(i) * Trt(SC(i),j);
    end
end

At=  Tlt*Temp;
Bt = Tlt * B;
Ct = C * Trt;

opt_dist.A = At;
opt_dist.B = Bt;
opt_dist.C = Ct;
Ar = At;
Br = Bt;
Cr = Ct;

% Run the system for some time to get a non zero initial condition
% Let the polluters pollute :)
x0 = zeros(size(Ar,1),1);
for i=1:10
    x0 =Ar*x0 + Br*source.Q';
end

