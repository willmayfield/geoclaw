clear all
close all

xdim = 50;
ydim = 50;
xlim = [-119.255 -119.225];
ylim = [34.045 34.075];
dx = abs((xlim(2)-xlim(1))/xdim);
dy = abs((ylim(2) - ylim(1))/ydim);
x = linspace(xlim(1),xlim(2),xdim);
y = linspace(ylim(1),ylim(2),ydim);

[X,Y] = meshgrid(x,y);

contourf(X,Y,f_mean3(x,y),12)%,'edgecolor','interp','facecolor','interp')
colormap jet
xlabel('lon')
ylabel('lat')
zlabel('\eta (m)')


print(gcf, 'landslide3.pdf', '-dpdf', '-fillpage')