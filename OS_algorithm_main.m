%% The ordinary search algorithm for experiment 1. For other experiments, the codes are similar.
% read data
clear; clc;  
data = xlsread('data for experiment 1.xlsx');
Fs=4800;  Length=4096*5;  index=1; 
sensor1 = data(index: index+Length-1,1); sensor2 = data(index: index+Length-1,2); 
sensor3 = data(index: index+Length-1,3); sensor4 = data(index: index+Length-1,4); sensor5 = data(index: index+Length-1,5);
% the bandpass filter
fp=[100 2000]; fs=[50 2050]; rp=2;rs=5; wp=fp*2*pi/Fs; ws=fs*2*pi/Fs;
[n,wn]=buttord(wp/pi,ws/pi,rp,rs); [bz,az]=butter(n,wp/pi); 
sensor1 = filter(bz,az,sensor1);  sensor2 = filter(bz,az,sensor2);  
sensor3 = filter(bz,az,sensor3);  sensor4 = filter(bz,az,sensor4);  sensor5 = filter(bz,az,sensor5);  
% the GCC method
distance12 = 66; distance13 = 117; distance14 = 135 ;  distance15 = 175;  distance23 = 139; 
distance24 =157; distance25 = 197;  distance34 = 122; distance35 = 162; distance45 = 40;
velocity=1250; 
S1 = sensor1;         % sensor S1
S2 = sensor2;         % sensor S2
S3 = sensor3;         % sensor S3
S4 = sensor4;         % sensor S4
S5 = sensor5;         % sensor S5
[t12, dis12, coeff1]=calculate_GCC1(S1, S2, distance12, velocity);  
[t13, dis13, coeff2]=calculate_GCC1(S1, S3, distance13, velocity); 
[t14, dis14, coeff3]=calculate_GCC1(S1, S4, distance14, velocity); 
[t15, dis15, coeff4]=calculate_GCC1(S1, S5, distance15, velocity); 
[t23, dis23, coeff5]=calculate_GCC1(S2, S3, distance23, velocity); 
[t24, dis24, coeff6]=calculate_GCC1(S2, S4, distance24, velocity); 
[t25, dis25, coeff7]=calculate_GCC1(S2, S5, distance25, velocity); 
[t34, dis34, coeff8]=calculate_GCC1(S3, S4, distance34, velocity); 
[t35, dis35, coeff9]=calculate_GCC1(S3, S5, distance35, velocity); 
[t45, dis45, coeff10]=calculate_GCC1(S4, S5, distance45, velocity); 
%  cross-correlation coefficients
M = zeros(2,10);  
M(1,1)=coeff1; M(1,2)=coeff2; M(1,3)=coeff3; M(1,4)=coeff4; M(1,5)=coeff5; 
M(1,6)=coeff6; M(1,7)=coeff7; M(1,8)=coeff8; M(1,9)=coeff9; M(1,10)=coeff10; 
total=sum(M(1,:)); 
for i=1:10 
    M(2,i)=M(1,i)/total; 
end   
T = zeros(1,10); m=1; 
T(1,1) = t12(m,1);  T(1,2) = t13(m,1);  T(1,3) = t14(m,1);  T(1,4) = t15(m,1);  T(1,5) = t23(m,1); 
T(1,6) = t24(m,1);  T(1,7) = t25(m,1);  T(1,8) = t34(m,1);  T(1,9) = t35(m,1);  T(1,10) = t45(m,1);

%%  search for pipe nodes
d = zeros(7,10); 
d112=-66/velocity;  d113 = -117/velocity;  d114 = -135/velocity;  d115 = -175/velocity;   d123 = -51/velocity;    % TDOA from node 1 to different sensors
d124 = -69/velocity;  d125 = -109/velocity;  d134 = -18/velocity; d135 = -58/velocity;  d145 = -40/velocity;
d212 = 66/velocity; d213 = -73/velocity; d214 = -91/velocity; d215 = 75/velocity; d223 = -139/velocity;               % TDOA from node 2 to different sensors
d224 = -157/velocity;  d225 = -197/velocity; d234 = -18/velocity; d235 = -58/velocity; d245 = -40/velocity; 
d312 =-22/velocity;  d313 =117/velocity;  d314=-5/velocity;  d315=-45/velocity;  d323 =139/velocity;                  % TDOA from node 3 to different sensors
d324 = 17/velocity;  d325 = -23/velocity;  d334 = -122/velocity;  d335 = -162/velocity;  d345 = -40/velocity; 
d412 =-22/velocity;  d413=13/velocity;  d414=135/velocity;  d415=95/velocity;  d423=35/velocity;                       % TDOA from node 4 to different sensors
d424 = 157/velocity;  d425=117/velocity;  d434=122/velocity;  d435=82/velocity;   d445=-40/velocity;
d512=-22/velocity; d513=13/velocity; d514=135/velocity; d515=175/velocity;  d523=35/velocity;                         % TDOA from node 5 to different sensors
d524=157/velocity; d525=197/velocity; d534=122/velocity; d535=162/velocity; d545=40/velocity; 
d612 = -22/velocity; d613 = 13/velocity; d614 = -5/velocity; d615 = -45/velocity; d623 = 35/velocity;                   % TDOA from node 6 to different sensors
d624 = 17/velocity;  d625 = -23/velocity; d634 = -18/velocity; d635 = -58/velocity; d645 = -40/velocity;
d712 = -22/velocity; d713 = -73/velocity; d714 = -91/velocity; d715 = -131/velocity; d723 = -51/velocity;            % TDOA from node 7 to different sensors
d724 = -69/velocity; d725 = -109/velocity; d734 = -18/velocity; d735 = -58/velocity; d745 = -40/velocity;
d(1,1)=d112; d(1,2)=d113;  d(1,3)=d114; d(1,4)=d115; d(1,5)=d123; d(1,6)=d124; d(1,7)=d125; d(1,8)=d134; d(1,9)=d135; d(1,10)=d145; 
d(2,1)=d212; d(2,2)=d213;  d(2,3)=d214; d(2,4)=d215; d(2,5)=d223; d(2,6)=d224; d(2,7)=d225; d(2,8)=d234; d(2,9)=d235; d(2,10)=d245; 
d(3,1)=d312; d(3,2)=d313;  d(3,3)=d314; d(3,4)=d315; d(3,5)=d323; d(3,6)=d324; d(3,7)=d325; d(3,8)=d334; d(3,9)=d335; d(3,10)=d345; 
d(4,1)=d412; d(4,2)=d413;  d(4,3)=d414; d(4,4)=d415; d(4,5)=d423; d(4,6)=d424; d(4,7)=d425; d(4,8)=d434; d(4,9)=d435; d(4,10)=d445; 
d(5,1)=d512; d(5,2)=d513;  d(5,3)=d514; d(5,4)=d515; d(5,5)=d523; d(5,6)=d524; d(5,7)=d525; d(5,8)=d534; d(5,9)=d535; d(5,10)=d545; 
d(6,1)=d612; d(6,2)=d613;  d(6,3)=d614; d(6,4)=d615; d(6,5)=d623; d(6,6)=d624; d(6,7)=d625; d(6,8)=d634; d(6,9)=d635; d(6,10)=d645; 
d(7,1)=d712; d(7,2)=d713;  d(7,3)=d714; d(7,4)=d715; d(7,5)=d723; d(7,6)=d724; d(7,7)=d725; d(7,8)=d734; d(7,9)=d735; d(7,10)=d745; 
cost = zeros(7,1);
for i=1:7
    temp=0;
    for j=1:10
        temp=temp+M(2,j)*(T(1,j)-d(i, j))^2;
    end
    cost(i,1)=temp;
end
[min_cost, id] = min(cost); 

%% searching process along pipelines, consider the similarity of leakage signals
% the first search is from node 4 to node 6
clc;
L=70;
start1(1,1)=-22/velocity; start1(1,2)=13/velocity; start1(1,3)=135/velocity; start1(1,4)=95/velocity; start1(1,5)=35/velocity;
start1(1,6)=157/velocity; start1(1,7)=117/velocity; start1(1,8)=122/velocity; start1(1,9)=82/velocity; start1(1,10)=-40/velocity;
mid1(1,1)=-22/velocity; mid1(1,2)=13/velocity; mid1(1,3)=65/velocity; mid1(1,4)=25/velocity; mid1(1,5)=35/velocity;
mid1(1,6)=87/velocity; mid1(1,7)=47/velocity; mid1(1,8)=52/velocity; mid1(1,9)=12/velocity; mid1(1,10)=-40/velocity;
end1(1,1)= -22/velocity; end1(1,2)=13/velocity; end1(1,3) = -5/velocity; end1(1,4) =-45/velocity; end1(1,5)=35/velocity;         
end1(1,6)=17/velocity;  end1(1,7) = -23/velocity; end1(1,8) = -18/velocity; end1(1,9)  = -58/velocity; end1(1,10)=-40/velocity;
[min_cost1(1,1), id1(1,1)]=calculate_cost_1(start1, mid1, end1, T, M, 1); 
% the second search
start2=mid1;  end2=end1;
mid2(1,1)=-22/velocity; mid2(1,2)=13/velocity; mid2(1,3)=(L/4+65-3*L/4)/velocity; mid2(1,4)=(L/4+65-3*L/4-40)/velocity; mid2(1,5)=35/velocity; 
mid2(1,6)=(L/4+87-3*L/4)/velocity; mid2(1,7)=(L/4+87-3*L/4-40)/velocity; mid2(1,8)=(L/4+52-3*L/4)/velocity; mid2(1,9)=(L/4+52-3*L/4-40)/velocity; mid2(1,10)=-40/velocity; 
[min_cost1(2,1), id1(2,1)]=calculate_cost_1(start2, mid2, end2, T, M, 2);
% the third search
start3=mid2;  end3=end2;
mid3(1,1)=-22/velocity; mid3(1,2)=13/velocity; mid3(1,3)=(L/8+65-7*L/8)/velocity; mid3(1,4)=(L/8+65-7*L/8-40)/velocity; mid3(1,5)=35/velocity; 
mid3(1,6)=(L/8+87-7*L/8)/velocity; mid3(1,7)=(L/8+87-7*L/8-40)/velocity; mid3(1,8)=(L/8+52-7*L/8)/velocity; mid3(1,9)=(L/8+52-7*L/8-40)/velocity; mid3(1,10)=-40/velocity; 
[min_cost1(3,1), id1(3,1)]=calculate_cost_1(start3, mid3, end3, T, M, 3);
% the fourth search
mid4=mid3;
start4(1,1)=-22/velocity; start4(1,2)=13/velocity; start4(1,3)=(3*L/16+65-13*L/16)/velocity; start4(1,4)=(3*L/16+65-13*L/16-40)/velocity; start4(1,5)=35/velocity; 
start4(1,6)=(3*L/16+87-13*L/16)/velocity; start4(1,7)=(3*L/16+87-13*L/16-40)/velocity; start4(1,8)=(3*L/16+52-13*L/16)/velocity; start4(1,9)=(3*L/16+52-13*L/16-40)/velocity; start4(1,10)=-40/velocity;   
end4(1,1)=-22/velocity; end4(1,2)=13/velocity; end4(1,3)=(L/16+65-15*L/16)/velocity; end4(1,4)=(L/16+65-15*L/16-40)/velocity; end4(1,5)=35/velocity; 
end4(1,6)=(L/16+87-15*L/16)/velocity; end4(1,7)=(L/16+87-15*L/16-40)/velocity; end4(1,8)=(L/16+52-15*L/16)/velocity; end4(1,9)=(L/16+52-15*L/16-40)/velocity; end4(1,10)=-40/velocity;   
[min_cost1(4,1), id1(4,1)]=calculate_cost_1(start4, mid4, end4, T, M, 4);
% the fifth search
mid5=mid4;
start5(1,1)=-22/velocity; start5(1,2)=13/velocity; start5(1,3)=(5*L/32+65-27*L/32)/velocity; start5(1,4)=(5*L/32+65-27*L/32-40)/velocity; start5(1,5)=35/velocity; 
start5(1,6)=(5*L/32+87-27*L/32)/velocity; start5(1,7)=(5*L/32+87-27*L/32-40)/velocity; start5(1,8)=(5*L/32+52-27*L/32)/velocity; start5(1,9)=(5*L/32+52-27*L/32-40)/velocity; start5(1,10)=-40/velocity;   
end5(1,1)=-22/velocity; end5(1,2)=13/velocity; end5(1,3)=(3*L/32+65-29*L/32)/velocity; end5(1,4)=(3*L/32+65-29*L/32-40)/velocity; end5(1,5)=35/velocity; 
end5(1,6)=(3*L/32+87-29*L/32)/velocity; end5(1,7)=(3*L/32+87-29*L/32-40)/velocity; end5(1,8)=(3*L/32+52-29*L/32)/velocity; end5(1,9)=(3*L/32+52-29*L/32-40)/velocity; end5(1,10)=-40/velocity;   
[min_cost1(5,1), id1(5,1)]=calculate_cost_1(start5, mid5, end5, T, M, 5);
% the sixth search
mid6=mid5;
start6(1,1)=-22/velocity; start6(1,2)=13/velocity; start6(1,3)=(9*L/64+65-55*L/64)/velocity; start6(1,4)=(9*L/64+65-55*L/64-40)/velocity; start6(1,5)=35/velocity; 
start6(1,6)=(9*L/64+87-55*L/64)/velocity; start6(1,7)=(9*L/64+87-55*L/64-40)/velocity; start6(1,8)=(9*L/64+52-55*L/64)/velocity; start6(1,9)=(9*L/64+52-55*L/64-40)/velocity; start6(1,10)=-40/velocity;   
end6(1,1)=-22/velocity; end6(1,2)=13/velocity; end6(1,3)=(7*L/64+65-57*L/64)/velocity; end6(1,4)=(7*L/64+65-57*L/64-40)/velocity; end6(1,5)=35/velocity; 
end6(1,6)=(7*L/64+87-57*L/64)/velocity; end6(1,7)=(7*L/64+87-57*L/64-40)/velocity; end6(1,8)=(7*L/64+52-57*L/64)/velocity; end6(1,9)=(7*L/64+52-57*L/64-40)/velocity; end6(1,10)=-40/velocity;   
[min_cost1(6,1), id1(6,1)]=calculate_cost_1(start6, mid6, end6, T, M, 6);

% the first search is from node 7 to node 6
L=43;
start1(1,1)=-22/velocity; start1(1,2)=-73/velocity; start1(1,3)=-91/velocity; start1(1,4)=-131/velocity; start1(1,5)=-51/velocity;
start1(1,6)=-69/velocity; start1(1,7)=-109/velocity; start1(1,8)=-18/velocity; start1(1,9)=-58/velocity; start1(1,10)=-40/velocity;
mid1(1,1)=-22/velocity; mid1(1,2)=-30/velocity; mid1(1,3)=-48/velocity; mid1(1,4)=-88/velocity; mid1(1,5)=-8/velocity;
mid1(1,6)=-26/velocity; mid1(1,7)=-66/velocity; mid1(1,8)=-18/velocity; mid1(1,9)=-58/velocity; mid1(1,10)=-40/velocity;
end1(1,1)= -22/velocity; end1(1,2)=13/velocity; end1(1,3) = -5/velocity; end1(1,4) =-45/velocity; end1(1,5)=35/velocity;         
end1(1,6)=17/velocity;  end1(1,7) = -23/velocity; end1(1,8) = -18/velocity; end1(1,9)  = -58/velocity; end1(1,10)=-40/velocity;
[min_cost2(1,1), id2(1,1)]=calculate_cost_1(start1, mid1, end1, T, M, 1); 
% the second search
start2=mid1; end2=end1; 
mid2(1,1)=-22/velocity; mid2(1,2)=(3*L/4+22-L/4-52)/velocity; mid2(1,3)=(3*L/4+22-L/4-70)/velocity; mid2(1,4)=(3*L/4+22-L/4-110)/velocity; mid2(1,5)=(3*L/4+44-L/4-52)/velocity;
mid2(1,6)=(3*L/4+44-L/4-70)/velocity; mid2(1,7)=(3*L/4+44-L/4-110)/velocity; mid2(1,8)=-18/velocity; mid2(1,9)=-58/velocity; mid2(1,10)=-40/velocity;
[min_cost2(2,1), id2(2,1)]=calculate_cost_1(start2, mid2, end2, T, M, 2); 
% the third search
mid3=mid2;
start3(1,1)=-22/velocity; start3(1,2)=(22+5*L/8-3*L/8-52)/velocity; start3(1,3)=(22+5*L/8-3*L/8-70)/velocity; start3(1,4)=(22+5*L/8-3*L/8-110)/velocity; start3(1,5)=(44+5*L/8-3*L/8-52)/velocity;
start3(1,6)=(44+5*L/8-3*L/8-70)/velocity; start3(1,7)=(44+5*L/8-3*L/8-110)/velocity; start3(1,8)=-18/velocity; start3(1,9)=-58/velocity; start3(1,10)=-40/velocity;
end3(1,1)=-22/velocity; end3(1,2)=(22+7*L/8-L/8-52)/velocity; end3(1,3)=(22+7*L/8-L/8-70)/velocity; end3(1,4)=(22+7*L/8-L/8-110)/velocity; end3(1,5)=(44+7*L/8-L/8-52)/velocity;
end3(1,6)=(44+7*L/8-L/8-70)/velocity; end3(1,7)=(44+7*L/8-L/8-110)/velocity; end3(1,8)=-18/velocity; end3(1,9)=-58/velocity; end3(1,10)=-40/velocity;
[min_cost2(3,1), id2(3,1)]=calculate_cost_1(start3, mid3, end3, T, M, 3); 
% the fourth search
start4=mid3; end4=end3; 
mid4(1,1)=-22/velocity; mid4(1,2)=(22+13*L/16-3*L/16-52)/velocity; mid4(1,3)=(22+13*L/16-3*L/16-70)/velocity; mid4(1,4)=(22+13*L/16-3*L/16-110)/velocity; mid4(1,5)=(44+13*L/16-3*L/16-52)/velocity;
mid4(1,6)=(44+13*L/16-3*L/16-70)/velocity; mid4(1,7)=(44+13*L/16-3*L/16-110)/velocity; mid4(1,8)=-18/velocity; mid4(1,9)=-58/velocity; mid4(1,10)=-40/velocity;
[min_cost2(4,1), id2(4,1)]=calculate_cost_1(start4, mid4, end4, T, M, 4); 
% the fifth search
mid5=mid4;
start5(1,1)=-22/velocity; start5(1,2)=(22+25*L/32-7*L/32-52)/velocity; start5(1,3)=(22+25*L/32-7*L/32-70)/velocity; start5(1,4)=(22+25*L/32-7*L/32-110)/velocity; start5(1,5)=(44+25*L/32-7*L/32-52)/velocity;
start5(1,6)=(44+25*L/32-7*L/32-70)/velocity; start5(1,7)=(44+25*L/32-7*L/32-110)/velocity; start5(1,8)=-18/velocity; start5(1,9)=-58/velocity; start5(1,10)=-40/velocity;
end5(1,1)=-22/velocity; end5(1,2)=(22+27*L/32-5*L/32-52)/velocity; end5(1,3)=(22+27*L/32-5*L/32-70)/velocity; end5(1,4)=(22+27*L/32-5*L/32-110)/velocity; end5(1,5)=(44+27*L/32-5*L/32-52)/velocity;
end5(1,6)=(44+27*L/32-5*L/32-70)/velocity; end5(1,7)=(44+27*L/32-5*L/32-110)/velocity; end5(1,8)=-18/velocity; end5(1,9)=-58/velocity; end5(1,10)=-40/velocity;
[min_cost2(5,1), id2(5,1)]=calculate_cost_1(start5, mid5, end5, T, M, 5); 

% the first search is from node 3 to node 6
L=52;
start1(1,1)=-22/velocity; start1(1,2)=117/velocity; start1(1,3)=-5/velocity; start1(1,4)=-45/velocity;  start1(1,5)=139/velocity;
start1(1,6)=17/velocity; start1(1,7)=-23/velocity; start1(1,8)=-122/velocity; start1(1,9)=-162/velocity; start1(1,10)=-40/velocity;
mid1(1,1)=-22/velocity; mid1(1,2)=-65/velocity; mid1(1,3)=-5/velocity; mid1(1,4)=-45/velocity; mid1(1,5)=87/velocity;
mid1(1,6)=17/velocity; mid1(1,7)=-23/velocity; mid1(1,8)=-70/velocity; mid1(1,9)=-110/velocity; mid1(1,10)=-40/velocity;
end1(1,1)= -22/velocity; end1(1,2)=13/velocity; end1(1,3) = -5/velocity; end1(1,4) =-45/velocity; end1(1,5)=35/velocity;         
end1(1,6)=17/velocity;  end1(1,7) = -23/velocity; end1(1,8) = -18/velocity; end1(1,9)  = -58/velocity; end1(1,10)=-40/velocity;
[min_cost3(1,1), id3(1,1)]=calculate_cost_1(start1, mid1, end1, T, M, 1); 
% the second search
start2=mid1; end2=end1;
mid2(1,1)=-22/velocity; mid2(1,2)=(L/4+65-3*L/4)/velocity; mid2(1,3)=-5/velocity; mid2(1,4)=-45/velocity; mid2(1,5)=(L/4+87-3*L/4)/velocity;
mid2(1,6)=17/velocity; mid2(1,7)=-23/velocity; mid2(1,8)=(3*L/4-L/4-70)/velocity; mid2(1,9)=(3*L/4-L/4-110)/velocity; mid2(1,10)=-40/velocity;
[min_cost3(2,1), id3(2,1)]=calculate_cost_1(start2, mid2, end2, T, M, 2); 
% the third search
start3=mid2; end3=end2;
mid3(1,1)=-22/velocity; mid3(1,2)=(L/8+65-7*L/8)/velocity; mid3(1,3)=-5/velocity; mid3(1,4)=-45/velocity; mid3(1,5)=(L/8+87-7*L/8)/velocity;
mid3(1,6)=17/velocity; mid3(1,7)=-23/velocity; mid3(1,8)=(7*L/8-L/8-70)/velocity; mid3(1,9)=(7*L/8-L/8-110)/velocity; mid3(1,10)=-40/velocity;
[min_cost3(3,1), id3(3,1)]=calculate_cost_1(start3, mid3, end3, T, M, 3); 
% the fourth search
start4=mid3; end4=end3;
mid4(1,1)=-22/velocity; mid4(1,2)=(L/16+65-15*L/16)/velocity; mid4(1,3)=-5/velocity; mid4(1,4)=-45/velocity; mid4(1,5)=(L/16+87-15*L/16)/velocity;
mid4(1,6)=17/velocity; mid4(1,7)=-23/velocity; mid4(1,8)=(15*L/16-L/16-70)/velocity; mid4(1,9)=(15*L/16-L/16-110)/velocity; mid4(1,10)=-40/velocity;
[min_cost3(4,1), id3(4,1)]=calculate_cost_1(start4, mid4, end4, T, M, 4); 
% the fifth search
start5=mid4; end5=end4;
mid5(1,1)=-22/velocity; mid5(1,2)=(L/32+65-31*L/32)/velocity; mid5(1,3)=-5/velocity; mid5(1,4)=-45/velocity; mid5(1,5)=(L/32+87-31*L/32)/velocity;
mid5(1,6)=17/velocity; mid5(1,7)=-23/velocity; mid5(1,8)=(31*L/32-L/32-70)/velocity; mid5(1,9)=(31*L/32-L/32-110)/velocity; mid5(1,10)=-40/velocity;
[min_cost3(5,1), id3(5,1)]=calculate_cost_1(start5, mid5, end5, T, M, 5); 
% the sixth search
start6=mid5; end6=end5;
mid6(1,1)=-22/velocity; mid6(1,2)=(L/64+65-63*L/64)/velocity; mid6(1,3)=-5/velocity; mid6(1,4)=-45/velocity; mid6(1,5)=(L/64+87-63*L/64)/velocity;
mid6(1,6)=17/velocity; mid6(1,7)=-23/velocity; mid6(1,8)=(63*L/64-L/64-70)/velocity; mid6(1,9)=(63*L/64-L/64-110)/velocity; mid6(1,10)=-40/velocity;
[min_cost3(6,1), id3(6,1)]=calculate_cost_1(start6, mid6, end6, T, M, 6); 

%% searching process along pipelines, ignore the similarity of leakage signals
% the first search is from node 4 to node 6
clc;
for i=1:10 
    M(2,i)=0.1; 
end   
L=70;
start1(1,1)=-22/velocity; start1(1,2)=13/velocity; start1(1,3)=135/velocity; start1(1,4)=95/velocity; start1(1,5)=35/velocity;
start1(1,6)=157/velocity; start1(1,7)=117/velocity; start1(1,8)=122/velocity; start1(1,9)=82/velocity; start1(1,10)=-40/velocity;
mid1(1,1)=-22/velocity; mid1(1,2)=13/velocity; mid1(1,3)=65/velocity; mid1(1,4)=25/velocity; mid1(1,5)=35/velocity;
mid1(1,6)=87/velocity; mid1(1,7)=47/velocity; mid1(1,8)=52/velocity; mid1(1,9)=12/velocity; mid1(1,10)=-40/velocity;
end1(1,1)= -22/velocity; end1(1,2)=13/velocity; end1(1,3) = -5/velocity; end1(1,4) =-45/velocity; end1(1,5)=35/velocity;         
end1(1,6)=17/velocity;  end1(1,7) = -23/velocity; end1(1,8) = -18/velocity; end1(1,9)  = -58/velocity; end1(1,10)=-40/velocity;
[min_cost1(1,2), id1(1,2)]=calculate_cost_1(start1, mid1, end1, T, M, 1); 
% the second search
start2=mid1;  end2=end1;
mid2(1,1)=-22/velocity; mid2(1,2)=13/velocity; mid2(1,3)=(L/4+65-3*L/4)/velocity; mid2(1,4)=(L/4+65-3*L/4-40)/velocity; mid2(1,5)=35/velocity; 
mid2(1,6)=(L/4+87-3*L/4)/velocity; mid2(1,7)=(L/4+87-3*L/4-40)/velocity; mid2(1,8)=(L/4+52-3*L/4)/velocity; mid2(1,9)=(L/4+52-3*L/4-40)/velocity; mid2(1,10)=-40/velocity; 
[min_cost1(2,2), id1(2,2)]=calculate_cost_1(start2, mid2, end2, T, M, 2);
% the third search
mid3=mid2;
start3(1,1)=-22/velocity; start3(1,2)=13/velocity; start3(1,3)=(3*L/8+65-5*L/8)/velocity; start3(1,4)=(3*L/8+65-5*L/8-40)/velocity; start3(1,5)=35/velocity;
start3(1,6)=(3*L/8+87-5*L/8)/velocity; start3(1,7)=(3*L/8+87-5*L/8-40)/velocity; start3(1,8)=(3*L/8+52-5*L/8)/velocity; start3(1,9)=(3*L/8+52-5*L/8-40)/velocity; start3(1,10)=-40/velocity;
end3(1,1)=-22/velocity; end3(1,2)=13/velocity; end3(1,3)=(L/8+65-7*L/8)/velocity; end3(1,4)=(L/8+65-7*L/8-40)/velocity; end3(1,5)=35/velocity;
end3(1,6)=(L/8+87-7*L/8)/velocity; end3(1,7)=(L/8+87-7*L/8-40)/velocity; end3(1,8)=(L/8+52-7*L/8)/velocity; end3(1,9)=(L/8+52-7*L/8-40)/velocity; end3(1,10)=-40/velocity;
[min_cost1(3,2), id1(3,2)]=calculate_cost_1(start3, mid3, end3, T, M, 3);
% the fourth search
start4=mid3;  end4=end3;
mid4(1,1)=-22/velocity; mid4(1,2)=13/velocity; mid4(1,3)=(3*L/16+65-13*L/16)/velocity; mid4(1,4)=(3*L/16+65-13*L/16-40)/velocity; mid4(1,5)=35/velocity; 
mid4(1,6)=(3*L/16+87-13*L/16)/velocity; mid4(1,7)=(3*L/16+87-13*L/16-40)/velocity; mid4(1,8)=(3*L/16+52-13*L/16)/velocity; mid4(1,9)=(3*L/16+52-13*L/16-40)/velocity; mid4(1,10)=-40/velocity; 
[min_cost1(4,2), id1(4,2)]=calculate_cost_1(start4, mid4, end4, T, M, 4);
% the fifth search
start5=mid4;  end5=end4;
mid5(1,1)=-22/velocity; mid5(1,2)=13/velocity; mid5(1,3)=(5*L/32+65-27*L/32)/velocity; mid5(1,4)=(5*L/32+65-27*L/32-40)/velocity; mid5(1,5)=35/velocity; 
mid5(1,6)=(5*L/32+87-27*L/32)/velocity; mid5(1,7)=(5*L/32+87-27*L/32-40)/velocity; mid5(1,8)=(5*L/32+52-27*L/32)/velocity; mid5(1,9)=(5*L/32+52-27*L/32-40)/velocity; mid5(1,10)=-40/velocity; 
[min_cost1(5,2), id1(5,2)]=calculate_cost_1(start5, mid5, end5, T, M, 5);
% the sixth search
start6=mid5;  end6=end5;
mid6(1,1)=-22/velocity; mid6(1,2)=13/velocity; mid6(1,3)=(9*L/64+65-55*L/64)/velocity; mid6(1,4)=(9*L/64+65-55*L/64-40)/velocity; mid6(1,5)=35/velocity; 
mid6(1,6)=(9*L/64+87-55*L/64)/velocity; mid6(1,7)=(9*L/64+87-55*L/64-40)/velocity; mid6(1,8)=(9*L/64+52-55*L/64)/velocity; mid6(1,9)=(9*L/64+52-55*L/64-40)/velocity; mid6(1,10)=-40/velocity; 
[min_cost1(6,2), id1(6,2)]=calculate_cost_1(start6, mid6, end6, T, M, 6);

% the first search is from node 7 to node 6
L=43;
start1(1,1)=-22/velocity; start1(1,2)=-73/velocity; start1(1,3)=-91/velocity; start1(1,4)=-131/velocity; start1(1,5)=-51/velocity;
start1(1,6)=-69/velocity; start1(1,7)=-109/velocity; start1(1,8)=-18/velocity; start1(1,9)=-58/velocity; start1(1,10)=-40/velocity;
mid1(1,1)=-22/velocity; mid1(1,2)=-30/velocity; mid1(1,3)=-48/velocity; mid1(1,4)=-88/velocity; mid1(1,5)=-8/velocity;
mid1(1,6)=-26/velocity; mid1(1,7)=-66/velocity; mid1(1,8)=-18/velocity; mid1(1,9)=-58/velocity; mid1(1,10)=-40/velocity;
end1(1,1)= -22/velocity; end1(1,2)=13/velocity; end1(1,3) = -5/velocity; end1(1,4) =-45/velocity; end1(1,5)=35/velocity;         
end1(1,6)=17/velocity;  end1(1,7) = -23/velocity; end1(1,8) = -18/velocity; end1(1,9)  = -58/velocity; end1(1,10)=-40/velocity;
[min_cost2(1,2), id2(1,2)]=calculate_cost_1(start1, mid1, end1, T, M, 1); 
% the second search
start2=mid1; end2=end1; 
mid2(1,1)=-22/velocity; mid2(1,2)=(3*L/4+22-L/4-52)/velocity; mid2(1,3)=(3*L/4+22-L/4-70)/velocity; mid2(1,4)=(3*L/4+22-L/4-110)/velocity; mid2(1,5)=(3*L/4+44-L/4-52)/velocity;
mid2(1,6)=(3*L/4+44-L/4-70)/velocity; mid2(1,7)=(3*L/4+44-L/4-110)/velocity; mid2(1,8)=-18/velocity; mid2(1,9)=-58/velocity; mid2(1,10)=-40/velocity;
[min_cost2(2,2), id2(2,2)]=calculate_cost_1(start2, mid2, end2, T, M, 2); 
% the third search
mid3=mid2;
start3(1,1)=-22/velocity; start3(1,2)=(22+5*L/8-3*L/8-52)/velocity; start3(1,3)=(22+5*L/8-3*L/8-70)/velocity; start3(1,4)=(22+5*L/8-3*L/8-110)/velocity; start3(1,5)=(44+5*L/8-3*L/8-52)/velocity;
start3(1,6)=(44+5*L/8-3*L/8-70)/velocity; start3(1,7)=(44+5*L/8-3*L/8-110)/velocity; start3(1,8)=-18/velocity; start3(1,9)=-58/velocity; start3(1,10)=-40/velocity;
end3(1,1)=-22/velocity; end3(1,2)=(22+7*L/8-L/8-52)/velocity; end3(1,3)=(22+7*L/8-L/8-70)/velocity; end3(1,4)=(22+7*L/8-L/8-110)/velocity; end3(1,5)=(44+7*L/8-L/8-52)/velocity;
end3(1,6)=(44+7*L/8-L/8-70)/velocity; end3(1,7)=(44+7*L/8-L/8-110)/velocity; end3(1,8)=-18/velocity; end3(1,9)=-58/velocity; end3(1,10)=-40/velocity;
[min_cost2(3,2), id2(3,2)]=calculate_cost_1(start3, mid3, end3, T, M, 3); 
% the fourth search
start4=mid3; end4=end3; 
mid4(1,1)=-22/velocity; mid4(1,2)=(22+13*L/16-3*L/16-52)/velocity; mid4(1,3)=(22+13*L/16-3*L/16-70)/velocity; mid4(1,4)=(22+13*L/16-3*L/16-110)/velocity; mid4(1,5)=(44+13*L/16-3*L/16-52)/velocity;
mid4(1,6)=(44+13*L/16-3*L/16-70)/velocity; mid4(1,7)=(44+13*L/16-3*L/16-110)/velocity; mid4(1,8)=-18/velocity; mid4(1,9)=-58/velocity; mid4(1,10)=-40/velocity;
[min_cost2(4,2), id2(4,2)]=calculate_cost_1(start4, mid4, end4, T, M, 4); 
% the fifth search
mid5=mid4;
start5(1,1)=-22/velocity; start5(1,2)=(22+25*L/32-7*L/32-52)/velocity; start5(1,3)=(22+25*L/32-7*L/32-70)/velocity; start5(1,4)=(22+25*L/32-7*L/32-110)/velocity; start5(1,5)=(44+25*L/32-7*L/32-52)/velocity;
start5(1,6)=(44+25*L/32-7*L/32-70)/velocity; start5(1,7)=(44+25*L/32-7*L/32-110)/velocity; start5(1,8)=-18/velocity; start5(1,9)=-58/velocity; start5(1,10)=-40/velocity;
end5(1,1)=-22/velocity; end5(1,2)=(22+27*L/32-5*L/32-52)/velocity; end5(1,3)=(22+27*L/32-5*L/32-70)/velocity; end5(1,4)=(22+27*L/32-5*L/32-110)/velocity; end5(1,5)=(44+27*L/32-5*L/32-52)/velocity;
end5(1,6)=(44+27*L/32-5*L/32-70)/velocity; end5(1,7)=(44+27*L/32-5*L/32-110)/velocity; end5(1,8)=-18/velocity; end5(1,9)=-58/velocity; end5(1,10)=-40/velocity;
[min_cost2(5,2), id2(5,2)]=calculate_cost_1(start5, mid5, end5, T, M, 5); 

% the first search is from node 3 to node 6
L=52;
start1(1,1)=-22/velocity; start1(1,2)=117/velocity; start1(1,3)=-5/velocity; start1(1,4)=-45/velocity;  start1(1,5)=139/velocity;
start1(1,6)=17/velocity; start1(1,7)=-23/velocity; start1(1,8)=-122/velocity; start1(1,9)=-162/velocity; start1(1,10)=-40/velocity;
mid1(1,1)=-22/velocity; mid1(1,2)=-65/velocity; mid1(1,3)=-5/velocity; mid1(1,4)=-45/velocity; mid1(1,5)=87/velocity;
mid1(1,6)=17/velocity; mid1(1,7)=-23/velocity; mid1(1,8)=-70/velocity; mid1(1,9)=-110/velocity; mid1(1,10)=-40/velocity;
end1(1,1)= -22/velocity; end1(1,2)=13/velocity; end1(1,3) = -5/velocity; end1(1,4) =-45/velocity; end1(1,5)=35/velocity;         
end1(1,6)=17/velocity;  end1(1,7) = -23/velocity; end1(1,8) = -18/velocity; end1(1,9)  = -58/velocity; end1(1,10)=-40/velocity;
[min_cost3(1,2), id3(1,2)]=calculate_cost_1(start1, mid1, end1, T, M, 1); 
% the second search
start2=mid1; end2=end1;
mid2(1,1)=-22/velocity; mid2(1,2)=(L/4+65-3*L/4)/velocity; mid2(1,3)=-5/velocity; mid2(1,4)=-45/velocity; mid2(1,5)=(L/4+87-3*L/4)/velocity;
mid2(1,6)=17/velocity; mid2(1,7)=-23/velocity; mid2(1,8)=(3*L/4-L/4-70)/velocity; mid2(1,9)=(3*L/4-L/4-110)/velocity; mid2(1,10)=-40/velocity;
[min_cost3(2,2), id3(2,2)]=calculate_cost_1(start2, mid2, end2, T, M, 2); 
% the third search
start3=mid2; end3=end2;
mid3(1,1)=-22/velocity; mid3(1,2)=(L/8+65-7*L/8)/velocity; mid3(1,3)=-5/velocity; mid3(1,4)=-45/velocity; mid3(1,5)=(L/8+87-7*L/8)/velocity;
mid3(1,6)=17/velocity; mid3(1,7)=-23/velocity; mid3(1,8)=(7*L/8-L/8-70)/velocity; mid3(1,9)=(7*L/8-L/8-110)/velocity; mid3(1,10)=-40/velocity;
[min_cost3(3,2), id3(3,2)]=calculate_cost_1(start3, mid3, end3, T, M, 3); 
% the fourth search
start4=mid3; end4=end3;
mid4(1,1)=-22/velocity; mid4(1,2)=(L/16+65-15*L/16)/velocity; mid4(1,3)=-5/velocity; mid4(1,4)=-45/velocity; mid4(1,5)=(L/16+87-15*L/16)/velocity;
mid4(1,6)=17/velocity; mid4(1,7)=-23/velocity; mid4(1,8)=(15*L/16-L/16-70)/velocity; mid4(1,9)=(15*L/16-L/16-110)/velocity; mid4(1,10)=-40/velocity;
[min_cost3(4,2), id3(4,2)]=calculate_cost_1(start4, mid4, end4, T, M, 4); 
% the fifth search
start5=mid4; end5=end4;
mid5(1,1)=-22/velocity; mid5(1,2)=(L/32+65-31*L/32)/velocity; mid5(1,3)=-5/velocity; mid5(1,4)=-45/velocity; mid5(1,5)=(L/32+87-31*L/32)/velocity;
mid5(1,6)=17/velocity; mid5(1,7)=-23/velocity; mid5(1,8)=(31*L/32-L/32-70)/velocity; mid5(1,9)=(31*L/32-L/32-110)/velocity; mid5(1,10)=-40/velocity;
[min_cost3(5,2), id3(5,2)]=calculate_cost_1(start5, mid5, end5, T, M, 5); 
% the six search
start6=mid5; end6=end5;
mid6(1,1)=-22/velocity; mid6(1,2)=(L/64+65-63*L/64)/velocity; mid6(1,3)=-5/velocity; mid6(1,4)=-45/velocity; mid6(1,5)=(L/64+87-63*L/64)/velocity;
mid6(1,6)=17/velocity; mid6(1,7)=-23/velocity; mid6(1,8)=(63*L/64-L/64-70)/velocity; mid6(1,9)=(63*L/64-L/64-110)/velocity; mid6(1,10)=-40/velocity;
[min_cost3(6,2), id3(6,2)]=calculate_cost_1(start6, mid6, end6, T, M, 6); 
