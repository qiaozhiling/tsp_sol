function x = genetic_mutate(x)
    n = length(x);
    a = randi(n);
    b = randi(n);
    x([a b]) = x([b a]);
end