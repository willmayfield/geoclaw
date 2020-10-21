function [ z ] = f_mean2( x,y )
%double gaussian hump?
[X,Y] = meshgrid(x,y);

z = zeros(size(X));

sigx1 = .0035;
sigy1 = .0025;
amp1 = 6*1.5;
theta1 = -.8;
posx1 = -119.245;
posy1 = 34.055;

sigx2 = .0015;
sigy2 = .003;
amp2 = -12*1.5;
theta2 = -.8;
posx2 = -119.237;
posy2 = 34.0633;

a1 = cos(theta1)^2/(2*sigx1^2) + sin(theta1)^2/(2*sigy1^2);
b1 = -sin(2*theta1)/(4*sigx1^2) + sin(2*theta1)/(4*sigy1^2);
c1 = sin(theta1)^2/(2*sigx1^2) + cos(theta1)^2/(2*sigy1^2);

a2 = cos(theta2)^2/(2*sigx2^2) + sin(theta2)^2/(2*sigy2^2);
b2 = -sin(2*theta2)/(4*sigx2^2) + sin(2*theta2)/(4*sigy2^2);
c2 = sin(theta2)^2/(2*sigx2^2) + cos(theta2)^2/(2*sigy2^2);


z1 = amp1*exp(-(a1*(X-posx1).^2 + 2*b1*(X-posx1).*(Y-posy1) + c1*(Y-posy1).^2)) ;

z2 = amp2*exp(-(a2*(X-posx2).^2 + 2*b2*(X-posx2).*(Y-posy2) + c2*(Y-posy2).^2)) ;

(sum(sum(z1))/sum(sum(z2)));

z2 = -abs(z2*(sum(sum(z1))/sum(sum(z2))));

z = z1 + z2;

end

