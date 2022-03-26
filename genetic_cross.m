function [x,y] = genetic_cross(a,b)
    n = length(a);
    x = zeros(1,n);
    y = zeros(1,n);
    p = randi(n);
    x(1:p) = a(1:p);
    y(1:p) = b(1:p);
    
    for i = 1:n
        if ismember(a(i), y)
            a(i) = 0;
        end
    end
    a(a == 0) = [];
    for i = 1:n
        if ismember(b(i), x)
            b(i) = 0;
        end
    end
    b(b == 0) = [];
    x(p + 1 : n) = b(1:n-p);
    y(p + 1 : n) = a(1:n-p);
end