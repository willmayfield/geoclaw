close all
clear all
dim = 7;
time = 0:3:1794;

gaugeno = [1 2 3 4 5 6 7 8 9];
num_gauges = size(gaugeno,2);

%ref data defaut params
sigmax = 0.004;
sigmay = 0.006;
amp = 10.0;
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

gf_dx = .04/dim;
gf_dy = .04/dim;
gf_ll_x = posx-.02;
gf_ll_y = posy-.02;


RESULT_ETA = zeros(num_gauges,length(time)); %eta and speed for each gauge
RESULT_SPEED = zeros(num_gauges,length(time));

params_rand = randn(1,6);

for j=1:num_gauges
    
refdatafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/ref_data_g' num2str(gaugeno(j),'%02d') '.mat'];
load(refdatafilename)

for gfi = 1:dim
gf_i = gfi - 1;
for gfj = 1:dim 
gf_j = gfj - 1;

    datafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/p_data_g' num2str(gaugeno(j),'%02d') '_i' num2str(gf_i) '_j' num2str(gf_j) '.mat'];
    load(datafilename)
    
    %time is [time]
    %%ref data is [ur,vr,etar]
    %%gf data is [ug,vg,etag]

    params = params_ref + params_var;%.*params_rand;
    
    %get current position (func of gf_i and gf_j);
    x = gf_ll_x + (gf_i + .5)*gf_dx;
    y = gf_ll_y + (gf_j + .5)*gf_dy;
    
    %get 
    weight = init_cond(x,y,params) - init_cond(x,y,params_ref);
    
    RESULT_ETA(j,:) = RESULT_ETA(j,:) + 2*etag'*weight; 
    RESULT_SPEED(j,:) = RESULT_SPEED(j,:) + 2*(sqrt(ug.^2 + vg.^2)*weight)';


end

end
end

save('result_test.mat','RESULT_ETA','RESULT_SPEED')


dim = 7;
j = 7;
refdatafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/ref_data_g' num2str(gaugeno(j),'%02d') '.mat'];
load(refdatafilename)

figure
plot(time,etar','-b',time',etar' + RESULT_ETA(j,:),'--r')
legend('ref','gf')
title('Gauge 7, eta (m)')

%figure
%speedr = sqrt(ur.^2 + vr.^2);
%plot(time,speedr','--r',time,speedr' + RESULT_SPEED(1,:),'-b')
%legend('ref','gf')