function [HuPHI,HuPSI,lat]=grdHdu(u,name,x0,tsar,u_bounds,neq,ctol,varargin)
% GRDHDU  : Function to compute the gradient dH/du for constr.m to solve
%           a Digital OPTimal control with Fixed TF and bounded control
%
%           [HuPHI,HuPSI]=grdHdu(u,name,x0,tsar,tol,u_bounds)
%
% Notes : - Each iteration the cost J and the average control change dua are displayed.
%         - Every iteration the best control is saved in utemp.mat.
%         - To interrupt the routine edit the number in the breakdop.txt file,
%           generated by this function, into non-zero. Using ctrl-break or ctrl-c
%           results in problems.
%
%         Input
%         u         : (m x ni) vector of initial controls
%         name	    : name of the model-file (m-file)
%         x0        : (n x 1) state at time t=0
%         tsar      : array with sampling instants and final time
%         tol       : Termination if J(previous)-J(next) < tol
%
%         Output
%         HuPHI     : dHPHI/du
%         HuPSI     : dHPSI/du
%
%         See also : lineglob.m, lineeval.m
%
%         GvW/CH Last modified : 4-6-2001

% Check inputs
if nargin<4; error(' At least 4 input arguments required'); end
[m,N]=size(u); N1=N+1; [n,mh]=size(x0); if mh~=1; error('1st input must be a column vector'); end;
if ~isstr(name); error('2nd argument must be a string'); end
if length(tsar)~=N1; error('size control and sampling instants array do not match'); end;
[mh,nh]=size(x0); if nh~=1; error('3rd input must be a column vector'); end;
if nargin==5
  [mb,nh]=size(u_bounds);
  if mb~=0;
    if mb~=m || nh~=2; error('5th input is not m x 2'); end;
    if any(u_bounds(:,2)-u_bounds(:,1))<0; error(' Lower control bound exceeds upper control bound'); end;
  end
else
  mb=0;
end

% definition of the bounds

umin=u_bounds(:,1); umax=u_bounds(:,2);
ns=length(x0); [nc,N]=size(u); N1=N+1; dum=zeros(nc,1);

x=zeros(ns,N1); la=zeros(ns,1); Hu=zeros(nc,N); x(:,1)=x0;
% Forward sequencing and store x(:,i):
for i=1:N,  
  x(:,i+1)=feval(name,u(:,i),x(:,i),tsar(i),tsar(i+1)-tsar(i),1,varargin{:});
end
% Perf. index, term. constraints, & B.C.s for bkwd sequences:
[PHIPSI,dPHIPSI]=feval(name,dum,x(:,N1),tsar(N1),1,2,varargin{:});
[PSIT,dPSIT]=feval(name,dum,x(:,i),tsar(i),1,7,varargin{:});
[np,mp]=size(PHIPSI); [nt,mt]=size(PSIT); Hu=zeros(nc*N,np+nt*N);
J=PHIPSI(1); la=dPHIPSI'; ind2=nc*N; ind1=ind2-nc+1; la1=[]; lat=la(:,1);

% Backward sequencing and store Huphi(:,i):
  for i=N:-1:1,
    if nt>0; [PSIT,dPSIT]=feval(name,dum,x(:,i+1),tsar(i+1),1,7,varargin{:}); la1=[dPSIT' la1]; end;
    [fx,fu]=feval(name,u(:,i),x(:,i),tsar(i),tsar(i+1)-tsar(i),3,varargin{:}); %call to dlinfxu
    Hu(ind1:ind2,1:np)=fu'*la; la=fx'*la; lat=[la(:,1) lat];
    if nt>0; Hu(ind1:ind2,np+1:np+nt*N)=[zeros(nc,(i-1)*nt) fu'*la1]; la1=fx'*la1; end
    ind1=ind1-nc; ind2=ind2-nc;
%   DO NOT!! Set gradient to zero at points where the control is at the bound
%   because constr.m takes care of this!
  end
  HuPHI=Hu(:,1); HuPSI=Hu(:,2:end);