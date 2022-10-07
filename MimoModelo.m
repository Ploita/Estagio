% Imprimir o modelo mimo

str = string(zeros(M,1));
str(M) = "cte";
pos = 1;
for j = 1:r
    for k = 1:n
        str(pos) = "*y_"+j+ "(k-" + k +")";
        pos = pos + 1;
    end
end

for j = 1:r
    for k = 1:n
        str(pos) = "*u_"+j+ "(k-" + k +")";
        pos = pos + 1;
    end
end

for j = 1:r
    for k = 1:n
        str(pos) = "*e_"+j+ "(k-" + k +")";
        pos = pos + 1;
    end
end

for k1 = 1:3*r*n
    for k2 = k1:3*r*n
        str(pos) = str(k1) + '*' + str(k2);
        pos = pos +1;
    end
end

for k = 1:r
    if k ==1
        teta = par_y1;
    else
        teta = par_y2;
    end
    fprintf("y_"+ k + "(k) =")
    fprintf(' %.4f'+str(indice(1,k)),teta(1));
    for i = 2:M_linha
        if teta(i) > 0
            fprintf(' + %.4f'+str(indice(i,k))+' ',teta(i));
        else
            fprintf(' - %.4f'+str(indice(i,k)),abs(teta(i)));
        end
    end
    fprintf('\n');
end