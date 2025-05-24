
function [c ceq] = const(x,Lx,Ly,rho,h,h0,d,Lr)

%x(1) LC:longuitud del conductor
%x(2) Dx Space entre conductores en el eje x
%x(3) Dy Space entre conductores en el eje y
%x(4) Rg
%x(5) GPR
%x(6) Em
%x(7) cantidad de varillas
%x(8) Es

%global Ar GPR Km h h0 d rho Lr 


% Restricciones
%% ---------------- Nonlinear inequality constraints ------------------
%c(1)=x(2)-Dx;
%c(2)=x(3)-Dy;
    c=[];
%% ---------------- Nonlinear equality constraints -----------------------
%Step 4. Initial design.
ceq(1)=(Lx/x(2)+1)*Ly+(Ly/x(3)+1)*Lx-x(1); %Loguitud del conductor Step 4
A=Lx*Ly; %Area 
%Step 5 Calculo de la resistencia Rg
ceq(2)=rho*(1/(x(1)+x(7)*Lr)+1/sqrt(20*A)*(1+1/(1+h*sqrt(20/(A)))))-x(4); %Calculo de la resistencia Rg
 %Step 6 Maximum grid current IG
IG=1908; %Amperios
%Step7 GPR.
ceq(3)=IG*x(4)-x(5);
%Step 8: Mesh voltage.
na=2*x(1)/(2*Lx+2*Ly);
nb=1; % for square grids 
nc=1; % for square and rectangular grids
nd=1; % for square, rectangular and L-shaped grids 
n=na*nb*nc*nd;
Ki=0.644 + 0.148*n;
%Kii=1/((2*n)^(2/n)); %Cuando no se usa varillas 
Kii=1;  %cuando se usa varillas 
Kh=sqrt(1+h/h0);
Km=(1/(2*pi))*(log(x(2)^2/(16*h*d)+(x(2)+2*h)^2/(8*x(2)*d)-h/(4*d))+(Kii/Kh)*log(8/(pi*(2*n-1))));
LM=x(1)+(1.55+1.22*(Lr/(sqrt(Lx^2+Ly^2))))*Lr*x(7); %longuitud efectiva enterrada. 

ceq(4)=rho*Km*Ki*IG/LM-x(6); %Voltage Mesh Em 
Ks=1/pi*(1/(2*h)+1/(x(2)+h)+(1/x(2))*(1-0.5^(n-2)));

ceq(5)=rho*Ks*Ki*IG/(0.75*x(1)+0.85*Lr*round(x(7)))-x(8); %Voltage Es 

ceq(6)=x(2)-x(3); %Las dos separaciones tanto en X como Y, sean iguales.  


