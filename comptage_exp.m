function [C_exp, message] = comptage_exp(x_d, x_e, l)
%COMPTAGE_EXP Summary of this function goes here
%   Detailed explanation goes here

%% Télécharge les constantes pour pouvoir les utiliser pour la résolution.
constantes;

%% Initialisation du problème
a_1 = rand(nb_photons, 3);    % Génération du nombre aléatoire.
z_s = h_s .* (a_1 - 0.5);          % Position de départ en z des photons.

h =  k .* z_s; % Tenseur hauteur de départ(dim 3000000x3).
O = zeros(nb_photons,1);
H = [O,O,h(:,1),O,O,h(:,2),O,O,h(:,3)];

R= ones(nb_photons, 9).*[r(1,:),r(2,:),r(3,:)] + H ; % Tenseur position en x,y,z de départ pour chaques photons sur chaques tiges (dim 3000000x3). 

%% Simulation de la direction du photon.

a_2 = rand(nb_photons, 3);
a_3 = rand(nb_photons, 3);

phi = 2 * pi * a_2;
mu = 2 * a_3 -1;
Omega_s = [ cos(phi) .* sqrt( 1 - mu.^2 ) , sin(phi) .* sqrt( 1 - mu.^2 ), mu ];
t = x_d./Omega_s(:,pos);
 

% elimination des photon partant du sens oposé au détecteur
eliminationx = t>0;
t = t.*eliminationx; 

clear a_1 a_2 a_3 z_s phi O eliminationx % nettoyage de la mémoir pour optimisation.

%% Résolution
switch nargin 
    
    case 1 % Cas sans écran
        
        clear mu h
       
        tOmega_s= [t(:,1).*Omega_s(:,1:3), t(:,2).*Omega_s(:,4:6), t(:,3).*Omega_s(:,7:9)];
       
        r_i = R + H +tOmega_s;
        
        r_i = [r_i(:,1:3);r_i(:,4:6);r_i(:,7:9)];
        
        indice = find(r_i(:,1)==x_d);
        p_restant = r_i(indice,:);
        
        eliminationy = 2 - abs(p_restant(:,2)) >= 0;  % Condition pour garder les photons attérissant sur le détecteur
        eliminationz = 2 - abs(p_restant(:,3)) >= 0;  % Condition pour garder les photons attérissant sur le détecteur
        
        elimination = eliminationy + eliminationz;
        
        C_exp = sum(elimination==2);
        message = ['Valeur expérimental sans écran,  C_exp=', num2str(C_exp)];
        
    case 3 % cas avec écran.
       
        t_e = (x_e/x_d).*t;
        tOmega_s= [t(:,1).*Omega_s(:,1:3), t(:,2).*Omega_s(:,4:6), t(:,3).*Omega_s(:,7:9)];
        teOmega_s= [t_e(:,1).*Omega_s(:,1:3), t_e(:,2).*Omega_s(:,4:6), t_e(:,3).*Omega_s(:,7:9)];
        
        r_e = R + H + teOmega_s;
        r_i = R + H +tOmega_s;
       
        r_e = [r_e(:,1:3);r_e(:,4:6);r_e(:,7:9)]; 
        r_i = [r_i(:,1:3);r_i(:,4:6);r_i(:,7:9)];
        
        h =[h(:,1) ;h(:,2) ;h(:,3)];
        mu =[mu(:,1) ;mu(:,2) ;mu(:,3)];
        
        indice = find(r_e(:,1)==x_e);
        p_restant = r_i(indice,:);
        
        elimination_ey = 20 - abs(p_restant(:,2)) >= 0;  % Condition pour garder les photons attérissant sur l'écran.
        elimination_ez = 20 - abs(p_restant(:,3)) >= 0;  % Condition pour garder les photons attérissant sur l'écran.
        
        elimination = elimination_ey + elimination_ez;
        indice = find(elimination==2);
        h = h(indice,:);
        mu = mu(indice,:);
        
        
        hyp_xd = sqrt(x_d^2 + r(1,2)^2);
        dist_x_det = [hyp_xd; x_d; hyp_xd]; % Hypoténuse former par la position de chaque tige et le détecteur.
        dist = sqrt( ( ones(length(h),3).*dist_x_det' ).^2 + h.^2 ); % Hypoténuse relative à la position initiale due chaque photons et le détecteur dim(1500000x3).
        theta = asin(h./dist); %dim(3000000x3) 
        
        P = exp( mu .* (l./cos(theta)) );
        a_4 = rand(length(h),3);

        p_continu = P  >= a_4;
        p_restant = p_continu.* r_i(indice,:);
        
        eliminationy = 2 - abs(p_restant(:,2)) >= 0;  % Condition pour garder les photons attérissant sur le détecteur
        eliminationz = 2 - abs(p_restant(:,3)) >= 0;  % Condition pour garder les photons attérissant sur le détecteur
        
        elimination = eliminationy + eliminationz;
        
        C_exp = sum(elimination==2);
        message = ['Valeur expérimental avec écran,  C_exp=', num2str(C_exp)];
        
end

