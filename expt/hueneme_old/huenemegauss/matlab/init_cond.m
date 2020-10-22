function eta=init_cond(x,y,params)
    %params are [sigmax, sigmay, amp, theta, posx,posy]
    a = cos(params(4))^2/(2*params(1)^2) + sin(params(4))^2/(2*params(2)^2);
    b = -sin(2*params(4))/(4*params(1)^2) + sin(2*params(4))/(4*params(2)^2);
    c = sin(params(4))^2/(2*params(1)^2) + cos(params(4))^2/(2*params(2)^2);
    eta = params(3)*exp(-(a*(params(5)-x).^2 + 2*b*(x-params(5)).*(y-params(6)) + c*(y-params(6)).^2));
    
    a2 = cos(params(10))^2/(2*params(7)^2) + sin(params(10))^2/(2*params(8)^2);
    b2 = -sin(2*params(10))/(4*params(7)^2) + sin(2*params(10))/(4*params(8)^2);
    c2 = sin(params(10))^2/(2*params(7)^2) + cos(params(8))^2/(2*params(8)^2);
    
    eta = params(3)*exp(-(a*(params(5)-x).^2 + 2*b*(x-params(5)).*(y-params(6)) + c*(y-params(6)).^2));
    
    eta = eta + params(9)*exp(-(a2*(params(11)-x).^2 + 2*b2*(x-params(11)).*(y-params(12)) + c2*(y-params(12)).^2));
end