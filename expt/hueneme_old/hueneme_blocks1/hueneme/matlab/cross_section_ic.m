%ref data defaut params
sigmax = 0.004;
sigmay = 0.006;
amp = 9.0;
theta = 0.0;
posx = -119.24;
posy = 34.06;
params_ref = [sigmax, sigmay, amp, theta, posx, posy];

%variances for params
var_sigmax = 0;
var_sigmay = 0;
var_amp = 1;
var_theta = 0;
var_posx = 0;
var_posy = 0;
params_var = [var_sigmax, var_sigmay, var_amp, var_theta, var_posx, var_posy];

x = -119.24;
y = 34.04:.001:34.08;
out = init_cond(x,y,params_ref);
out2 = init_cond(x,y,params_ref + params_var);

plot(y,out,y,out2)
