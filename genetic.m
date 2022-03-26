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
iter_max = 800; % ����������
iter = 10; % ÿ�����ܴ���
m = 15; % ��Ⱥ��С
pc = 0.5; % ��������
pm = 0.7; % ��������

shortest_r = zeros(1,n); % ����·��
shortest_i = zeros(1,iter_max); % ÿ�ֵ�����С·��
shortest = 0; % ����·������

group = zeros(m,n);
for i = 1:m
    group(i,:) = randperm(n);
end

pk = cumsum([pc,pm]) / sum([pc,pm]);
for i = 1:iter_max
    next = group;
    for j = m+1:m+iter
        % ���̶ľ����ǽ��滹�Ǳ���
        p = find(rand < pk, 1);
        if p == 1
            % ����
            a = randi(m);
            b = randi(m);
            [x,y]= genetic_cross(group(a,:), group(b,:));
            next(end + 1,:) = x;
            next(end + 1,:) = y;
        elseif p == 2
            % ����
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
% ��ͼ
tsp_plot(shortest_r,shortest,X,'genetic',1);