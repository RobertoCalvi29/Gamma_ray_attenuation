function [C_th,message] = comptage_theorique(ecran, x_d)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Télécharge les constantes pour pouvoir les utiliser pour la résolution.
constantes;

theta_1 = atan( (h_s/2) / ( sqrt( x_d^2+ r(1,2)^2 ) ) ); % angle pour calcul de l'int de Sievert pour tiges décalés
theta_2 = atan(20/x_d); % angle pour calcul de l'int de Sievert pour tige centrale
theta_max = [theta_1, theta_2, theta_1]; % vecteur pour chaques valeurs max d'angle.

hyp_xd = sqrt(x_d^2 + 10^2);
x = [hyp_xd; x_d; hyp_xd];

switch ecran
    
    case 0 % Sans écran
        for i=1:3
            I_d(i) = (Q/(4*pi*x(i)))*(theta_2 - theta_1);
            C_th(i) = I_d(i)*T*S_d;
        end
        C_th = sum(C_th);
        message = ['Valeur theoriqu avec écran,  C_th=', num2str(C_th)];
    
    case 1 % Avec écran
        I_d = zeros(1,3);
        C_th = zeros(1,3);
        for i =1:3
            Fs(theta) = integral(@(theta)exp(-Sigma*( l/cos(theta) ) ),0,theta_max(1,i) );
            I_d(1,i) = Q./(4.*pi.*hyp_det(1,i)).*Fs;
            C_th(1,i) = sum(I_d)*T*S_d;
        end
        C_th = sum(C_th);
        message = ['Valeur theorique avec écran,  C_th=', num2str(C_th)];
end

