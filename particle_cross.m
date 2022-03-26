function c = particle_cross(del,pbest,gbest,w,c1,c2)
    s = sum([w,c1,c2]);
    param = [w,c1,c2] / s;
    p = find(rand < cumsum(param),1);
    parent1 = del;
    switch p
        case 1
            parent2 = del(end:-1:1);
        case 2
            parent2 = pbest;
        case 3
            parent2 = gbest;
    end
    n = length(del);
    c = zeros(1,n);
    from = randi(n);
    to = randi([from, n]);
    c(from:to) = parent1(from:to);
    for i = 1:n
        if ismember(parent2(i), c)
            parent2(i) = 0;
        end
    end
    parent2(parent2 == 0) = [];
    n2 = length(parent2);
    if from ~= 1
       c(1:from-1) = parent2(1:from-1); 
    end
    if to ~= n
       c(to+1:n) = parent2(from:n2);       
    end
end