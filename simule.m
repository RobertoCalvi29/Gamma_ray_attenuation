function C_exp = simule(message, x_d, x_e, l)
%INITIALISATION 
%   Detailed explanation goes here

warning(message);
% Conditions adapter la simulation pour avec ou sans �cran. 
switch nargin 
    
    case 2   
        [C_exp, message] = comptage_exp(x_d);
        disp(message)
    
    case 4
        [C_exp, message] = comptage_exp(x_d, x_e, l);
        disp(message)
end

end

