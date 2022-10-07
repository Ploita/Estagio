%% Sinal APRBS
N = 1000;   %Total de amostras
L = 2; %grau dos polimônios máx 3
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

%Cálculo da saída da planta #não-genérico
for i = n+1:N
    saida(i,2) = 0.5*saida(i-1,1) + entrada(i-2,1) + 0.1*saida(i-1,2)*entrada(i-1,1) + 0.5*ruido(i-1,1) + 0.2*saida(i-2,1)*ruido(i-2,1) + ruido(i,1);
    saida(i,1) = 0.9*saida(i-2,2) + entrada(i-1,2) + 0.2*saida(i-1,2)*entrada(i-2,2) + 0.5*ruido(i-1,2) + 0.1*saida(i-1,2)*ruido(i-2,1) + ruido(i,2);
end

input(:,:) = entrada(1:N,:);
output(:,:) = saida(1:N,:);

%% Validação
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

%Cálculo da saída da planta #não-genérico
inp_val(:,:) = entrada(1:N,:);

for i = n+1:N
    saida(i,1) = 0.5*saida(i-1,1) + entrada(i-2,1) + 0.1*saida(i-1,2)*entrada(i-1,1) + 0.5*ruido(i-1,1) + 0.2*saida(i-2,1)*ruido(i-2,1) + ruido(i,1);
    saida(i,2) = 0.9*saida(i-2,2) + entrada(i-1,2) + 0.2*saida(i-1,2)*entrada(i-2,2) + 0.5*ruido(i-1,2) + 0.1*saida(i-1,2)*ruido(i-2,1) + ruido(i,2);
end

out_val(:,:) = saida(1:N,:);

clear i amp Ts ruido entrada saida min_u max_u j T Th