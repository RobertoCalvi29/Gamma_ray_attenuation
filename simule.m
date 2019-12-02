function C_exp = simule(message, x_d, x_e, l)
%INITIALISATION 
%   Detailed explanation goes here

warning(message);
% Conditions adapter la simulation pour avec ou sans écran. 
switch nargin 
    
    case 2   
        [C_exp, message] = comptage_exp(x_d);
    
    case 4
        [C_exp, message] = comptage_exp(x_d, x_e, l);
        
end
disp(message)
end

