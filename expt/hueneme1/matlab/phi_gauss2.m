function z = phi_gauss2(x,y,eps,cx,cy)

    [X,Y] = meshgrid(x,y);    

    z = exp(-eps^2*((X - cx).^2 + (Y - cy).^2));
end
