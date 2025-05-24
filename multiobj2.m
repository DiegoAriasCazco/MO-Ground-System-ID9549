function f=multiobj2(x)



f(1)=x(1); % #Longuitud del conductor 
f(2)=round(x(7)); % Cantidad de varillas 
f(3)=x(4); % Rg 
%Resistencia Vs. Cable y Rods 
% f(1)=x(1)*CC+x(7)*CV; % #Longuitud del conductor * Costo del Conductor
% f(2)=x(4); % Cantidad de varillas * Costo de la Varilla  