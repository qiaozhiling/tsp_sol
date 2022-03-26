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
iter_max = 200; % 迭代最大次数
m = round(n/2); % 蚂蚁数量
alpha = 1; % 信息素重要程度因子
beta = 4; % 启发函数重要程度因子
rho = 0.5; % 信息素挥发因子

shortest_r = zeros(1,n); % 最终路径
shortest_i = zeros(1,iter_max); % 每轮迭代最小路径
shortest = Inf; % 最终路径长度
Q = 1; % 信息素释放总量
theta = 1./D; % 启发函数 距离决定的
tau = ones(n,n); % 信息素矩阵
table = zeros(m,n); % 路径记录表

% 开始蚁
for i = 1:iter_max
    table(:,1) = randi([1,n],m,1); % 随机设置每只的出发点
    citys_index = 1:n; % 构建解空间
    for j = 1:m % 每只蚂蚁
        for k = 2:n % 除起始点外的每个点
            forbidden = table(j, 1:k-1); % 已访问点 
            this = forbidden(end); % 本次在的点
            allow = X(3,:); 
            allow(forbidden) = []; % 可访问的点
            p = zeros(1,length(allow));
            p = tau(this, allow) .^ alpha .* theta(this, allow) .^beta;
            p = p/sum(p); % 转移概率
            
            % 轮盘赌法选择下一个访问城市
            pc = cumsum(p);
            p_target = rand;
            target = find(pc >= p_target, 1);
            table(j,k) = allow(target);
        end
    end
    
    % 计算各个蚂蚁的总路径长度
    len = zeros(m,1);
    for j = 1:m
        r = table(j,:);
        len(j) = rouat_distance(r,D);
%         for k = 1:n-1
%             len(j) = len(j) + D(r(k), r(k+1));
%         end
%         len(j) = len(j) + D(r(end), r(1));
    end
    
    % 计算保存最小路径
    if shortest > min(len)
        shortest = min(len);
        shortest_index = find(len == shortest);
        shortest_r = table(shortest_index, :);
    end
    shortest_i(i) = shortest;
    % 更新信息素
    delta_tau = zeros(n,n);
    % 逐个蚂蚁计算
    for j = 1:m
        for k = 1:n-1
            from = table(j,k);
            to = table(j,k+1);
            delta_tau(from, to) = delta_tau(from, to) + Q/len(j);
        end
    end
    tau = (1 - rho) * tau + delta_tau;
    table = zeros(m,n); % 清空路径表
    
    if ~mod(i,10)
        fprintf('iterations %d\n', i);
    end
    
    % 动态画图
%     pause(0.001);
%     clf;
%     plot_tsp(shortest_r,shortest,X,'Ant',0);
end
fprintf('end');

% 画图
tsp_plot(shortest_r,shortest,X,'Ant',1);

% figure;
% G = graph(D);
% h = plot(G);
% s = zeros(1,n);
% t = zeros(1,n);
% for i = 1:n-1
%     s(i) = shortest_r(i);
%     t(i) = shortest_r(i+1);
% end
% s(n) = shortest_r(n);
% t(n) = shortest_r(1);
% shortest_G = graph(s,t);
% highlight(h, shortest_G);

% figure;
% hold on;
% for i = 1:n
%     scatter(X(1,i), X(2,i), 'rx');
%     text(X(1,i)+0.05, X(2,i),num2str(X(3,i)));
% end
% for i = 1:n-1
%     from = shortest_r(i);
%     to = shortest_r(i+1);
%     plot([X(1,from),X(1,to)], [X(2,from),X(2,to)],'b');
% end
% from = shortest_r(end);
% to = shortest_r(1);
% plot([X(1,from),X(1,to)], [X(2,from),X(2,to)],'b');
% title(['Ant shortest :' num2str(shortest)]);
% hold off;