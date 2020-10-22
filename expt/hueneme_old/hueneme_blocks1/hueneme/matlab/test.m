clear all
close all

dim = 7;
time = 0:3:1794;
%gaugeno = [1 2 3 4 5 6 7 8 9];
gaugeno = [2 4 6 7];
num_gauges = size(gaugeno,2);
for j=1:num_gauges
    %%%%IMPORT new data FROM GAUGE%%%
    filename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/_output/gauge000' num2str(gaugeno(j),'%02d') '.txt'];
    startRow = 3;
    formatSpec = '%*5s%15f%*15f%15f%15f%f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    gaugedata = [dataArray{1:end-1}];
    clearvars filename startRow formatSpec fileID dataArray ans;
    
    %gaugedataformat is [time,u,v,eta]
    t_z = gaugedata(:,1);
    u_z = gaugedata(:,2);
    v_z = gaugedata(:,3);
    eta_z = gaugedata(:,4);
    
    
    uts = timeseries(u_z, t_z);
    vts = timeseries(v_z, t_z);
    etats = timeseries(eta_z, t_z);
    
    uts_out = resample(uts, time);
    vts_out = resample(vts, time);
    etats_out = resample(etats, time);  
    
%     datafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/ref_data_g' num2str(gaugeno(j),'%02d') '.mat'];
%     save(datafilename,'t','u','v','eta')
    
    uz = uts_out.Data;
    vz = vts_out.Data;
    etaz = etats_out.Data;
    speedz = sqrt(uz.^2 + vz.^2);
    
%    refdatafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA/ref_data_g' num2str(gaugeno(j),'%02d') '.mat'];
%    load(refdatafilename)
    
%     size(t)
%     size(t_g)
%     t(1:1545)-t_g
%     plot(t(1:1545),eta_g - eta(1:1545),t_g,eta_g - eta(1:1545))
    
%     u = u_g - u;
%     v = v_g - v;
%     eta = eta_g - eta;
% 
%     datafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA/data_g' num2str(gaugeno(j),'%02d') '_i' num2str(gf_i) '_j' num2str(gf_j) '.mat'];
%     save(datafilename,'t_g','u_g','v_g','eta_g')


refdatafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/ref_data_g' num2str(gaugeno(j),'%02d') '.mat'];
load(refdatafilename)
load('result_test.mat')
% figure
% plot(time,etar,'-k')
% hold on
% plot(time,etar+RESULT_ETA(j,:)','-b')
% hold on
% plot(time,etaz,'--r')
% legend('ref','gfpert','truepert')

speedr = sqrt(ur.^2 + vr.^2);

figure
plot(time,RESULT_ETA(gaugeno(j),:)','-b')
hold on
plot(time,etaz-etar,'--r')
title(['eta, gauge ' num2str(gaugeno(j)) ', alpha = .5'])
legend('gfpert','truepert')
% figure
% plot(time,RESULT_SPEED(j,:)','-b')
% hold on
% plot(time,speedz-speedr,'--r')
% legend('gfpert','truepert')
end