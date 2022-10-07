%Gráficos de Validação
rho = 1;
lim_inf = 1;
lim_sup = N;

figure
subplot(2,1,1)
plot(lim_inf:lim_sup,out_val(lim_inf:lim_sup)-y_hat(rho,lim_inf:lim_sup,1))
title('Sinal diferença')

subplot(2,1,2)
pp = plot(lim_inf:lim_sup,out_val(lim_inf:lim_sup),lim_inf:lim_sup,y_hat(rho,lim_inf:lim_sup,1));
pp(1).Color = 'b';
pp(2).Color = 'r';
title('Saída Real x Saída predita')
sgtitle('Validação - y_1')

figure
sgtitle('Evolução da taxa RMSE')
plot(0:100,[0; RMSE(1:100,1)])
xlabel("\rho passos à frente")
ylabel("RMSE")

figure
subplot(2,1,1)
plot(lim_inf:lim_sup,out_val(lim_inf:lim_sup)-y_hat(rho,lim_inf:lim_sup,2))
title('Sinal diferença')

subplot(2,1,2)
pp = plot(lim_inf:lim_sup,out_val(lim_inf:lim_sup),lim_inf:lim_sup,y_hat(rho,lim_inf:lim_sup,2));
pp(1).Color = 'b';
pp(2).Color = 'r';
title('Saída Real x Saída predita')
sgtitle('Validação - y_2')

figure
sgtitle('Evolução da taxa RMSE')
plot(0:100,[0; RMSE(1:100,2)])
xlabel("\rho passos à frente")
ylabel("RMSE")
