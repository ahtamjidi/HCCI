%Matlab Kalman Filter
reduced_dimention_size = 40;
n_recept = 15;
[A,x0,B,C] = create_sys_gold(reduced_dimention_size,n_recept,10);

sys = ss(A,[B eye(reduced_dimention_size)],C,0,1);

q_var = 10^(-6);
r_var = 5*10^(-5);
Q = q_var*eye(size(B,2));
R = r_var*eye(size(C,1));

tpy2kgps = 1.0 / 31536;               % conversion factor (tonne/yr to kg/s)
u = 1.5*[35, 80, 100, 50, 80, 50, 85, 100, 5, 110] * tpy2kgps ; % emission rate (kg/s)
x_current = x0
x_next = A*x_current + B*u';

[kalmf,L,P,M] = kalman(sys,Q,R)