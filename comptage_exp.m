function [C_exp, message] = comptage_exp(x_d, x_e, l)
%COMPTAGE_EXP Summary of this function goes here
%   Detailed explanation goes here

%% T�l�charge les constantes pour pouvoir les utiliser pour la r�solution.
constantes;

%% Initialisation du probl�me
a_1 = rand(nb_photons, 3);    % G�n�ration du nombre al�atoire.
z_s = h_s .* (a_1 - 0.5);          % Position de d�part en z des photons.
y_s= ones(nb_photons, 9).*[r(1,:),r(2,:),r(3,:)];   % position de d�part en y.

%% Simulation de la direction du photon.

a_2 = rand(nb_photons, 3);
a_3 = rand(nb_photons, 3);

phi = 2 * pi * a_2;
mu = 2 * a_3 -1;
Omega_s = [ cos(phi) .* sqrt( 1 - mu.^2 ) , sin(phi) .* sqrt( 1 - mu.^2 ), mu ];
Omega_sx = Omega_s(:,pos);
Omega_sy = Omega_s(:,pos+1);
Omega_sz = Omega_s(:,pos+2);

% elimination des photon partant du sens opos� au d�tecteur
eliminationx = find(Omega_sx>0);
t = x_d./Omega_sx(eliminationx);


clear a_1 a_2 a_3 phi % nettoyage de la m�moir pour optimisation.

%% R�solution
switch nargin 
    
    case 1 % Cas sans �cran
        clear mu
        % Conditions pour garder les photons att�rissant sur le d�tecteur
        eliminationy1 = 2 > (y_s(eliminationx)+ t.*Omega_sy(eliminationx)) > -2;
        %eliminationy2 = -2 < (y_s(eliminationx)+ t.*Omega_sy(eliminationx));
        eliminationz1 = 2 > (z_s(eliminationx)+ t.*Omega_sz(eliminationx)) > -2;
        %eliminationz2 = -2 < (z_s(eliminationx)+ t.*Omega_sz(eliminationx));
        
        elimination = eliminationy1 + eliminationz1;
        
        C_exp = sum(elimination==2); % On veut que les quatre conditions est �t� respect�
        message = ['Valeur exp�rimental sans �cran,  C_exp=', num2str(C_exp)];
        
    case 3 % cas avec �cran.
        
        % On commence par calculer ceux qui arrive � l'�cran
        eliminationy1 = 2 > (y_s(eliminationx)+ t.*Omega_sy(eliminationx));
        eliminationy2 = -2 < (y_s(eliminationx)+ t.*Omega_sy(eliminationx));
        eliminationz1 = 2 > (z_s(eliminationx)+ t.*Omega_sz(eliminationx));
        eliminationz2 = -2 < (z_s(eliminationx)+ t.*Omega_sz(eliminationx));
        
        elimination = eliminationy1 + eliminationy2+ eliminationz1+ eliminationz2; 
        
        elimination_det = find(elimination==2);
        
        photon_restant = eliminationx(elimination_det);
        % On  ajuste maintenant  en consid�rant maintenant l'impacte de l'�cran en ajustant le r�sultat. 
        t_e = (x_e/x_d).*t;
        
        hyp_xd = sqrt(x_d^2 + r(1,2)^2);
        dist_x_det = [hyp_xd; x_d; hyp_xd]; % Hypot�nuse former par la position de chaque tige et le d�tecteur.
        dist = sqrt( ( ones(length(z_s),3).*dist_x_det' ).^2 + z_s.^2 ); % Hypot�nuse relative � la position initiale due chaque photons et le d�tecteur dim(1500000x3).
        theta = asin(z_s./dist); %dim(3000000x3) 
        
        P = exp( -Sigma.* (l./cos(theta(photon_restant))) );
        a_4 = rand(nb_photons,3);
        
        C_non_absorbe = find(P  >= a_4(photon_restant));
        
        C_exp = length(C_non_absorbe);
        
%         t2 = (xe+l)./Omega_sx(photons_sans_ecran);
%         z = omega3(photons_sans_ecran).*(t2-t1);
%         y = omega2(photons_sans_ecran).*(t2-t1);
%         L = sqrt( (e*ones(size(z,1),size(z,2))).^2 + y.^2 + z.^2 );
%         P = exp(-sigma*L);
%     photons_detectes = [photons_detectes length(find(P >= a4(photons_sans_ecran)))];
        
%         
%         teOmega_s= [t_e(:,1).*Omega_s(:,1:3), t_e(:,2).*Omega_s(:,4:6), t_e(:,3).*Omega_s(:,7:9)];
%         
%         r_e = R + H + teOmega_s;
%         r_i = R + H +tOmega_s;
%        
%         r_e = [r_e(:,1:3);r_e(:,4:6);r_e(:,7:9)]; 
%         r_i = [r_i(:,1:3);r_i(:,4:6);r_i(:,7:9)];
%         
%         h =[h(:,1) ;h(:,2) ;h(:,3)];
%         mu =[mu(:,1) ;mu(:,2) ;mu(:,3)];
%         
%         indice = find(r_e(:,1)==x_e);
%         p_restant = r_i(indice,:);
%         
%         elimination_ey = 20 - abs(p_restant(:,2)) >= 0;  % Condition pour garder les photons att�rissant sur l'�cran.
%         elimination_ez = 20 - abs(p_restant(:,3)) >= 0;  % Condition pour garder les photons att�rissant sur l'�cran.
%         
%         elimination = elimination_ey + elimination_ez;
%         indice = find(elimination==2);
%         h = h(indice,:);
%         mu = mu(indice,:);
%         
%         
%         hyp_xd = sqrt(x_d^2 + r(1,2)^2);
%         dist_x_det = [hyp_xd; x_d; hyp_xd]; % Hypot�nuse former par la position de chaque tige et le d�tecteur.
%         dist = sqrt( ( ones(length(h),3).*dist_x_det' ).^2 + h.^2 ); % Hypot�nuse relative � la position initiale due chaque photons et le d�tecteur dim(1500000x3).
%         
%         
%         P = exp( mu .* (l./cos(theta)) );
%         a_4 = rand(length(h),3);
% 
%         p_continu = P  >= a_4;
%         p_restant = p_continu.* r_i(indice,:);
%         
%         eliminationy = 2 - abs(p_restant(:,2)) >= 0;  % Condition pour garder les photons att�rissant sur le d�tecteur
%         eliminationz = 2 - abs(p_restant(:,3)) >= 0;  % Condition pour garder les photons att�rissant sur le d�tecteur
%         
%         elimination = eliminationy + eliminationz;
%         
%         C_exp = sum(elimination==2);
        message = ['Valeur exp�rimental avec �cran,  C_exp=', num2str(C_exp)];
        
end

