function [xx, xx_cost, dxx_cost, dx_cost]=newton_cost3(x1, x2, L, start1, end1, T, M, velocity, nb_sensors)
% Input:  
% x1 is the start node location, x2 is the end node location. L  is the pipe length. 
% start1 is the theoretical time delay of start nodes, end1 is the theoretical time delay of end nodes. 
% T is the time delay estimation, M is the cross-correlation coefficient. velocity is the wave speed, nb_sensors is the number of sensors. 
% Output:
% xx is the leakage location, xx_cost is the objective function f(x), dxx_cost is the derivative of the objective function f(x) for search nodes. 
% dx_cost is the derivative of the objective function f(x) for start and end nodes.

nb = nb_sensors;
d1 = zeros(2,nb);
for i=1:nb
    d1(1, i)=start1(1, i); 
    d1(2, i)=end1(1, i); 
end
cost = zeros(2,1);
dx_cost = zeros(2,1);
for i=1:2
    temp1=0; 
    for j=1:nb
        temp1=temp1+M(2, j)*(T(1,j)-d1(i, j))^2;
    end
    temp2=(-4/velocity)*(M(2, j)*(T(1,2)-d1(i, 2))+M(2, 5)*(T(1,5)-d1(i, 5))-M(2, 8)*(T(1,8)-d1(i, 8))-M(2, 9)*(T(1,9)-d1(i, 9))); 
    cost(i,1)=temp1;
    dx_cost(i,1)=temp2;
end
s=3*(cost(2,1)-cost(1,1))/(x2-x1);
z=s-dx_cost(1,1)-dx_cost(2,1);
w=abs(sqrt(z^2-dx_cost(1,1)*dx_cost(2,1)));
xx=x1+(x2-x1)*(1-(dx_cost(2,1)+w+z)/(dx_cost(2,1)-dx_cost(1,1)+2*w));
dxx = zeros(1,nb);
dxx(1,1)=-22/velocity; dxx(1,2)=(65+2*xx-L)/velocity; dxx(1,3)=-5/velocity; dxx(1,4)=-45/velocity; dxx(1,5)=(87+2*xx-L)/velocity;
dxx(1,6)=17/velocity; dxx(1,7)=-23/velocity; dxx(1,8)=(L-2*xx-70)/velocity; dxx(1,9)=(L-2*xx-110)/velocity; dxx(1,10)=-40/velocity;
xx_cost = zeros(1,1);
dxx_cost = zeros(1,1);
for i=1:1
    temp3=0; 
    for j=1:nb
        temp3=temp3+M(2, j)*(T(1,j)-dxx(i, j))^2;
    end
    temp4=(-4/velocity)*(M(2, j)*(T(1,2)-dxx(i, 2))+M(2, 5)*(T(1,5)-dxx(i, 5))-M(2, 8)*(T(1,8)-dxx(i, 8))-M(2, 9)*(T(1,9)-dxx(i, 9))); 
    xx_cost(i,1)=temp3;
    dxx_cost(i,1)=temp4;
end
fprintf(' \n Location is£º "%8.3f " £¬Derivative is £º"%8.4f " ', xx, dxx_cost);
end