close all
clear all
time = 1:1700;

gaugeno = [5 6 7];
num_gauges = size(gaugeno,2);
l2_error_eta = zeros(1,4);
l2_error_speed = zeros(1,4);
num_gfs = [10 50 200 800];



for j = 2:2
    
        meshlvl = 5;
    
        datafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme_ic_courseness/matlab/data_g' num2str(gaugeno(j),'%02d') '_l' num2str(meshlvl,'%02d') '.mat'];
        load(datafilename)
        
        figure(1)
        subplot(3,1,j)
        hold on
        plot(t,sqrt(u.^2 + v.^2),'DisplayName','level 5');
        hold on
        
        figure(2)
%        subplot(3,1,j)
        hold on
        plot(t,eta,'DisplayName','level 5');
        hold on
        
        
        speedts = timeseries(sqrt(u.^2 + v.^2), t);
        etats = timeseries(eta, t);
    
        speedts_out = resample(speedts, time);
        etats_out = resample(etats, time);   
        
        
        
        %save the best one (3600 GFs)
        best_eta = etats_out.Data;
        best_speed = speedts_out.Data;
        

    for meshlvl = 4:-1:1

        datafilename = ['/home/will/clawpack_src/clawpack-v5.4.1/geoclaw/examples/tsunami/hueneme_ic_courseness/matlab/data_g' num2str(gaugeno(j),'%02d') '_l' num2str(meshlvl,'%02d') '.mat'];
        load(datafilename)
        
        figure(1)
        subplot(3,1,j)
        hold on
        plot(t,sqrt(u.^2 + v.^2),'DisplayName',['level ' num2str(meshlvl)]);
        hold on
        ylabel(['Gauge ' num2str(gaugeno(j)) ' speed (m/s)'])
        if gaugeno(j) == 5
            title('Speed for various IC mesh level')
        end
        if gaugeno(j) == 7
             xlabel('time (s)')
        end
        if gaugeno(j) == 6
            legend('off')
            legend('show')        
        end
        
        figure(2)
%        subplot(3,1,j)
        hold on
        plot(t,eta,'DisplayName',['level ' num2str(meshlvl)]);
        hold on
        ylabel(['Gauge ' num2str(gaugeno(j)) ' eta (m)'])
%        if gaugeno(j) == 5
            title('Elevation for various IC mesh level')
%        end
%        if gaugeno(j) == 7
             xlabel('time (s)')
%        end
%        if gaugeno(j) == 6
            legend('off')
            legend('show')        
%        end
        
        speedts = timeseries(sqrt(u.^2 + v.^2), t);
        etats = timeseries(eta, t);
       % t(end)
    
        speedts_out = resample(speedts, time);
        etats_out = resample(etats, time);   
        
        l2_error_eta(meshlvl) = norm(best_eta - etats_out.Data);
        l2_error_speed(meshlvl) = norm(best_speed - speedts_out.Data);


    end
    
    
    figure(2)
 %   subplot(3,1,j)
    plot(t,zeros(size(t)),'-k','DisplayName','zero line');
%    legend('off')
%    legend('show')       
    
    
    figure(666)

%     subplot(2,1,1)    
    title('l2 Errors compared to level 5')
    hold on
    plot(num_gfs, l2_error_eta,'-s','DisplayName',['gauge ' num2str(gaugeno(j))])
%    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    ylabel('eta l2 error')
    if gaugeno(j) == 7
        labels = {'level 1','level 2','level 3','level4'};
        text(num_gfs, l2_error_eta,labels,'VerticalAlignment','bottom','HorizontalAlignment','left')
    end
    legend('off')
    legend('show')  
    grid on
    
%     subplot(2,1,2)
%     hold on
%     plot(num_gfs, l2_error_speed,'-o')
%     ylabel('speed l2 error')
%     xlabel('Number of Greens Functions')
%     if gaugeno(j) == 7
%         labels = {'level 1','level 2','level 3','level4'};
%         text(num_gfs, l2_error_speed,labels,'VerticalAlignment','bottom','HorizontalAlignment','left')
%     end
%     %    set(gca, 'XScale', 'log')
%     set(gca, 'YScale', 'log')
%     grid on

    
    
end
