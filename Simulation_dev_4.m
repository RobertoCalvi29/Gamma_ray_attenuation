% Script : Monte-Carlo simulation on 3d mesh to simulate gamma photons 
%             being detected. 
% Author : Roberto Calvi
% Date of creation : 1/11/2019
% Last update      : 1/11/2019

clc;clear all;

sortie = 0; % Constante pour déterminer sortir du programe une fois la simulation exécuté.

while sortie == 0 % Boucle s'assure que l'usager entre un nombre valide entre 0 et 10.
    N = input('Voulez-vous roulez toutes les simulations un nombre N de fois, si oui, entrer un nombre de 1-10 sinon enter 0: ');
   
    if N==0 % Cas où l'on choisit une seule expérience à rouler.
        
        sortie =1; % Permet de mettre fin au programme en arrêtant la boucle une fois terminé.
        experience = input('Quelle expérience voulez-vous réaliser (1-5): '); 
        exit = 0; % Permet d'éviter de repartir le programme si l'usager manquer sont entrée. 
        
        while exit == 0 % Boucle permet de s,assurer que l'usager choisit bien une expérience entre 1-5.
            
            switch experience % Réalise l'expérience que l'usager à choisit.
                case  1
                    
                    message_simulation = 'Simulation de l''expérience 1';
                    
                    [C_th, message_res_th] = comptage_theorique(0, 50);
                    disp(message_res_th)
                    
                    C_exp = simule(message_simulation ,50);
                    exit = 1;
                    
                case 2
                    
                    message_simulation = 'Simulation de l''expérience 2';
                    
                    [C_th, message_res_th] = comptage_theorique(0, 100);
                    disp(message_res_th)
                    
                    C_exp = simule(message_simulation ,100);
                    exit = 1;
                    
                case 3
                    message_simulation = 'Simulation de l''expérience 3';
                    
                    %[C_th, message_res_th] = comptage_theorique(1, 50);
                    %disp(message_res_th)
                    
                    C_exp = simule(message_simulation,50, 20 ,2);
                    exit = 1;
                    
                case 4
                    
                    message_simulation = 'Simulation de l''expérience 4';
                    
                    [C_th, message_res_th] = comptage_theorique(1, 50);
                    disp(message_res_th)
                    
                    C_exp = simule(message_simulation, 50, 40 ,2);
                    exit = 1;
                    
                case  5
                   
                    message_simulation = 'Simulation de l''expérience 5';
                    
                    [C_th, message_res_th] = comptage_theorique(1, 50);
                    disp(message_res_th)
                    
                    C_exp  = simule(message_simulation, 50, 40, 4);
                    exit = 1;
                    
                otherwise
                   experience = input('Entrer non valid, veuillez entrer un nombre entre 1 et 5: ');
            end
            
            
        end

    elseif (1 <= N) && (N <= 10)  % Réalise l'expérience N fois  
        
        [C_th_sans ,message_res_th_sans] = comptage_theorique(0, 50); % Valeur théorique avec écran
        disp(message_res_th_sans)
        [C_th_avec, message_res_th_sans] = comptage_theorique(1, 50); % Valeur théorique sans écran
        disp(message_res_th_sans)
        
        sortie =1;
        simulations =  { 50; 100; [50, 20, 2]; [50, 40 ,2]; [50, 40, 4] };
        
        for n = 1: N
            iteration = num2str(n);
            for i = 1:5
                exprience = num2str(i);
                message_simulation = ['Simulation de l''expérience' , exprience , ' N=' , iteration];
                C_exp(i,n) = simule( message_simulation, simulations{i,1});
            end
            
        end
        
        for i = 1:5
            
            C_exp_moy(i) = mean(C_exp(i,:));
            
            var = (100/C_exp_moy(i)).*sqrt( mean( (C_exp(i,:) - C_exp_moy(i)).^2 ) );
            
            if i <= 2 
                D_sans = 100.*( (C_exp_moy(i)-C_th_sans)./C_th_sans );
            else
                D_avec = 100.*( (C_exp_moy(i)-C_th_avec)./C_th_avec );
            
            end
            
        end
        
        
        csvwrite('results.csv',C_exp)
        
        disp('Voici le tableau du comptage pour chaque expérience et pour chaque itérations:')
        N = 1:N;
        table(N,C_exp)
        
        experiences = ['experience1', 'experience2', 'experience3', 'experience4', 'experience5'];
                
        disp('Valeurs moyenne expérimental pour chaques expériences:')
        table(experiences, C_exp_moy);
        
        disp('Variances pour chaques expériences:')
        table(experiences, var);
        
        disp('Différences en pourcentage entre valeur expériemental du comptage et sa valeurs théorique pour chaques expériences:')
        table(experiences, var);
        
    else
        
        disp('Entrer non valide veuillez recommencer.')
    
    end
    
end


