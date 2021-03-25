clear all
close all
nodes = 1:100;
figure

all_nodes = [];
for jjj = 1:100
%for eps = 200:10:600
    
num_keepers = nodes(jjj);

xdim = 50;
ydim = 50;
xlim = [-119.27 -119.21];
ylim = [34.03 34.08];
dx = abs((xlim(2)-xlim(1))/xdim);
dy = abs((ylim(2) - ylim(1))/ydim);
x = linspace(xlim(1),xlim(2),xdim);
y = linspace(ylim(1),ylim(2),ydim);


[X,Y] = meshgrid(x,y);


%RBF width
eps = 470;

%least squares regularization parameter
%lambda = 10;

%keeper centers
%num_keepers = 10;

%choose halton nodes and locate them
num_centers = 500;
ppp = haltonset(2,'Skip',3700);% randi(5000));% % % % % % figure
% % % % % % plot(sort(weights_1,'descend'),'-o');
% % % % % % title('Reg LS Weights');
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
f = f_mean2(x,y);
f2 = f(:);

%Let's do some regularization
[W, info]  = lasso(RBF,f2,'DFmax',num_keepers);
weights_1 = W(:,1);

% approx = zeros(size(X));
% for j = 1:num_centers
%     approx = approx + weights_0(j)*phi_gauss2(x,y,eps,centers(j,1),centers(j,2));
% end
approx_reg = zeros(size(X));
for j = 1:num_centers
    approx_reg = approx_reg + weights_1(j)*phi_gauss2(x,y,eps,centers(j,1),centers(j,2));
end
% fprintf('With %d evenly distributed Halton nodes:\n',num_centers)
% %fprintf('l2 error ordinary least squares: %f\n',norm(f-approx));
% fprintf('relative l2 error regularized least squares: %f\n',norm(f-approx_reg)/norm(f));

%Cut down the number of nodes
%get the sorted weights
[val,ind] = sort(abs(weights_1),'descend');
%[val2,ind2] = sort(abs(weights_0),'descend');
% figure(101)
% 
%plot em
% % % % % % figure
% % % % % % plot(sort(weights_1,'descend'),'-o');
% % % % % % title('Reg LS Weights');
% 
% figure
% plot(val2,'-o');
% title('OLS Weights');

titles = ['(a)', '(b)', '(c)' , '(d)'];

%plot the centers and the keepers

%subplot(2,2,jjj)
% plot(centers(:,1),centers(:,2),'o')
% hold on
% contour(X,Y,f,11,'linewidth',1.5);
% plot(centers(ind(1:num_keepers),1),centers(ind(1:num_keepers),2),'o','MarkerFaceColor','red')
%title(['Reg LS Largest ' num2str(num_keepers) ' weighted centers']);
%title(titles(jjj))




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
lambda2=.1;
f2 = f(:);
%RBF2 = [RBF2 ; lambda2*sum(RBF2)];
%f2 = [f(:) ; 0];
weights_new = RBF2\f2;




approx_2 = zeros(size(X));
for j = 1:num_keepers
    approx_2 = approx_2 + weights_new(j)*phi_gauss2(x,y,eps,centers(ind(j),1),centers(ind(j),2));
end

fprintf('\nrelative l2 error re-calculated OLS on keeper centers: %f, eps = %d\n\n',norm(f-approx_2)/norm(f), eps);
%fprintf('\nrelative l1 error re-calculated OLS on keeper centers: %f, eps = %d\n\n',norm(f-approx_2,1)/norm(f,1), eps);

all_nodes = [all_nodes ; ind(1:num_keepers)];
end

% figure
% surf(X,Y,approx_2)
% %zlim([-.1 1.6])/norm(f)
% 
% figure
% surf(X,Y,f_mean(x,y))
% %zlim([-.1 1.6])
% 
% figure
% surf(X,Y,(f_mean(x,y)-approx_2))
%end

all_nodes = unique(all_nodes,'stable');
all_nodes = all_nodes(1:100);

plot(centers(:,1),centers(:,2),'o')
hold on
contour(X,Y,f,11,'linewidth',1.5);
plot(centers(all_nodes(1:100),1),centers(all_nodes(1:100),2),'o','MarkerFaceColor','red')

for ii = 1:100
   fprintf('%f, %f, & \n', centers(all_nodes(ii),1),centers(all_nodes(ii),2));
end

centers_final = centers(all_nodes(1:100),:);

%save the centers
dlmwrite('centers.csv',centers(ind(1:num_keepers),:),'delimiter',',','precision',9)
dlmwrite('weights.csv',weights_new,'delimiter',',','precision',9)