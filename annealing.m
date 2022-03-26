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
shortest_r = randperm(n); % ����·��
shortest = Inf; % ����·������
shortest_i = zeros(1,0); % ÿ�ֵ�����С·��

% ������
kT = 1e6; % ��ʼ�¶�
ekT = 1e-5; % �����¶�
rateT = 3e-4; % �¶��½���
iter_l = 5; % ��������
iter_c = 1; % ��������

while kT > ekT
    for j = 1:iter_l
        % �����ѡ�����㽻��
        a = randi(n); 
        b = randi(n);
        new_answer = shortest_r;
        new_answer([a b]) = new_answer([b a]);
        new_len = rouat_distance(new_answer, D); 
        delta_e =  shortest - new_len;
        if delta_e > 0
            shortest_r = new_answer;
            shortest = new_len;
        else
            pk = exp(delta_e / kT); 
            if rand < pk 
                shortest_r = new_answer;
                shortest = new_len;
            end
        end
    end
    shortest_i(end + 1) = shortest;
    kT = kT * (1-rateT);
    
    
    if ~mod(iter_c,10)
        fprintf('iterations %d\n', iter_c);
    end
    iter_c = iter_c + 1;
    
    % ��̬��ͼ
%     pause(0.001);
%     clf;
%     plot_tsp(shortest_r,shortest,X,'Annealing',0);
end

tsp_plot(shortest_r,shortest,X,'Annealing',1);