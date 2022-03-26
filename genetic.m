%% 每个点都是相互可达的
clear;clc;
n = 20;
X = zeros(3,n);
% X = [1 5 2 6 4 9 5 7 1 7 12; 7 5 2 1 6 8 9 1 5 3 5; 1 2 3 4 5 6 7 8 9 10 11];

for i =1:n
    X(1,i) = abs(randn(1,1)) * 5;
    X(2,i) = abs(randn(1,1)) * 5;    
    X(3,i) = i;
end

D = ant_dist(X); % 临接矩阵

%%
% 超参数
iter_max = 800; % 最大迭代次数
iter = 10; % 每代繁衍次数
m = 15; % 种群大小
pc = 0.5; % 交叉因子
pm = 0.7; % 变异因子

shortest_r = zeros(1,n); % 最终路径
shortest_i = zeros(1,iter_max); % 每轮迭代最小路径
shortest = 0; % 最终路径长度

group = zeros(m,n);
for i = 1:m
    group(i,:) = randperm(n);
end

pk = cumsum([pc,pm]) / sum([pc,pm]);
for i = 1:iter_max
    next = group;
    for j = m+1:m+iter
        % 轮盘赌决定是交叉还是变异
        p = find(rand < pk, 1);
        if p == 1
            % 交叉
            a = randi(m);
            b = randi(m);
            [x,y]= genetic_cross(group(a,:), group(b,:));
            next(end + 1,:) = x;
            next(end + 1,:) = y;
        elseif p == 2
            % 变异
            a = randi(m);
            next(end + 1,:) = genetic_mutate(group(a,:));
        end
    end
    
    next = unique(next,'rows');
    len = rouat_distance(next,D);
    s = sort(len);
    ins = find(len <= s(m), m);
    group = next(ins,:);
    
    if ~mod(i,10)
        fprintf('iterations %d\n', i);
    end
    shortest_i(i) = s(1);
end

len = rouat_distance(group,D);
s = sort(len);
index = find(len == s(1), 1);
shortest_r(1,:) = group(index,:);
shortest = s(1);
% 画图
tsp_plot(shortest_r,shortest,X,'genetic',1);