y_1 = zeros(N,1);
y_2 = zeros(N,1);
u_1 = inp_val(:,1);
u_2 = inp_val(:,1);
e_1 = erro(:,1);
e_2 = erro(:,2);

for k = n+1:N
y_1(k) = 0.7657*y_1(k-1) + 0.8582*u_1(k-2)  - 0.1953*y_1(k-2) + 0.0570*y_2(k-2)*u_1(k-1)  + 7.7045*e_1(k-1)*e_2(k-2)  + 1.3326*u_1(k-2)*e_2(k-1);
y_2(k) = 0.1053*y_2(k-1) + 0.9583*u_2(k-1)  + 0.7997*y_2(k-2)  + 0.2006*y_2(k-1)*u_2(k-2)  - 0.0790*e_1(k-2) - 0.0279*y_2(k-1)*u_1(k-1);
end
figure
plot(y_2)
title('Modelo - y_2')
figure
plot(out_val(lim_inf:lim_sup,2))
title('Real - y_2')