%% RLS

p = zeros(M,1);
erro = zeros(N,1);
teta_model = 0.01*ones(1,M);
a1 = zeros(N,1);
a2 = zeros(N,1);
b0 = zeros(N,1);
P = 10^3*eye(M);

for i = 3:N
    
    %Matriz de regressão
    p = [-output(i-1) -output(i-2) input(i-1)];
    
    %Cálculo do erro
    yhat = p*teta_model';
    erro(i) = output(i) - yhat;
    
    %Atualização do ganho
    ganho = (P*p')/(1 + p*P*p');
    %Atualização de teta
    teta_model = teta_model + ganho'*erro(i);
    %Atualização de P
    P = P - ganho*(1 + p*P*p')*(ganho');
    %Registro da evolução do teta
    a1(i) = teta_model(1);
    a2(i) = teta_model(2);
    b0(i) = teta_model(3);
    
end
%%
model = zeros(N,1);
y_cha = zeros(N,N);
p_1 = zeros(N,M);
RMSE = zeros(N,1);

for i = 1:ny
    for j = i:N
        y_cha(i,j) = out_val(j);
    end
end

for i = ny+1:N
    for j = i:N
        p_1(j,:) = [-y_cha(i-1,j-1) -y_cha(i-2,j-2) inp_val(j-1)];
        y_cha(i,j) = p_1(j,:)*teta_model';
    end
end
y_cha = y_cha(ny+1:N,:);

% Cálculo do RMSE por k passos tomados
for i = 1:N-ny
    RMSE(i) = sqrt(sum(power(out_val - y_cha(i,:)',2))/N);
end