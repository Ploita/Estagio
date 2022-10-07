%Gráficos de treino
lim_inf = 1;
lim_sup = N;

figure
subplot(2,1,1)
plot(output(lim_inf:lim_sup,1) - mat_y1*par_y1)
title('Sinal diferença')

subplot(2,1,2)
pp = plot(lim_inf:lim_sup,output(lim_inf:lim_sup,1),lim_inf:lim_sup,mat_y1*par_y1);
pp(1).Color = 'b';
pp(2).Color = 'r';
title('Saída Real x Saída predita')
sgtitle("Treino - y_1")

figure
subplot(2,1,1)
plot(output(lim_inf:lim_sup,2) - mat_y2*par_y2)
title('Sinal diferença')

subplot(2,1,2)
pp = plot(lim_inf:lim_sup,output(lim_inf:lim_sup,2),lim_inf:lim_sup,mat_y2*par_y2);
pp(1).Color = 'b';
pp(2).Color = 'r';
title('Saída Real x Saída predita')
sgtitle("Treino - y_2")


clear pp