close all
clear all
time = 1:1700;

gaugeno = [5 6 7];
num_gauges = size(gaugeno,2);
l2_error_eta = zeros(1,4);
l2_error_speed = zeros(1,4);
num_gfs = [10 50 200 800];



for j = 1:num_gauges
    
        meshlvl = 5;
    
        datafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/matlab/data_g' num2str(gaugeno(j),'%02d') '_l' num2str(meshlvl,'%02d') '.mat'];
        load(datafilename)
        
        figure(num_gauges*j + 0) 
        hold on
        plot(t,sqrt(u.^2 + v.^2));
        hold on
        title(['Gauge ' num2str(gaugeno(j)) ' speed'])
        legend(['level ' num2str(meshlvl)]) 
        figure(num_gauges*j + 1)        
        hold on
        plot(t,eta);
        hold on
        plot(t,zeros(size(t)),'-k')
        title(['Gauge ' num2str(gaugeno(j)) ' elevation'])
        legend(['level ' num2str(meshlvl)]) 
        
        
        speedts = timeseries(sqrt(u.^2 + v.^2), t);
        etats = timeseries(eta, t);
    
        speedts_out = resample(speedts, time);
        etats_out = resample(etats, time);   
        
        
        
        %same the best one (3600 GFs)
        best_eta = etats_out.Data;
        best_speed = speedts_out.Data;
        

    for meshlvl = 1:4

        datafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme/matlab/data_g' num2str(gaugeno(j),'%02d') '_l' num2str(meshlvl,'%02d') '.mat'];
        load(datafilename)
        
        figure(num_gauges*j + 0) 
        hold on
        plot(t,sqrt(u.^2 + v.^2));
        hold on
        title(['Gauge ' num2str(gaugeno(j)) ' speed'])
        legend(['level ' num2str(meshlvl)]) 
        figure(num_gauges*j + 1)        
        hold on
        plot(t,eta);
        hold on
        plot(t,zeros(size(t)),'-k')
        title(['Gauge ' num2str(gaugeno(j)) ' elevation'])
        legend(['level ' num2str(meshlvl)]) 
        
        speedts = timeseries(sqrt(u.^2 + v.^2), t);
        etats = timeseries(eta, t);
       % t(end)
    
        speedts_out = resample(speedts, time);
        etats_out = resample(etats, time);   
        
        l2_error_eta(meshlvl) = norm(best_eta - etats_out.Data);
        l2_error_speed(meshlvl) = norm(best_speed - speedts_out.Data);


    end
    
    figure(666) 
    hold on
    plot(num_gfs, l2_error_eta)
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    grid on
    l2_error_eta
    
    figure(667) 
    hold on
    semilogx(num_gfs, l2_error_speed)
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    grid on
 
    
    
end
