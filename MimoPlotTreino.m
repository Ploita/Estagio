%Gráficos de treino
for i = 1:r
    figure
    subplot(2,1,1)
    plot(output(:,i) - mat(:,:,i)*par(:,i))
    title('Sinal diferença')
    
    subplot(2,1,2)
    pp = plot(1:N,output(:,i), 1:N,mat(:,:,i)*par(:,i));
    pp(1).Color = 'b';
    pp(2).Color = 'r';
    title('Saída Real x Saída predita')
    sgtitle("Treino - y_" + i)
end
clear pp