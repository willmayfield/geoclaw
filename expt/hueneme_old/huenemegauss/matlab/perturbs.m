rng(2000)

for j = 1:100
    for jj = 1:8
        num = randn(1);
        fprintf([num2str(num) ', ']);
    end
    fprintf(' &\n');
end