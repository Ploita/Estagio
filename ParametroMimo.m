%OLS MIMO
tol = 0; %10^-3;         %Tolerância, o código para quando 1 - sum(ERR) < tol ou depois de varrer todos os parâmetros
Mlimite = 6;            %Limite de termos, o código para quando atinge o número de termos ou depois de varrer todos os parâmetros
%%
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
    
    
    if iii ==1
        par_y1 = teta;
        mat_y1 = p_linha;
    else
        par_y2 = teta;
        mat_y2 = p_linha;
    end
    
end




clear a custo g i ii ite j k temp iii tol w teta ESR p_linha