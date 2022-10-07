%Validação Simulação rho passos à frente
RMSE = zeros(N-n,r);
p_1 = zeros(N,M);
y_cha = zeros(N,N,r); 
%\hat{y} sendo a resposta estimada pela previsão
%Para cada atraso a matriz de y_cha recebe uma coluna de out_val
%Um mero ajuste pra facilitar a implementação

for k = 1:r
    for i = 1:n
        for j = i:N
            y_cha(i,j,k) = out_val(j,k);
        end
    end
end

%%
for k4 = 1:r
    for i = n+1:N
        for j = i:N
            pos = 1;
            for k0 = 1:r
                for k1 = 1:n
                    p_1(j,pos) = y_cha(i-k1,j-k1,k0);
                    pos = pos+1;
                end
            end
            
            for k0 = 1:r
                for k1 = 1:n
                    p_1(j,pos) = inp_val(j-k1,k0);
                    pos = pos+1;
                end
            end
            
            for k0 = 1:r
                for k1 = 1:n
                    p_1(j,pos) = erro(j-k1,k0);
                    pos = pos+1;
                end
            end
            
            %Matriz de regressão (2ª ordem)
            for k1 = 1:3*n*r
                for k2 = k1:3*n*r
                    p_1(j,pos) = p_1(j,k1)*p_1(j,k2);
                    pos = pos +1;
                end
            end
        end
        
        p_lin = zeros(N,M_linha);
        
        for j = 1:M_linha
            p_lin(:,j) = p_1(:,indice(j,k4));
        end
        
        if k4 == 1
            for j = i:N
                y_cha(i,j,k4) = p_lin(j,:)*par_y1;
            end
        else
            for j = i:N
                y_cha(i,j,k4) = p_lin(j,:)*par_y2;
            end
        end
        
    end
end


%%
for i =1:r
    y_hat(:,:,i) = y_cha(n+1:N,:,i);
end
% Cálculo do RMSE por rho passos tomados
for j = 1:r
    RMSE(:,j) = sqrt(sum(power(out_val(:,j) - y_hat(:,:,j)',2))/N);
end



clear i j k1 k2 k3 pos k k0 k4 p_1  