function S_exp = simule(message, x_d, x_e, l)
%INITIALISATION 
%   Detailed explanation goes here

f = waitbar(0,message); % Rajoute une bar de pogression.

% Conditions adapter la simulation pour avec ou sans �cran. 
switch nargin 
    
    case 2   
        [S_exp, message] = comptage(f,x_d);
        disp(message)
    
    case 4
        [S_exp, message] = comptage(f,x_d, x_e, l);
        disp(message)
end

close(f)

end

