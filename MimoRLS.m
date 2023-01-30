%% RLS
teta_model = 0.01*ones(M,r);
track = zeros (M,N,r);
% Ajustar para varrer r por N, ao invés de N por r

for j = 1:r
erro = zeros(N,r);
P = 10^3*eye(M);
    for i = 3:N
        %Cálculo do erro
        yhat = p(i,:)*teta_model(:,j);
        erro(i,j) = output(i,j) - yhat;
        
        %Atualização do ganho
        ganho = (P*p(i,:)')/(1 + p(i,:)*P*p(i,:)');
        %Atualização de teta
        teta_model(:,j) = teta_model(:,j) + ganho*erro(i,j);
        %Atualização de P
        P = P - ganho*(1 + p(i,:)*P*p(i,:)')*(ganho');
        track(:,i,j)  = teta_model(:,j);
    end
    mat(:,:,j) = p;
    par(:,j) = teta_model(:,j);
    indice(:,j) = (1:M)';
end

M_linha = M;
