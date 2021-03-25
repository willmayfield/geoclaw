meshlvl = 5;

gaugeno = [5 6 7];
num_gauges = 3;


for j = 1:num_gauges
    
    datafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/matlab/data_g' num2str(gaugeno(j),'%02d') '_l' num2str(meshlvl,'%02d') '.mat'];
    load(datafilename)
    
    filename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/_output/gauge000' num2str(gaugeno(j),'%02d') '.txt'];
    startRow = 3;
    formatSpec = '%*5s%15f%*15f%15f%15f%f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    gaugedata = [dataArray{1:end-1}];
    clearvars filename startRow formatSpec fileID dataArray ans;


    %gaugedataformat is [time, u,v,eta]
    
    
    t = gaugedata(:,1);
    u = gaugedata(:,2);
    v = gaugedata(:,3);
    eta = gaugedata(:,4);
    
    save(datafilename,'t','u','v','eta')
    
end
