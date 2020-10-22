%ref data defaut params
%ref data defaut params
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

plot(y,out,y,out2)
hold on
title('Cross section of Initial condition perturbation')
legend('ref solution','perturbed ref solution')
ylabel(' \eta (m)')
set(gca,'xticklabel',[])
