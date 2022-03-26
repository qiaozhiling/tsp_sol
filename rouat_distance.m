function d = tsp_distance(rouats,D)
    % 计算路径长度 
    [m,n] = size(rouats);
    d = zeros(m,1);
    for j = 1:m
        for i = 1:n-1
            d(j) = d(j) + D(rouats(j,i),rouats(j,i+1));
        end
        d(j) = d(j) + D(rouats(j,n),rouats(j,1));        
    end
end