dim = 6;
time = 0:3:1797;

gaugeno = [5 6 7];
num_gauges = size(gaugeno,2);
for j=1:num_gauges
    
    refdatafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/ref_data_g' num2str(gaugeno(j),'%02d') '.mat'];
    load(refdatafilename)
   
    
    uts = timeseries(u, t);
    vts = timeseries(v, t);
    etats = timeseries(eta, t);
    
    uts_out = resample(uts, time);
    vts_out = resample(vts, time);
    etats_out = resample(etats, time);    
    
%     figure
%     plot((1:3:1800)',etagts_out.Data - etats_out.Data)
%     hold on
   % plot(t_g,u_g - u(1:1545))
   % plot(t(1:1545),u_g - u(1:1545))
    
    plot(etagts_out)
    plot(t_g,eta_g)
    plot(etats_out)
    plot(t,eta)
    legend
    

    ug = ugts_out.Data - uts_out.Data;
    vg = vgts_out.Data - vts_out.Data;
    etag = etagts_out.Data - etats_out.Data;
    
    ur = uts_out.Data;
    vr = vts_out.Data;
    etar = etats_out.Data;


    save(datafilename,'time','ug','vg','etag')
    refdatafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/GF_DATA_' num2str(dim) '/ref_data_g' num2str(gaugeno(j),'%02d') '.mat'];
    save(refdatafilename,'time','ur','vr','etar')

end

end
end