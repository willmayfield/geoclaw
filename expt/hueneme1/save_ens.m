function save_ens(ensnum)
ensnum
dim = 30;
gaugeno = [1,7];
num_gauges = size(gaugeno,2);
for j=1:num_gauges
    
    %%%%IMPORT new data FROM GAUGE%%%
    filename = ['/home/math/mayfielw/clawpack_src/clawpack/geoclaw/examples/tsunami/hueneme1/_output/gauge000' num2str(gaugeno(j),'%02d') '.txt'];
    startRow = 3;
    formatSpec = '%*5s%15f%*15f%15f%15f%f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    gaugedata = [dataArray{1:end-1}];
    clearvars filename startRow formatSpec fileID dataArray ans;
    
    %gaugedataformat is [time,u,v,eta]
    t_g = gaugedata(:,1);
    u_g = gaugedata(:,2);
    v_g = gaugedata(:,3);
    eta_g = gaugedata(:,4);
    
%    refdatafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA/ref_data_g' num2str(gaugeno(j),'%02d') '.mat'];
%    load(refdatafilename)
    
%     size(t)
%     size(t_g)
%     t(1:1545)-t_g
%     plot(t(1:1545),eta_g - eta(1:1545),t_g,eta_g - eta(1:1545))
    
%     u = u_g - u;
%     v = v_g - v;
%     eta = eta_g - eta;

    datafilename = ['/home/math/mayfielw/clawpack_src/clawpack/geoclaw/examples/tsunami/hueneme1/ENS_DATA_' num2str(dim) '/data_g' num2str(gaugeno(j),'%02d') '_n' num2str(ensnum) '.mat'];
    save(datafilename,'t_g','u_g','v_g','eta_g')

end

end
