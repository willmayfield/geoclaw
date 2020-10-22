
dim = 7;
time = 0:3:1794;

gaugeno = [1 2 3 4 5 6 7 8 9];
num_gauges = size(gaugeno,2);

figure
hold on
for j = 1:num_gauges
    
    filename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/_output/gauge000' num2str(gaugeno(j),'%02d') '.txt'];
    startRow = 3;
    formatSpec = '%*5s%15f%*15f%15f%15f%f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    gaugedata = [dataArray{1:end-1}];
    clearvars filename startRow formatSpec fileID dataArray ans;
    
    %gaugedataformat is [time,u,v,eta]
    t = gaugedata(:,1);
    u = gaugedata(:,2);
    v = gaugedata(:,3);
    eta = gaugedata(:,4);
    
    
    uts = timeseries(u, t);
    vts = timeseries(v, t);
    etats = timeseries(eta, t);
    
    uts_out = resample(uts, time);
    vts_out = resample(vts, time);
    etats_out = resample(etats, time);  
    
%     datafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/ref_data_g' num2str(gaugeno(j),'%02d') '.mat'];
%     save(datafilename,'t','u','v','eta')
    
    ur = uts_out.Data;
    vr = vts_out.Data;
    etar = etats_out.Data;

plot(etar)
hold on
   % save(datafilename,'time','ug','vg','etag')
    refdatafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/ref_data_g' num2str(gaugeno(j),'%02d') '.mat'];
    save(refdatafilename,'time','ur','vr','etar')
    
end

