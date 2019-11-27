function  [S_exp,message] = comptage(f,x_d, x_e, l)
%COMPTAGE This functions does the counting of the photons received by the
%detector
%   Thers is 2 case here, one for the simulation with the screen wich
%   implies that you have x_e, x_ed, and passed to the function. the other
%   does the simulation without the screen.

% T�l�charge les constantes pour pouvoir les utiliser pour la r�solution.
constantes;

S_exp =0; 
k= [0 ,0 ,1]; % vecteur unitaire pour la direction unitaire pour la direction en z.
pos = [1, 4, 7];
hyp_det = zeros(Q,3);
dist_det = zeros(Q,3);
theta_d = zeros(Q,3);

for t = 1 : T
   
    % Simulation de la position de d�part des photon.
    
    for i = 1:3 % Construction des tenseur position et hauteur initiale.
       
        a_1 = rand(Q, 1); 
        z_s = h_s .* (a_1 - 0.5); % Position de d�part en z des photons.
        
        H(:,pos(i):3*i) =  k .* z_s; % Tenseur hauteur de d�part.
        
        R(:,pos(i):3*i) = r(i, :) .*  ones(Q, 1) + H(Q,pos(i):3*i); % Tenseur position en x,y,z de d�part pour chaques photons sur chaques tiges (dim 1000x9). 
        
        hyp_det(:,i) = sqrt( x_d^2+r(i,2)^2 ) .* ones(Q,1); % Hypot�nuse former par la position de chaque tige et le d�tecteur.
        dist_det(:,i) = sqrt( hyp_det(i).^2 +H(:,3*i).^2 ); % Hypot�nuse relative � la position initiale due chaque photons et le d�tecteur.
        
        theta_d(:,i) = H(:,3*i)./dist_det;
   
    end

    % Simulation de la direction du photon.

    a_2 = rand(Q, 3);
    a_3 = rand(Q, 3);

    phi = 2 * pi * a_2;
    mu = 2 * a_3 -1;

    Omega_s = [ cos(phi) .* sqrt( 1 - mu.^2 ) , sin(phi) .* sqrt( 1 - mu.^2 ), mu ]; % Vecteur de propagation des photons.

    % Calucul de la trajectoire
    
    switch nargin
    
        % Pour cas avec �cran.
        case 4
            
            hyp_ecran = sqrt( x_e^2 + r(:,2).^2 ) .* ones(Q,3); % Hypot�nuse former par la position de chaque tige et l'�cran.
            dist_ecran = sqrt( hyp_ecran.^2 + H(:,3:3:9).^2 ); % Hypot�nuse relative � la position initiale due chaque photons et l'�cran.
            theta_e = H(:,3:3:9)./dist_ecran;
            
            Fs(theta,y) = quad(@(x)exp(-y*Sigma*sec(theta_e),0,theta_e));
            
            r_e = R + H + dist_ecran .* Omega_s;
            r_i = R + H + dist_det .* Omega_s;
          
            for i = 1:3 

                    for j = 1:Q
                        
                        if r_i(j, pos(i))>0

                            if 20 - abs(r_e(j, pos(i)+1)) >= 0 && 20 - abs(r_e(j, i*3)) >= 0 % Condition pour garder les photons att�rissant sur l'�cran.

                                P = exp( mu(j, i) .* l );
                                a_4 = rand();

                                if P >= a_4
                                
                                    if 2 - abs(r_i(j, pos(i)+1)) >= 0 && 2 - abs(r_i(j, i*3)) >= 0 % Condition pour garder les photons att�rissant sur le d�tecteur.
                                    
                                        S_exp = S_exp+1;
                                
                                    end

                                end

                            end
                            
                        end
                        
                        message = ['Avec �cran,  S_exp=', num2str(S_exp)];
                    
                    end

            end
            
        % Pour sans �cran.
        case 2
            r_i = R + H + dist_det .* Omega_s; % Tenseur contenant le  trajet des photon partant de chaques sources dim(1000 x 9).
    
            % V�rification que le photon a �t� d�tect�
    
            for i = 1:3 

                for j = 1:Q
                    
                    if r_i(j, pos(i))>0

                        if 2 - abs(r_i(j, pos(i)+1:i*3)) >= 0  % Condition pour garder les photons att�rissant sur le d�tecteur

                            S_exp = S_exp+1;

                        end
                        
                    end

                end
                message = ['Sans �cran,  S_exp=', num2str(S_exp)];
            end
            
    end
    
    waitbar(t / T)
    
end

end


