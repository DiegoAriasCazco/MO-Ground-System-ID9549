%Problema Multiobjetivo para diseño de mallas a tierra
% Autor: Msc. Diego Arias 
% Researcher

clc; clear;

%global Ar GPR Km h h0 d rho Lr 
%% Datos Step 1
tf=0.5;   %Tiempo de despeje de la falla 
rho=400;    %Resistividad del Suelo
rhos=2500; %Resistividad Superficial 
hs= 0.102; %espesor de la capa superficial 
h=0.5;     %profundidad de la malla
Lx=70;     %Lado X 
Ly=70;     %Lado Y
d=0.0105;  %diametro de conductor 
h0=1;      %altura referencial 
Lr=7.5;    %longuitud de la varilla 

%x(1) LC:longuitud del conductor
%x(2) Dx Space entre conductores en el eje x
%x(3) Dy Space entre conductores en el eje y
%x(4) Rg
%x(5) GPR
%x(6) Em
%x(7) cantidad de varillas
%x(8) Es

%% Calculos 
%Step 3. Touch and step criteria
Cs=1-0.09*(1-rho/rhos)/(2*hs+0.09); %constante 
Est=(1000+6*Cs*rhos)*0.157/sqrt(tf);%Criterios de paso
Eto=(1000+1.5*Cs*rhos)*0.157/sqrt(tf);%Criterios de toque
%Step 4. Initial design.

%% ---------------- Inequality constraints ---------------------
A=[]; b=[]; 
%% ------------------ Equality constraints ---------------------
Aeq = []; beq = [];

LCmin=2*Lx+2*Ly;
%3000
     %LT       Dx Dy Rg  GPR Em nR Es  
lb = [1540 0  0   0   0 0 0 0];  % Limites inferiores de variables 
ub = [1540      Lx Ly  5  1e4 Eto 200 Est];  %Limites superiores de variables

x0=(lb+ub)/2;

%Optimizacion sigleobjetive 
%[x,fval,exitflag,output,lambda,grad,hessian] = fmincon(@myfun,x0, A, b, Aeq, beq, lb, ub, @(x)const(x,Lx,Ly,rho,h,h0,d,Lr));
%[x, fval] = knitro_nlp(@myfun,x0, A, b, Aeq, beq, lb, ub, @(x)const(x,Lx,Ly,rho,h,h0,d,Lr));

%---------------------------------------------------------------------------------
%% Optimizacion Multiobjetivo  
% % %Comenzar con las opciones por default  Start with the default options
 nvars=8;
options = optimoptions('gamultiobj');
%% Modify options setting
%options = optimoptions(options,'PopulationSize', PopulationSize_Data);
%options = optimoptions(options,'ParetoFraction', ParetoFraction_Data);
options = optimoptions(options,'MigrationDirection', 'both');
options = optimoptions(options,'FunctionTolerance', 1e-4,'MaxStallGenerations',500);
%options = optimoptions(options,'MigrationInterval', MigrationInterval_Data);
%options = optimoptions(options,'MigrationFraction', MigrationFraction_Data);
options = optimoptions(options,'CreationFcn', @gacreationnonlinearfeasible);
options = optimoptions(options,'SelectionFcn', {  @selectiontournament [] });
options = optimoptions(options,'HybridFcn', {  @fgoalattain [] });
%options = optimoptions(options,'Display', 'iter');
%options = optimoptions(options,'PlotFcn', {@gaplotpareto,@gaplotscorediversity});
%options = optimoptions(options,'PlotFcn', {@gaplotpareto});


% options = optimoptions(options,'MigrationDirection', 'both');
 options = optimoptions(options,'ParetoFraction', 0.1);
 options = optimoptions(options,'CrossoverFcn', { @crossoverheuristic, 1});
% options = optimoptions(options,'CreationFcn', @gacreationnonlinearfeasible);
% options = optimoptions(options,'SelectionFcn', {  @selectiontournament [] });


options = optimoptions(options,'UseVectorized', false);
options = optimoptions(options,'UseParallel', false);
%[x,fval,exitflag,output,population,score] = ...
 %   gamultiobj(@multiobj2,nvars,[],[],[],[],lb,ub,@(x)const(x,Lx,Ly,rho,h,h0,d,Lr),options);
%for i=1:10
[x,fval,exitflag,output,population,score] = ...
    gamultiobj(@multiobj2,nvars,[],[],[],[],lb,ub,@(x)const(x,Lx,Ly,rho,h,h0,d,Lr),options);

% LC(:,i)=x(:,1);
% Rg(:,i)=x(:,4);
% 
% end
% 
% [m nn]=size(LC);
% LC=reshape(LC,m*nn,1);
% [m nn]=size(Rg);
% Rg=reshape(Rg,m*nn,1);
% 
% 
% 
% fit=fit(LC,Rg,'poly1','normalize','on');
% 
% 
% figure(3)
% hold on
% plot(fit,LC,Rg,'predobs');
% plot(LC,Rg);
% xlabel('Logitud del Condutor [m]')
% ylabel('Rg [Ohms]')
% hold off




figure (2)
plot(x(:,7),x(:,4),'k*');
xlabel('Numero de Rods')
ylabel('# Rg')

%[x,fval,exitflag,output,population,score] = ...
%    gamultiobj(@multiobj2,nvars,[],[],[],[],lb,ub,@(x)const(x,Lx,Ly,rho,h,h0,d,Lr),options);

% options = optimoptions('paretosearch','UseVectorized',false,'ParetoSetSize',200);
% rng default % For reproducibility
% [x,f] = paretosearch(@multiobj,nvars,[],[],[],[],lb,ub,@(x)const(x,Lx,Ly,rho,h,h0,d,Lr),options);

hold on
%plot(x(:,1),x(:,7),'r*');
grid on
hold off

%3D
figure (3)
scatter3(x(:,7),x(:,4),x(:,6),'k.');


