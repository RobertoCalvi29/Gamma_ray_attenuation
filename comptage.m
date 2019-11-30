function  [C_exp, message] = comptage(f,x_d, x_e, l)
%COMPTAGE This functions does the counting of the photons received by the
%detector
%   Thers is 2 case here, one for the simulation with the screen wich
%   implies that you have x_e, x_ed, and passed to the function. the other
%   does the simulation without the screen.

% Télécharge les constantes pour pouvoir les utiliser pour la résolution.
constantes;



for t = 1 : T
    % Création de certaines variables utile pour optimisation de la rapidité de
    % calcul.
    hyp_det = zeros(Q,3);
    dist_det = zeros(Q,3);
    theta_d = zeros(Q,3);
    omega_s = zeros(Q,3);
    Omega_s = zeros(Q,9);
   
    % Simulation de la position de départ des photon.
    
    for i = 1:3 % Construction des tenseur position et hauteur initiale.
       
        a_1 = rand(Q, 1); 
        z_s = h_s .* (a_1 - 0.5); % Position de départ en z des photons.
        
        H(:,pos(i):3*i) =  k .* z_s; % Tenseur hauteur de départ.
        
        R(:,pos(i):3*i) = r(i, :) .*  ones(Q, 1) + H(Q,pos(i):3*i); % Tenseur position en x,y,z de départ pour chaques photons sur chaques tiges (dim 1000x9). 
        hyp_det(:,i) = sqrt( x_d^2+r(i,2)^2 ) .* ones(Q,1); % Hypoténuse former par la position de chaque tige et le détecteur.
        dist_det(:,i) = sqrt( hyp_det(i).^2 +H(:,3*i).^2 ); % Hypoténuse relative à la position initiale due chaque photons et le détecteur.
        
        theta_d(:,i) = asin(H(:,3*i)./dist_det(:,i)); %(1000x9) 
   
    end

    % Simulation de la direction du photon.

    a_2 = rand(Q, 3);
    a_3 = rand(Q, 3);

    phi = 2 * pi * a_2;
    mu = 2 * a_3 -1;
    
    omega_s = [ cos(phi) .* sqrt( 1 - mu.^2 ) , sin(phi) .* sqrt( 1 - mu.^2 ), mu ]; % Vecteur de propagation des photons.
    
    for i =1:3
        for j =1:1000
            Omega_s(j,pos(i):3*i) = dist_det(j,i).*omega_s(j,pos(i):3*i);
        end
    end

    % Calucul de la trajectoire
    
    switch nargin
    
        % Pour cas avec écran.
        case 4
            
            r_e = R + H + Omega_s;
            r_i = R + H + Omega_s;
          
            for i = 1:3 

                    for j = 1:Q

                        % Calcul de la valeur expérimentale
                        if r_i(j, pos(i))>0

                            if 20 - abs(r_e(j, pos(i)+1)) >= 0 && 20 - abs(r_e(j, i*3)) >= 0 % Condition pour garder les photons attérissant sur l'écran.

                                P = exp( mu(j, i) .* (l/cos(theta(j,i))) );
                                a_4 = rand();

                                if P >= a_4
                                
                                    if 2 - abs(r_i(j, pos(i)+1)) >= 0 && 2 - abs(r_i(j, i*3)) >= 0 % Condition pour garder les photons attérissant sur le détecteur.
                                    
                                        C_exp = C_exp+1;
                                        
                                    end

                                end

                            end
                            
                        end
                        
                        message = ['Valeur expérimental avec écran,  C_exp=', num2str(C_exp)];
                    
                    end

            end
            
        % Pour sans écran.
        case 2
            r_i = R + H + Omega_s; % Tenseur contenant le  trajet des photon partant de chaques sources dim(1000 x 9).
    
            % Vérification que le photon a été détecté
    
            for i = 1:3 

                for j = 1:Q
                    
                    if r_i(j, pos(i))>0
                        
                        if 2 - abs(r_i(j, pos(i)+1:i*3)) >= 0  % Condition pour garder les photons attérissant sur le détecteur

                            C_exp = C_exp+1;
                            
                        end
                        
                    end

                end
                message = ['Valeur expérimental sans écran,  C_exp=', num2str(C_exp)];
            end
            
    end
    
    waitbar(t / T)
    
end

end


