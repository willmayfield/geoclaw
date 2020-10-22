dim = 6;
time = 0:3:1794;

for gfi = 1:dim
gf_i = gfi - 1;
for gfj = 1:dim 
gf_j = gfj - 1;


gaugeno = [1];
num_gauges = size(gaugeno,2);
for j=1:num_gauges
    
    datafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/data_g' num2str(gaugeno(j),'%02d') '_i' num2str(gf_i) '_j' num2str(gf_j) '.mat'];
    load(datafilename)
    
    refdatafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/ref_data_g' num2str(gaugeno(j),'%02d') '.mat'];
    load(refdatafilename)
   
    %create timeseries
    ugts = timeseries(u_g, t_g);
    vgts = timeseries(v_g, t_g);
    etagts = timeseries(eta_g, t_g);
    
    ugts_out = resample(ugts, time);
    vgts_out = resample(vgts, time);
    etagts_out = resample(etagts, time);
    
%     uts = timeseries(u, t);
%     vts = timeseries(v, t);
%     etats = timeseries(eta, t);
%     
%     uts_out = resample(uts, time);
%     vts_out = resample(vts, time);
%     etats_out = resample(etats, time);    
    
%     figure
%     plot((1:3:1800)',etagts_out.Data - etats_out.Data)
%     hold on
   % plot(t_g,u_g - u(1:1545))
   % plot(t(1:1545),u_g - u(1:1545))
%     

    figure
    plot(etagts_out)
    hold on
    plot(t_g,eta_g)
    figure
    plot(etats_out)
    hold on
    plot(t,eta)
    legend
    

    ug = ugts_out.Data - ur;
    vg = vgts_out.Data - vr;
    etag = etagts_out.Data - etar;
    
%     ur = uts_out.Data;
%     vr = vts_out.Data;
%     etar = etats_out.Data;

    datafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/p_data_g' num2str(gaugeno(j),'%02d') '_i' num2str(gf_i) '_j' num2str(gf_j) '.mat'];
    save(datafilename,'time','ug','vg','etag')
%    refdatafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/ref_data_g' num2str(gaugeno(j),'%02d') '.mat'];
%    save(refdatafilename,'time','ur','vr','etar')

end

end
end