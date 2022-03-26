function D = ant_dist(x)
    % ªÒ»°¡⁄Ω”æÿ’Û
    n = length(x);
    D = zeros(n,n);
    for i = 1:n
        for j = 1:n
            D(i,j) = sqrt((x(1,i)-x(1,j))^2  + (x(2,i)-x(2,j))^2);
        end
    end
end