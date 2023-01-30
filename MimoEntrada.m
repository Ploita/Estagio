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
input(:,:) = entrada(1:N,:);
output(:,:) = PlantaTeste(entrada,ruido,n);

%% Validação
%Pré-alocação de memória
entrada = zeros(N,r);
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
out_val(:,:) = PlantaTeste(entrada,ruido,n);

clear i amp Ts ruido entrada saida min_u max_u j T Th