function eta=init_cond(x,y,params)
    %params are [sigmax, sigmay, amp, theta, posx,posy]
    a = cos(params(4))^2/(2*params(1)^2) + sin(params(4))^2/(2*params(2)^2);
    b = -sin(2*params(4))/(4*params(1)^2) + sin(2*params(4))/(4*params(2)^2);
    c = sin(params(4))^2/(2*params(1)^2) + cos(params(4))^2/(2*params(2)^2);
    eta = params(3)*exp(-(a*(params(5)-x).^2 + 2*b*(x-params(5)).*(y-params(6)) + c*(y-params(6)).^2));
end