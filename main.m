% Script : Monte-Carlo simulation on 3d mesh to simulate gamma photons 
%             being detected. 
% Author : Roberto Calvi
% Date of creation : 1/11/2019
% Last update      : 1/11/2019

clc;clear all;

sortie = 0; % Constante pour d�terminer sortir du programe une fois la simulation ex�cut�.

while sortie == 0 % Boucle s'assure que l'usager entre un nombre valide entre 0 et 10.
    N = input('Voulez-vous roulez toutes les simulations un nombre N de fois, si oui, entrer un nombre de 1-10 sinon enter 0: ');
   
    if N==0 % Cas o� l'on choisit une seule exp�rience � rouler.
        
        sortie =1; % Permet de mettre fin au programme en arr�tant la boucle une fois termin�.
        experience = input('Quelle exp�rience voulez-vous r�aliser (1-5): '); 
        exit = 0; % Permet d'�viter de repartir le programme si l'usager manquer sont entr�e. 
        
        while exit == 0 % Boucle permet de s,assurer que l'usager choisit bien une exp�rience entre 1-5.
            
            switch experience % R�alise l'exp�rience que l'usager � choisit.
                case  1
                    
                    message_simulation = 'Simulation de l''exp�rience 1';
                    
                    [C_th, message_res_th] = comptage_theorique(0, 50);
                    disp(message_res_th)
                    
                    C_exp = simule(message_simulation ,50);
                    exit = 1;
                    
                case 2
                    
                    message_simulation = 'Simulation de l''exp�rience 2';
                    
                    [C_th, message_res_th] = comptage_theorique(0, 100);
                    disp(message_res_th)
                    
                    C_exp = simule(message_simulation ,100);
                    exit = 1;
                    
                case 3
                    message_simulation = 'Simulation de l''exp�rience 3';
                    
                    [C_th, message_res_th] = comptage_theorique(1, 50, 2);
                    disp(message_res_th)
                    
                    C_exp = simule(message_simulation,50, 20 ,2);
                    exit = 1;
                    
                case 4
                    
                    message_simulation = 'Simulation de l''exp�rience 4';
                    
                    [C_th, message_res_th] = comptage_theorique(1, 50 ,2);
                    disp(message_res_th)
                    
                    C_exp = simule(message_simulation, 50, 40 ,2);
                    exit = 1;
                    
                case  5
                   
                    message_simulation = 'Simulation de l''exp�rience 5';
                    
                    [C_th, message_res_th] = comptage_theorique(1, 50, 4);
                    disp(message_res_th)
                    
                    C_exp  = simule(message_simulation, 50, 40, 4);
                    exit = 1;
                    
                otherwise
                   experience = input('Entrer non valid, veuillez entrer un nombre entre 1 et 5: ');
            end
            
            
        end

    elseif (1 <= N) && (N <= 10)  % R�alise l'exp�rience N fois  
        
        % Calcul des valeurs theoriques
        [C_th_exp1 ,message_res_th_sans] = comptage_theorique(0, 50); % Valeur th�orique avec �cran
        disp(message_res_th_sans)
        [C_th_exp2 ,message_res_th_sans] = comptage_theorique(0, 100); % Valeur th�orique avec �cran
        disp(message_res_th_sans)
        [C_th_exp3 ,message_res_th_sans] = comptage_theorique(1, 50,2); % Valeur th�orique avec �cran
        disp(message_res_th_sans)
        [C_th_exp4 ,message_res_th_sans] = comptage_theorique(1, 50,2); % Valeur th�orique avec �cran
        disp(message_res_th_sans)
        [C_th_exp5 ,message_res_th_sans] = comptage_theorique(1, 50,4); % Valeur th�orique avec �cran
        disp(message_res_th_sans)
        
        C_th = [C_th_exp1, C_th_exp2, C_th_exp3, C_th_exp4, C_th_exp5];
        
        % Calcul des 5 exp�riences N fois
        sortie =1;
        simulations =  { 50; 100; {50; 20; 2}; {50; 40 ;2}; {50; 40; 4} };
        
        tic;
        for n = 1: N
            iteration = num2str(n);
            for i = 1:5
                exprience = num2str(i);
                message_simulation = ['Simulation de l''exp�rience ' , exprience , ' N=' , iteration];
                if i <= 2
                    C_exp(i,n) = simule( message_simulation, simulations{i,:});
                else
                    C_exp(i,n) = simule( message_simulation, simulations{i,:}{:});
                end
            end
            
        end
        temps = toc;
        fprintf(' Le temps de simulation fut de %d  (en secondes)', round(temps));
        
        % Calcul des moyennes
        for i = 1:5
            
            C_exp_moy(i) = mean(C_exp(i,:));
            
            var = (100/C_exp_moy(i)).*sqrt( mean( (C_exp(i,:) - C_exp_moy(i)).^2 ) );
            
            D = 100.*( (C_exp_moy(i)-C_th(i))./C_th(i) );
            
        end
        
        % Sauvegarde des r�sultats
        csvwrite('results.csv',C_exp)

    else
        
        disp('Entrer non valide veuillez recommencer.')
    
    end
    
end
