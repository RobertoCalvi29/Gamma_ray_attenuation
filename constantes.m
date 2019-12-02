% Constante de la simulation

Q = 10000; % Taux d'émission des photon par seconde.
r = [0, -10, 0 ; 0, 0, 0; 0, 10, 0]; % Tenseur contenant les vecteurs position des sources en (cm).
h_s = 40; % Hauteur des détecteurs.
Sigma = 0.5; % Section efficace du matériel constituant le détecteur en (cm-1).
nb_photons = 3e6; % Nombres de photons émis par sources.
T = 5 * 60; % Période de comptage fixe en (seconde).
C_exp =0;% comptage initiale 
pos = [1, 4, 7];% vecteur position utile pour constructiondes tenseur.
S_d = 4*4; % en cm^2

