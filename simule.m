function C_exp = simule(message, x_d, x_e, l)
%INITIALISATION 
%   Detailed explanation goes here

f = waitbar(0,message); % Rajoute une bar de pogression.

% Conditions adapter la simulation pour avec ou sans écran. 
switch nargin 
    
    case 2   
        [C_exp, message] = comptage(f,x_d);
        disp(message)
    
    case 4
        [C_exp, message] = comptage(f,x_d, x_e, l);
        disp(message)
end

close(f)

end

