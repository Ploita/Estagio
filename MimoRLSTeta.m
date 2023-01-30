% Favor não rodar tudo de uma única vez

figure
for i = 1:2
    for j = 1:4
        subplot(4,2,2*(j-1)+i)
        plot(track(j,:,i))
        title("\theta_{" + j + "} of y_" + i)
    end
end
saveas(gcf,"teta.jpg")