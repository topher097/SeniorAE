clc;
clear all;
close all;
%% AE410 Midterm 1 - Coding
% Due March 30, 2020 @ 11:59pm
% Author: Christopher Endres
% Supplementary script: integrator.m

% Eq (1): d(rho)/d(t) + d(rho*u)/d(x) = 0 
% Eq (5): d(rho*u)/d(t) + d(rho*u^2 + K*rho^g)/d(x) = 0 
% where:
%   rho     = density (kg/m^3)
%   p       = pressure (pascal)
%   g       = gamma
%   K       = p_ref/(rho_ref^g)
%   p_ref   = total pressure (pascal)
%   rho_ref = total density (kg/m^3)

%% Problem 1
% Develop a finite-difference code to solve equations (1) and (5) on a
% finite domain x in [0,1]. The x=0 boundary models a solid wall (u(0,t)=0)
% and the right boundary is non-relfecting. Using the initial condition
% u(x,0)=0, rho(x,0)=rho_ref(1+alpha*exp(-(x-0.5)^2/0.1^2)), write your
% code to generate a movie over time of u(x,t) and rho(x,t) for values of
% alpha=0.25, 0.50, 1.00. Use the values rho_ref=1.225 kg/m^3,
% p_ref=101325 Pa, and g=1.4. Use 101 points in the x-direction, and save
% you code's output at time intervalse of delta(t)=1x10^-4 seconds.

% Define spacial and temporal domains
PeriodicFlag    = 0;
L               = 1;
Nx              = 101;
T               = 0.01;
dt              = 0.0001; 
Nt              = (T/dt) + 1;

if (PeriodicFlag == 0)
    dx = L/Nx;
else
    dx = L/(Nx-1);
end

x = dx*linspace(0, Nx-1, Nx).';
t0 = dt*linspace(0, Nt-1, Nt);

% Define the initial conditions
alpha     = 0.25;       % Iterated: 0.25, 0.50, 1.00  
p_ref     = 101325;     % Pascals
rho_ref   = 1.225;      % kg/m^3
g         = 1.4;
u0        = zeros([Nx 1]);
r0        = rho_ref*(1+alpha*exp(-(x-0.5).^2/0.1^2));
p0        = p_ref * ones([Nx 1]);
q0        = [r0; u0; p0];    
K         = p_ref/(rho_ref^g);

% Construct operator matrix
Dc = sparse(Central5(Nx, dx));    % Central 5
Du = sparse(Biased4(Nx, dx));     % Biased 5 

% Run the solver
options = odeset('AbsTol',1e-10);
disp('Running Central Scheme...');
[t,uc] = ode45(@(t,y) EulerODEM(t,y,g,K,Dc), t0, q0);%, options);
disp('Running Biased Scheme...');
[t,ub] = ode45(@(t,y) EulerODEM(t,y,g,K,Du), t0, q0);%, options);

rho_c = []; uc_c = []; p_c = []; c_c = []; M_c = []; pt_c = [];
rho_b = []; ub_b = []; p_b = []; c_b = []; M_b = []; pt_b = [];

% Extract solutions from solver
for n = 1:1:Nt
    % Central
    rhoc = uc(n,1:Nx);
    ucc = uc(n,(Nx+1):(2*Nx));
    pc = uc(n,(2*Nx+1):(3*Nx));
    cc = sqrt(g*pc./rhoc);
    Mc = abs(ucc)./cc;
    ptc = pc .* (1+(g-1)/2*Mc.*Mc).^(g/(g-1));
    rho_c = [rho_c; rhoc];        % Density (m/s)
    uc_c  = [uc_c; ucc];          % Velocity (m/s)
    p_c   = [p_c; pc];            % Pressure (pascals)
    c_c   = [c_c; cc];            % Speed of sound (m/s)
    M_c   = [M_c; Mc];            % Mach number
    pt_c  = [pt_c; ptc];          % Total Pressure (pascals)
    
    % Biased
    rhob = ub(n,1:Nx);
    ubb = ub(n,(Nx+1):(2*Nx));
    pb = ub(n,(2*Nx+1):(3*Nx));
    cb = sqrt(g*pb./rhob);
    Mb = abs(ubb)./cb;
    ptb = pb .* (1+(g-1)/2*Mb.*Mb).^(g/(g-1));
    rho_b = [rho_b; rhob];        % Density (m/s)
    ub_b  = [ub_b; ubb];          % Velocity (m/s)
    p_b   = [p_b; pb];            % Pressure (pascals)
    c_b   = [c_b; cb];            % Speed of sound (m/s)
    M_b   = [M_b; Mb];            % Mach number
    pt_b  = [pt_b; ptb];          % Total Pressure (pascals)
    

end

% Plot values (Central)
F1 = [];
%processo = zeros(h, w, 3, numberOfFrames);
for i = 1:1:Nt
    figure(1)  
    %imshow(processo(:,:,1,i))
    hold on
    subplot(2,1,1)
    plot(x,uc_c./c_c,'r-s')
    plot(x,p_c/p_ref,'k-d');
    axis([-0.1 1.1 -0.5 1.5]);
    xlabel('x');
    ylabel('\rho/\rho_{ref}, M, p/p_{ref}');
    title('5th Order Central FD');
    subplot(2,1,2)
    plot(x,pt_c/p_ref, 'b-');
    axis([-0.1 1.1 -0.5 1.5]);
    xlabel('x');
    ylabel('p_t/p_{ref}');
    hold off
    F1 = [F1; getframe(gcf)];
    drawnow
end
% create the video writer with 1 fps
writerObj = VideoWriter(sprintf('Central_alpha%0.15g.mp4', alpha));
writerObj.FrameRate = 10; % milliseconds 
% set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(F1)
    % convert the image to a frame
    frame = F1(i) ;    
    writeVideo(writerObj, frame);
end
close(writerObj);

% Plot values (Biased)
F1 = [];
%processo = zeros(h, w, 3, numberOfFrames);
for i = 1:1:Nt
    figure(10)  
    %imshow(processo(:,:,1,i))
    hold on
    subplot(2,1,1)
    plot(x,ub_b./c_b,'r-s')
    plot(x,p_b/p_ref,'k-d');
    axis([-0.1 1.1 -0.5 1.5]);
    xlabel('x');
    ylabel('\rho/\rho_{ref}, M, p/p_{ref}');
    title('4th Order Biased FD');
    subplot(2,1,2)
    plot(x,pt_b/p_ref, 'b-');
    axis([-0.1 1.1 -0.5 1.5]);
    xlabel('x');
    ylabel('p_t/p_{ref}');
    hold off
    F1 = [F1; getframe(gcf)];
    drawnow
end
% create the video writer with 1 fps
writerObj = VideoWriter(sprintf('Biased_alpha%0.15g.mp4', alpha));
writerObj.FrameRate = 10; % milliseconds 
% set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(F1)
    % convert the image to a frame
    frame = F1(i) ;    
    writeVideo(writerObj, frame);
end
close(writerObj);



%% Eigenvalues and Eigenvectors
% Compute the numerical eigenvalues
syms g r k u
A = [u r; g*k/r u];
Gamma = diag(eig(A));      

% Compute analytical eigenvalues/eigenvectors
b = Dc(1,:);
nn = 0:Nx-1;
for n = 1:Nx
    lambda(n) = sum(b.*exp(i*2*pi*nn*(n-1)/Nx));
end
[J,N]=meshgrid(0:Nx-1,0:Nx-1);
X = exp(i*J.*(2*pi*N./Nx));
X_inv = inv(X);
figure(2);
lambda = full(lambda);
for n = 1:2
    for m = 1:2
      jj = (n-1)*2 + m;
      subplot(2,2,jj);
      plot(x,real(X(:,jj)),'b-o',x,imag(X(:,jj)),'k-s');
      title(sprintf('\\lambda = %4.2f + %4.2f i',real(lambda(jj)),imag(lambda(jj))));
    end
end
print('-dpng','EigenvectorSpectrum.png');


%% Euler ODE
function qdot = EulerODEM(t, q, g, K, D)
    % size of domain
    Nx = size(D,1);

    % extract [rho, u, p]
    rho = q(1:Nx);
    u   = q((Nx+1):(2*Nx));
    p   = q((2*Nx+1):(3*Nx));

    % time derivatives
    drhodt = -u .* (D * rho) - rho .* (D * u);
    dudt   = -u .* (D * u) - (D * K * g * p) ./  rho;


    % work on left boundary (constant total Temperature & pressure)
    c2 = g * p(1) / rho(1);
    M2 = u(1)*u(1)/c2;
    X = [rho(1)*(1/sqrt(g*K))   -rho(1)*sqrt(g*K)/(g*K); ...
         1                      1                   ];
    Xinv = inv(X);
   
    dwdt = Xinv * [drhodt(1); dudt(1)];
    if (abs(u(1)) > 1e-10)
        ap   = (1/p(1) - 1/(rho(1)*c2) + (g-1)*M2/(rho(1)*sqrt(c2)*u(1)));
        am   = (1/p(1) - 1/(rho(1)*c2) - (g-1)*M2/(rho(1)*sqrt(c2)*u(1)));
        bp   = (1-M2/2)/p(1) + g*M2/(2*rho(1)*c2) + g*M2/(rho(1)*sqrt(c2)*u(1));
        bm   = (1-M2/2)/p(1) + g*M2/(2*rho(1)*c2) - g*M2/(rho(1)*sqrt(c2)*u(1));
    else
        ap   = (1/p(1) - 1/(rho(1)*c2));
        am   = (1/p(1) - 1/(rho(1)*c2));    
        bp   = (1-M2/2)/p(1) + g*M2/(2*rho(1)*c2);
        bm   = (1-M2/2)/p(1) + g*M2/(2*rho(1)*c2);
    end
    b1        = -(2*rho(1)*(bm*ap-bp*am))/(g*M2*ap+2*bp);

    dwdt(1)   = b1*dwdt(2);
    dqdt      = X * dwdt;
    drhodt(1) = dqdt(1);
    dudt(1)   = dqdt(2);

    % work on right boundary (constant static temp)
    X = [rho(1)*(1/sqrt(g*K))   -rho(1)*sqrt(g*K)/(g*K); ...
         1                      1                   ];

    Xinv = inv(X);
    dwdt = Xinv * [drhodt(Nx); dudt(Nx)];
    dqdt       = X * dwdt;
    drhodt(Nx) = dqdt(1);
    dudt(Nx)   = dqdt(2);
    qdot = [drhodt; dudt(:,1); zeros(Nx,1)];
end
%% Central 5th order
function D = Central5(Nx,dx)
% Periodic domain, returns the D matrix for the derivative from 1a

a=zeros([5 1]);
a(1)=1/12;
a(2)=-2/3;
a(3)=0;
a(4)=2/3;
a(5)=-1/12;

r=[a(3) a(4) a(5) zeros([1 Nx-5]) a(1) a(2) ];
M = zeros(Nx,Nx);
for i=1:Nx
    M(i,:) = r;
    r = circshift(r,1);
end
M = M * (1/dx);
D = M;
return;
end
%% Biased 4th order
function D = Biased4(Nx,dx)
% Periodic domain, calculated the D matrix for the derivative from 1b
a = zeros([4 1]);
a(1) = 1/6;
a(2) = -1;
a(3) = 1/2;
a(4) = 1/3;

r = [a(3) a(4) zeros([1 Nx-4]) a(1) a(2)];
M = zeros(Nx,Nx);
for i=1:Nx
    M(i,:) = r;
    r = circshift(r,1);
end
M = M * (1/dx);
D = M;
return;
end
