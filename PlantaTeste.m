function y = PlantaTeste(u,e,lag)
y = zeros(size(u));
for i = lag+1:size(y(:,1))
    y(i,2) = 0.5*y(i-1,1) + u(i-2,1) + 0.1*y(i-1,2)*u(i-1,1) + e(i,1);
    y(i,1) = 0.9*y(i-2,2) + u(i-1,2) + 0.2*y(i-1,2)*u(i-2,2) + e(i,2);
end
end