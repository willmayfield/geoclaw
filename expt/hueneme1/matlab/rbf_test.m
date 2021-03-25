%ref IC
sigmax = 0.0035;
sigmay = 0.0025;
amp = 6.0;
theta = -.8;
posx = -119.245;
posy = 34.055;

sigmax2 = 0.0015;
sigmay2 = 0.003;
amp2 = -12.0;
theta2 = -.80;
posx2 = -119.237;
posy2 = 34.0633;

params_ref = [sigmax, sigmay, amp, theta, posx, posy, sigmax2, sigmay2, amp2, theta2, posx2, posy2];


%rbfs
centers = zeros(36,2);
dx = 0.4/6;
dy = 0.4/6;
ll =  [posx-0.2, posy-0.2];
for j = 1:6
    for k = 1:6
        centers(k + (j-1)*6, :) = [ ll(1) + (j-1 + .5)*dx , ll(2) + (k-1 + .5)*dy];
    end
end
figure
plot(centers(:,1),centers(:,2),'o')

epsilon = .5/0.0025;

y = linspace(33.8,34.3);
x = linspace(-119.4,-119.1);

[X,Y] = meshgrid(x,y);



rbf = @(x1,y1,cx,cy) exp(-epsilon*((x1-cx)^2 + (y1 - cy)^2));

bases = @(x,y) rbf(x,y,centers(1,1),centers(1,2));



figure
fsurf(bases,[-119.4 -119.1 33.8 34.3])
hold on
for j = 2:36
    bases = @(x,y) rbf(x,y,centers(j,1),centers(j,2));
    fsurf(bases,[-119.4 -119.1 33.8 34.3])
    hold on
end




%variances for params
var_sigmax = 0;
var_sigmay = 0;
var_amp = 2;
var_theta = .2;
var_posx = 0;
var_posy = 0;
params_var = [var_sigmax, var_sigmay, var_amp, var_theta, var_posx, var_posy var_sigmax, var_sigmay, -var_amp, var_theta, var_posx, var_posy];

x = -119.24;
y = 34.04:.0001:34.08;
out = init_cond(x,y,params_ref);
out2 = init_cond(x,y,params_ref + params_var);
figure
plot(y,out,y,out2)
hold on
title('Cross section of Initial condition perturbation')
legend('ref solution','perturbed ref solution')
ylabel(' \eta (m)')
set(gca,'xticklabel',[])

% function result = bases(x,y)
%     posx = -119.245;
%     posy = 34.055;
%     centers = zeros(36,2);
%     dx = 0.4/6;
%     dy = 0.4/6;
%     ll =  [posx-0.2, posy-0.2];
%     
%     epsilon = .5/0.0025;
%     
%     for j = 1:6
%         for k = 1:6
%             centers(k + (j-1)*6, :) = [ ll(1) + (j-1 + .5)*dx , ll(2) + (k-1 + .5)*dy];
%         end
%     end
%     
%     result = 0;
%     for j = 1:36
%         result = result + exp(-epsilon*((x-centers(j,1))^2 + (y - centers(j,2))^2));
%     end
% end
