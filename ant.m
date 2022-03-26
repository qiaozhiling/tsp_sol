%% ÿ���㶼���໥�ɴ��
clear;clc;
n = 20;
X = zeros(3,n);
% X = [1 5 2 6 4 9 5 7 1 7 12; 7 5 2 1 6 8 9 1 5 3 5; 1 2 3 4 5 6 7 8 9 10 11];

for i =1:n
    X(1,i) = abs(randn(1,1)) * 5;
    X(2,i) = abs(randn(1,1)) * 5;    
    X(3,i) = i;
end

D = ant_dist(X); % �ٽӾ���

%%
% ������
iter_max = 200; % ����������
m = round(n/2); % ��������
alpha = 1; % ��Ϣ����Ҫ�̶�����
beta = 4; % ����������Ҫ�̶�����
rho = 0.5; % ��Ϣ�ػӷ�����

shortest_r = zeros(1,n); % ����·��
shortest_i = zeros(1,iter_max); % ÿ�ֵ�����С·��
shortest = Inf; % ����·������
Q = 1; % ��Ϣ���ͷ�����
theta = 1./D; % �������� ���������
tau = ones(n,n); % ��Ϣ�ؾ���
table = zeros(m,n); % ·����¼��

% ��ʼ��
for i = 1:iter_max
    table(:,1) = randi([1,n],m,1); % �������ÿֻ�ĳ�����
    citys_index = 1:n; % ������ռ�
    for j = 1:m % ÿֻ����
        for k = 2:n % ����ʼ�����ÿ����
            forbidden = table(j, 1:k-1); % �ѷ��ʵ� 
            this = forbidden(end); % �����ڵĵ�
            allow = X(3,:); 
            allow(forbidden) = []; % �ɷ��ʵĵ�
            p = zeros(1,length(allow));
            p = tau(this, allow) .^ alpha .* theta(this, allow) .^beta;
            p = p/sum(p); % ת�Ƹ���
            
            % ���̶ķ�ѡ����һ�����ʳ���
            pc = cumsum(p);
            p_target = rand;
            target = find(pc >= p_target, 1);
            table(j,k) = allow(target);
        end
    end
    
    % ����������ϵ���·������
    len = zeros(m,1);
    for j = 1:m
        r = table(j,:);
        len(j) = rouat_distance(r,D);
%         for k = 1:n-1
%             len(j) = len(j) + D(r(k), r(k+1));
%         end
%         len(j) = len(j) + D(r(end), r(1));
    end
    
    % ���㱣����С·��
    if shortest > min(len)
        shortest = min(len);
        shortest_index = find(len == shortest);
        shortest_r = table(shortest_index, :);
    end
    shortest_i(i) = shortest;
    % ������Ϣ��
    delta_tau = zeros(n,n);
    % ������ϼ���
    for j = 1:m
        for k = 1:n-1
            from = table(j,k);
            to = table(j,k+1);
            delta_tau(from, to) = delta_tau(from, to) + Q/len(j);
        end
    end
    tau = (1 - rho) * tau + delta_tau;
    table = zeros(m,n); % ���·����
    
    if ~mod(i,10)
        fprintf('iterations %d\n', i);
    end
    
    % ��̬��ͼ
%     pause(0.001);
%     clf;
%     plot_tsp(shortest_r,shortest,X,'Ant',0);
end
fprintf('end');

% ��ͼ
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