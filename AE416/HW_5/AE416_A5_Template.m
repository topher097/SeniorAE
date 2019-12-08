%P. Ansell
%AE 416
%Fall 2019
%Assignment 5 Template

%Input constants and conditions
b=[];               %Span (ft)
V=[];               %Cruise airspeed (ft/s)
N=[];               %Number of shed vortex elements
S=[];               %Wing area (ft**2)
c0=[];              %Root chord (ft)
alpha=[]*pi/180;    %alpha_g - alpha_ZL (radians)

%Define shedding locations (note, final shedding locations taken small
%distance from the tips to avoid singularities)
yv=linspace(-b/2+1e-6,b/2-1e-6,N);

%Initialize control point locations
yc=zeros(1,N-1);

%Solve for spanwise location of control points here
yc=[];

%Calculate chord distribution
c=[];

%Initialize A and b matrices
b=zeros(N,1);
A=zeros(N,N);

%Solve for b array across N-1 control points (see Lecture 36)
for i=1:N-1
    %Calculate b(i) here
    b(i)=[];
end

%Define final element of b array (see Lecture 36)
	%Provide b(N) here

%Fill in N-1 x N elements of A matrix (see Lecture 36)
for i=1:N-1
    for j=1:N
        %Calculate A(i,j) here
        A(i,j)=[];
    end
end

%Fill in final equation of A matrix (N x 1)
A(N,:)=[];

%Calculate circulation shedding strengths from linear system
x=inv(A)*b;

%Initialize downwash and bound circulation distributions
w=zeros(1,N-1);
G=zeros(1,N-1);

%Solve for w and Gamma at each control point
for i=1:N-1
    for j=1:N
        %Calculate w
        w(i)=[];
    end
    %Calculate Gamma
    G(i)=[];
end

%Initialize and solve for CL and CD, given w and Gamma distributions
CL=0;
CDi=0;
for i=1:N-1
    %Calculate CL and CD
    CL=[];
    CDi=[];
end

%Calculate L/D
LDi=CL/CDi;

%Plot results
plot(yc,w)
xlabel('y (ft)')
ylabel('w (ft/s)')
