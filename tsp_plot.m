function h = tsp_plot(rouat,dist,X,name,new)
    n = size(X,2);
    if new
        figure;
    end
    hold on;
    for i = 1:n
        scatter(X(1,i), X(2,i), 'rx');
        text(X(1,i)+0.05, X(2,i),num2str(X(3,i)));
    end
    for i = 1:n-1
        from = rouat(i);
        to = rouat(i+1);
        plot([X(1,from),X(1,to)], [X(2,from),X(2,to)],'b');
    end
    from = rouat(end);
    to = rouat(1);
    h = plot([X(1,from),X(1,to)], [X(2,from),X(2,to)],'b');
    title([name, ' shortest :', num2str(dist)]);
    hold off;
end