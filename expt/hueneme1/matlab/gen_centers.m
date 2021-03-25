clear all
close all

xdim = 100;
ydim = 100;
xlim = [-119.27 -119.21];
ylim = [34.03 34.08];
dx = abs((xlim(2)-xlim(1))/xdim);
dy = abs((ylim(2) - ylim(1))/ydim);
x = linspace(xlim(1),xlim(2),xdim);
y = linspace(ylim(1),ylim(2),ydim);


[X,Y] = meshgrid(x,y);


%RBF width
eps = 300;

%least squares regularization parameter
lambda = 10;

%keeper centers
num_keepers = 30;

%choose halton nodes and locate them
num_centers = 400;
ppp = haltonset(2,'Skip',3000);% randi(5000));
ppp = scramble(ppp,'RR2');
centers = net(ppp,num_centers);
centers(:,1) = xlim(1) + (xlim(2)-xlim(1))*centers(:,1);
centers(:,2) = ylim(1) + (ylim(2)-ylim(1))*centers(:,2);

% calculate the RBF matrix
RBF = zeros(length(x)*length(y),num_centers);
for j = 1:num_centers
    rbf = phi_gauss2(x,y,eps,centers(j,1),centers(j,2));
    RBF(:,j) = rbf(:);
end

%Let's get a RHS
f = f_mean(x,y);
lambda2 = .1;
%Let's do some regularization
RBF_reg = [RBF ; sqrt(lambda)*eye(num_centers) ; lambda2*sum(RBF)];
f2 = [f(:); zeros(num_centers,1) ; 0];

%solve for weights (regularized and not)
%weights_0 = RBF\f(:);
weights_1 = RBF_reg\f2;

% approx = zeros(size(X));
% for j = 1:num_centers
%     approx = approx + weights_0(j)*phi_gauss2(x,y,eps,centers(j,1),centers(j,2));
% end
approx_reg = zeros(size(X));
for j = 1:num_centers
    approx_reg = approx_reg + weights_1(j)*phi_gauss2(x,y,eps,centers(j,1),centers(j,2));
end
fprintf('With %d evenly distributed Halton nodes:\n',num_centers)
%fprintf('l2 error ordinary least squares: %f\n',norm(f-approx));
fprintf('relative l2 error regularized least squares: %f\n',norm(f-approx_reg)/norm(f));

%Cut down the number of nodes
%get the sorted weights
[val,ind] = sort(abs(weights_1),'descend');
%[val2,ind2] = sort(abs(weights_0),'descend');
% figure(101)
% 
%plot em
figure
plot(sort(weights_1,'descend'),'-o');
title('Reg LS Weights');
% 
% figure
% plot(val2,'-o');
% title('OLS Weights');

%plot the centers and the keepers
figure
%subplot(1,2,1)
plot(centers(:,1),centers(:,2),'o')
hold on
plot(centers(ind(1:num_keepers),1),centers(ind(1:num_keepers),2),'o','MarkerFaceColor','red')
title(['Reg LS Largest ' num2str(num_keepers) ' weighted centers']);
contour(X,Y,f);



% %plot the centers on the RHS function
% figure
% plot3(centers(ind(1:num_keepers),1),centers(ind(1:num_keepers),2),f_mean(centers(ind(1:num_keepers),1),centers(ind(1:num_keepers),2)),'*m','MarkerFaceColor','red')
% hold on
% surf(X,Y,f)

%Cutting down to just the keepers
RBF2 = zeros(length(x)*length(y),num_keepers);
for j = 1:num_keepers
    rbf = phi_gauss2(x,y,eps,centers(ind(j),1),centers(ind(j),2));
    RBF2(:,j) = rbf(:);
end


%re-calc weights for the best approximation
%also, constrain so that total mass is zero
f2 = f(:);
RBF2 = [RBF2 ; lambda2*sum(RBF2)];
f2 = [f(:) ; 0];
weights_new = RBF2\f2;




approx_2 = zeros(size(X));
for j = 1:num_keepers
    approx_2 = approx_2 + weights_new(j)*phi_gauss2(x,y,eps,centers(ind(j),1),centers(ind(j),2));
end

fprintf('\nrelative l2 error re-calculated OLS on keeper centers: %f\n\n',norm(f-approx_2)/norm(f));

figure
surf(X,Y,approx_2)
%zlim([-.1 1.6])/norm(f)

figure
surf(X,Y,f_mean(x,y))
%zlim([-.1 1.6])

figure
surf(X,Y,(f_mean(x,y)-approx_2))




%save the centers
dlmwrite('centers.csv',centers(ind(1:num_keepers),:),'delimiter',',','precision',9)
dlmwrite('weights.csv',weights_new,'delimiter',',','precision',9)