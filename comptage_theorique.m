function [C_th,message] = comptage_theorique(ecran, x_d)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% T�l�charge les constantes pour pouvoir les utiliser pour la r�solution.
constantes;

switch ecran
    
    case 0 % Sans �cran
        I_d = Q/(4*pi*x_d);
        C_th = I_d*T*S_d;
        message = ['Valeur theoriqu avec �cran,  C_th=', num2str(C_th)];
    
    case 1 % Avec �cran
        theta_1 = atan( (h_s/2) / ( sqrt( x_d^2+ r(1,2)^2 ) ) ); % angle pour calcul de l'int de Sievert pour tiges d�cal�s
        theta_2 = atan(20/x_d); % angle pour calcul de l'int de Sievert pour tige centrale
        theta_max = [theta_1, theta_2, theta_1]; % vecteur pour chaques valeurs max d'angle.
        I_d = zeros(1,3);
        C_th = zeros(1,3);
        for i =1:3
            Fs(theta) = integral(@(theta)exp(-Sigma*( l/cos(theta) ) ),0,theta_max(1,i) );
            I_d(1,i) = Q./(4.*pi.*hyp_det(1,i)).*Fs;
            C_th(1,i) = sum(I_d)*T*S_d;
        end
        C_th = sum(C_th);
        message = ['Valeur theorique avec �cran,  C_th=', num2str(C_th)];
end

