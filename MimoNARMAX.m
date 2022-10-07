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

clear pos k j i