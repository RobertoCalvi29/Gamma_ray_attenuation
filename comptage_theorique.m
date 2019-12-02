function [C_th,message] = comptage_theorique(ecran, x_d, l)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% T�l�charge les constantes pour pouvoir les utiliser pour la r�solution.
constantes;

%% Initialisation des param�tres
hyp_xd = sqrt(x_d^2 + 10^2);

x = [hyp_xd; x_d; hyp_xd];

theta_2 = atan( (h_s/2) ./ x ); % angle pour calcul de l'int de Sievert pour tiges d�cal�s
theta_1 = atan( (-h_s/2)./ x  ); % angle pour calcul de l'int de Sievert pour tige centrale

Ql = Q/h_s;

%% Calculs
switch ecran
    
    case 0 % Sans �cran
        I_d = zeros(1,3);
        C_th = zeros(1,3);
        
        for i=1:3
            I_d(i) = (Ql/(4*pi*x(i)))*(theta_2(i) - theta_1(i));
            C_th(i) = I_d(i)*T*S_d;
        end
        
        C_th = sum(C_th);
        message = ['Valeur th�orique sans �cran,  C_th=', num2str(C_th)];
    
    case 1 % Avec �cran
        I_d = zeros(1,3);
        C_th = zeros(1,3);
        y = x.*Sigma*(l/x_d);
        
        for i =1:3
            F = @(theta) exp(-y(i)*sec(theta));
            I_d(i) = (Ql/(4*pi*x(i)))*(integral(F,0,theta_2(i)) - integral(F,0,theta_1(i)));
            C_th(i) = I_d(i)*T*S_d;
        end
        
        C_th = sum(C_th);
        message = ['Valeur th�orique avec �cran,  C_th=', num2str(C_th)];
end

