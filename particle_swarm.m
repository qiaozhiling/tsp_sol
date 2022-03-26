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

%% ����Ⱥ + �Ŵ�
% ������
m = 50; % ���Ӹ���
c1 = 0.1; % ������֪����
c2 = 0.5; % �����֪����
w = 0.8; % ��������
iter_max = 500; % ��������

short_i = zeros(1,iter_max); % ÿ�ֵ�����С·��
pbest = zeros(m,n); % �����������Ž�
pbestV = 1./zeros(m,1); % ��������ֵ
gbest = zeros(1,n); % ȫ���������Ž�
gbestV = 0; % ȫ������ֵ

for i = 1:m
    pbest(i,:) = randperm(n);
end
bird = pbest; % ����
pbestV = rouat_distance(pbest,D);
[gbestV,index] = min(pbestV);
gbest = pbest(index,:);
for i = 1:iter_max
    dw = w * i / iter_max;
    for j = 1:m
        bird(j,:) = particle_cross(bird(j,:), pbest(j,:), gbest,dw, c1, c2);
        e = rouat_distance(bird(j,:),D);
        if e < pbestV(j)
            pbest(j,:) = bird(j,:);
            pbestV(j) = e;
        end
        if e < gbestV
            gbest = bird(j,:);
            gbestV = e;
        end
    end
    if mod(i,10) == 0
        fprintf('%d\n', i);
    end
    short_i(i) = gbestV;
end

tsp_plot(gbest,gbestV,X,'particle',1);