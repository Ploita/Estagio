clear
% Sinal APRBS
%% Dados para treino
N = 1000;   %Total de amostras
L = 2; %grau dos polimônios 
r = 2; %total de entradas/saídas
n = 2; %ordem da saída/entrada/ruído
M  = factorial(L+3*n*r)/(factorial(L)*factorial(3*n*r)); %Quantidade de termos para representar o problema
indice = zeros(M,r);    %Retorna os índices dos elementos mais impactantes

Th = 10;    %Hold time(tempo de atualização)
min_u = -.1;  %Amplitude mínima da entrada
max_u = .1;  %Amplitude máxima da entrada

%Pré-alocação de memória
entrada = zeros(N,r);
saida = zeros(N,r);
ruido = normrnd(0,0.01,N,r);
%ruido = zeros(N,r);

T = 5;
%Geração do sinal de entrada
for i = 1:r
    for j = Th:N
        %Verificação se está no instante de alteração de amplitude
        if ~mod(j,T)
            %Amplitude randômica dentro do limite definido
            amp = (max_u-min_u)*rand()+min_u;
            entrada(j,i) = amp;
            %Duração aleatória proporcional ao Th
            T = (fix(mod(rand()*10,10))+1)*Th;
        else
            %Manutenção da última amplitude
            entrada(j,i) = entrada(j-1,i);
        end
    end
end

%Cálculo da saída da planta
for i = n+1:N
    saida(i,2) = 0.5*saida(i-1,1) + entrada(i-2,1) + 0.1*saida(i-1,2)*entrada(i-1,1) + ruido(i,1);
    saida(i,1) = 0.9*saida(i-2,2) + entrada(i-1,2) + 0.2*saida(i-1,2)*entrada(i-2,2) + ruido(i,2);
end

input(:,:) = entrada(1:N,:);
output(:,:) = saida(1:N,:);

%% Dados para validação
%Pré-alocação de memória
entrada = zeros(N,r);
saida = zeros(N,r);
ruido = normrnd(0,0.01,N,r);

T = 5;

%Geração do sinal de entrada
for i = 1:r
    for j = Th:N
        %Verificação se está no instante de alteração de amplitude
        if ~mod(j,T)
            %Amplitude randômica dentro do limite definido
            amp = (max_u-min_u)*rand()+min_u;
            entrada(j,i) = amp;
            %Duração aleatória proporcional ao Th
            T = (fix(mod(rand(1)*10,10))+1)*Th;
        else
            %Manutenção da última amplitude
            entrada(j,i) = entrada(j-1,i);
        end
    end
end

%Cálculo da saída da planta
inp_val(:,:) = entrada(1:N,:);

for i = n+1:N
 saida(i,2) = 0.5*saida(i-1,1) + entrada(i-2,1) + 0.1*saida(i-1,2)*entrada(i-1,1) + ruido(i,1);
    saida(i,1) = 0.9*saida(i-2,2) + entrada(i-1,2) + 0.2*saida(i-1,2)*entrada(i-2,2) + ruido(i,2);
end

out_val(:,:) = saida(1:N,:);

%% Matriz de regressores
%NARMAX MIMO

erro = normrnd(0,0.01,N,r); %sinal erro
%erro = zeros(N,r);
p = [zeros(N,M - 1) ones(N,1)];

for i = 1:N
    pos = 1;
    for j = 1:r
        for k =1:n
            if(i-k>0), p(i,pos) = output(i-k,j);
            else,      p(i,pos) = 0;
            end
            pos = pos+1;
        end
    end
    
    for j = 1:r
        for k =1:n
            if(i-k>0), p(i,pos) = input(i-k,j);
            else,      p(i,pos) = 0;
            end
            pos = pos+1;
        end
    end
    
    for j = 1:r
        for k =1:n
            if(i-k>0), p(i,pos) = erro(i-k,j);
            else,      p(i,pos) = 0;
            end
            pos = pos+1;
        end
    end
    
    
    %Matriz de regressão (2ª ordem)
    
    for j = 1:3*n*r
        for k = j:3*n*r
            p(i,pos) = p(i,j)*p(i,k);
            pos = pos +1;
        end
    end
    
    
end

%% OLS

%OLS MIMO
tol = 0; %10^-3;         %Tolerância, o código para quando 1 - sum(ERR) < tol ou depois de varrer todos os parâmetros
Mlimite = 6;            %Limite de termos, o código para quando atinge o número de termos ou depois de varrer todos os parâmetros
%
%Ortogonalização de P
%o objetivo é reduzir a quantidade de parâmetros, então cada coluna de W é calculada testando todos os parâmetros disponíveis e utilizar apenas o melhor

for iii = 1:r
ite = 1:M;              %Possui todos os índices da matriz de parâmetros
w = zeros(N,M);         %Matriz ortogonalizada
a = eye(M);             %Triangular superior que auxilia na ortogonalização
ERR = zeros(M,1);       %Taxa de redução de erro
custo = zeros(M,1);     %Variável auxiliar para o ERR, é basicamente um ERR temporário

    for i = ite
        % Alguma coisa aqui
        w(:, 1) = p(:, i);
        custo(i) = power(dot(output(:,iii), w(:,1)), 2) / (dot(output(:,iii), output(:,iii)) * dot(w(:, 1), w(:, 1)));
    end
    %Identificação do melor parâmetro
    [ERR(1), indice(1,iii)] = max(custo);
    %Remoção do melhor parâmetro do indice de busca
    ite(ite == indice(1,iii)) =[];
    %Ajuste de W para o melhor parâmetro
    w(:,1) = p(:,indice(1,iii));
    
    
    %A mesma ideia, porém o valor atual de W depende dos valores anteriores
    for ii = 2:M
        %Zerando o custo para garantir uma leitura correta
        custo = zeros(M,1);
        for i = ite
            %Cálculo da Matriz A
            for j = 1:ii-1
                a(j,ii) = dot(p(:,i), w(:,j)) / dot(w(:,j), w(:,j));
            end
            
            temp = zeros(N,1);
            for k = 1:ii-1
                temp = temp - a(k,ii).*w(:,k);
            end
            %Cálculo de W
            w(:,ii) = p(:,i) + temp;
            %Cálculo do ERR
            custo(i) = dot(output(:,iii),w(:,ii))^2/(dot(output(:,iii),output(:,iii))*dot(w(:,ii),w(:,ii)));
        end
        %Identificação do melhor parâmetro
        [ERR(ii), indice(ii,iii)] = max(custo);
        %Remoção do melhor parâmetro do indice de busca
        ite(ite == indice(ii,iii)) =[];
        %Ajuste de A para o melhor parâmetro
        for j = 1:ii-1
            a(j,ii) = dot(p(:,indice(ii,iii)),w(:,j))/dot(w(:,j),w(:,j));
        end
        
        temp = zeros(N,1);
        for k = 1:ii-1
            temp = temp - a(k,ii).*w(:,k);
        end
        %Ajuste de W para o melhor parâmetro
        w(:,ii) = p(:,indice(ii,iii)) +temp;
        
        %Código de parada
        ESR = 1 - sum(ERR);
        if ESR < tol || size(nonzeros(indice(:,iii)),1) == Mlimite
            break;
        end
    end
    
    M_linha = ii;               %Caso atinja a tolerância, ii < M
    teta = zeros(M_linha,1);    %Então as matrizes devem ser recalculadas, para evitar colunas com zeros
    g = zeros(M_linha,1);
    p_linha = zeros(N,M_linha);
    
    for i = 1:M_linha
        p_linha(:,i) = p(:,indice(i,iii));
    end
    
    %Parâmetros g
    for i =1:M_linha
        g(i) = dot(output(:,iii),w(:,i))/dot(w(:,i),w(:,i));
    end
    
    %Cálculo do Teta
    teta(M_linha) = g(M_linha);
    for i =M_linha-1:-1:1
        temp = 0;
        
        for j = i+1:M_linha
            temp = temp - a(i,j).*teta(j);
        end
        
        teta(i) = g(i) + temp;
    end
    
    
    par(:,iii) = teta;
    mat(:,:,iii) = p_linha;
    
    
    
end

%% Validação

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
        
        
        for j = i:N
            y_cha(i,j,k4) = p_lin(j,:)*par(:,k4);
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



