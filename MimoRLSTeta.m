% Favor não rodar tudo de uma única vez

for i = 1
    for j = 1:15
        figure
        plot(track(j,:,i))
        title("\theta_{" + j + "} of y_" + i)
    end
end
