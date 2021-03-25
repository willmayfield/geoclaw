close all
clear all
dim = 6;
time = 0:3:1794;

gaugeno = [1];
num_gauges = size(gaugeno,2);

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
var_amp = 1;
var_theta = .2;
var_posx = 0;
var_posy = 0;

params_var = [var_sigmax, var_sigmay, var_amp, var_theta, var_posx, var_posy var_sigmax, var_sigmay, -var_amp, var_theta, var_posx, var_posy];

gf_dx = .04/dim;
gf_dy = .04/dim;
gf_ll_x = posx-.02;
gf_ll_y = posy-.02;

num_ens = 1000;


RESULT_ETA = zeros(num_ens,length(time)); %eta and speed for each gauge
RESULT_SPEED = zeros(num_ens,length(time));



lightBlue = [135,206,235] / 255; 
lightPurple = [147,112,219] / 255; 

for j=1:num_ens
    
params_rand = randn(1,6);
params_rand = [params_rand params_rand];
    
refdatafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/ref_data_g' num2str(gaugeno(1),'%02d') '.mat'];
load(refdatafilename)

for gfi = 1:dim
gf_i = gfi - 1;
for gfj = 1:dim 
gf_j = gfj - 1;

    datafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/p_data_g' num2str(gaugeno(1),'%02d') '_i' num2str(gf_i) '_j' num2str(gf_j) '.mat'];
    load(datafilename)
    
    %time is [time]
    %%ref data is [ur,vr,etar]
    %%gf data is [ug,vg,etag]

    params = params_ref + params_var.*params_rand;
    
    %get current position (func of gf_i and gf_j);
    x = gf_ll_x + (gf_i + .5)*gf_dx;
    y = gf_ll_y + (gf_j + .5)*gf_dy;
    
    %get 
    weight = init_cond(x,y,params) - init_cond(x,y,params_ref);
    
    RESULT_ETA(j,:) = RESULT_ETA(j,:) + .5*etag'*weight; 
    RESULT_SPEED(j,:) = RESULT_SPEED(j,:) + .5*(sqrt(ug.^2 + vg.^2)*weight)';


end

end
end

%save('result_test.mat','RESULT_ETA','RESULT_SPEED')


dim = 6;
j = 1;
refdatafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/ref_data_g' num2str(gaugeno(j),'%02d') '.mat'];
load(refdatafilename)

figure
subplot(3,1,1)
plot(time,etar','-k','linewidth',2)
hold on
for jjjj = 150:200
    plot(time',etar' + RESULT_ETA(jjjj,:),'color',lightPurple)
end
plot(time,etar','-k','linewidth',2)
legend('REF','GF')
title('Gauge 1 Realizations')
ylabel('\eta (m)')
subplot(3,1,2)
plot(time,etar'*0,'-k','linewidth',2)
hold on
for jjjj = 150:200
    plot(time',etar'*0 + RESULT_ETA(jjjj,:),'color',lightPurple)
end
legend('zero','GF')
ylabel('Perturbed \eta (m)')

subplot(3,1,3)
plot(time, var(RESULT_ETA),'-k','linewidth',2)
hold on
ylabel('Var(\eta) (m)')
xlabel('time (s)')

ens_results = [];
for ens_num = 1:60
    datafilename_ens = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/ENS_DATA_' num2str(dim) '/p_data_g' num2str(gaugeno(j),'%02d') '_n' num2str(ens_num) '.mat'];
    load(datafilename_ens)
    ens_results = [ens_results ; eta_e'];
end
plot(time, var(ens_results),'--r','linewidth',1)
legend('GF Var','MC')
    

%figure
%speedr = sqrt(ur.^2 + vr.^2);
%plot(time,speedr','--r',time,speedr' + RESULT_SPEED(1,:),'-b')
%legend('ref','gf')