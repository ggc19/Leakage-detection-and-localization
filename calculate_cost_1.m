function [min_cost, id1]=calculate_cost_1(start1, mid1, end1, T, M, num)
% Input:  
% start1 is the theoretical time delay of start nodes, end1 is the theoretical time delay of end nodes. 
% mid1 is the theoretical time delay of middle nodes.
% T is the time delay estimation, M is cross-correlation coefficients. velocity is the wave speed, num is the node id. 
% Output:
% min_cost is the minimum objective function f(x), id1 is the search node id.

d1 = zeros(3,10);
for i=1:10
    d1(1, i)=start1(1, i); 
    d1(2, i)=mid1(1, i); 
    d1(3, i)=end1(1, i); 
end
cost = zeros(3,1);
for i=1:3
    temp=0;
    for j=1:10
        temp=temp+M(2, j)*(T(1,j)-d1(i, j))^2;
    end
    cost(i,1)=temp;
end
[min_cost, id1] = min(cost); 
fprintf(' \n the "%d" search£¬node "%d" has the lowest cost', num, id1);
end