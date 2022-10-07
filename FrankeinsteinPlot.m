%% Gráficos de treino

for i = 1:r
    figure
    subplot(2,1,1)
    plot(output(:,1) - mat(:,:,i)*par(:,i))
    title('Sinal diferença')
    
    subplot(2,1,2)
    pp = plot(1:N,output(:,1), 1:N,mat(:,:,i)*par(:,i));
    pp(1).Color = 'b';
    pp(2).Color = 'r';
    title('Saída Real x Saída predita')
    sgtitle("Treino - y_" + i)
end

%% Gráfico de validação

rho = 1;

for i = 1:r
    figure
    subplot(2,1,1)
    plot(out_val(:,i)-y_hat(rho,:,i)')
    title('Sinal diferença')
    
    subplot(2,1,2)
    pp = plot(1:N,out_val(:,i),1:N,y_hat(rho,:,i)');
    pp(1).Color = 'b';
    pp(2).Color = 'r';
    title('Saída Real x Saída predita')
    sgtitle("Validação - y_" + i)
end