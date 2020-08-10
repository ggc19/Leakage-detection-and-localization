function [DT, Dist, coeff]=calculate_GCC1(sensor1, sensor2, dist, v)
% The GCC method
% Input:  
% sensor1 is the signals collected by sensor1, sensor2 is the signals collected by sensor2.
% dist is the pipe length, v is wave speed.
% Output:
% DT is the time delay estimation. Dist is the leakage location using GCC methods.
% coeff is the cross-correlation coefficient.

Fs=4800; 
S1 = sensor1;  
S2 = sensor2;   
distance= dist;  
velocity= v;      
win_nb=1024;  
nfft=2*win_nb;  
noverlap=win_nb/2;
[Pxy, Fxy] = cpsd(S1, S2, hanning(win_nb),noverlap, nfft, Fs, 'twosided');             
[Pxx, Fxx]=pwelch(S1, hanning(win_nb), noverlap, nfft, Fs, 'twosided');                  
[Pyy, Fyy]=pwelch(S2, hanning(win_nb), noverlap, nfft, Fs, 'twosided');                  
SCOT = ((Pxx.*Pyy).^(1/2)).^-1; 
Pxy_SCOT = Pxy.* SCOT;  
Pxx_SCOT=Pxx.* SCOT;  
Pyy_SCOT=Pyy.* SCOT; 
rxy_SCOT = real(ifft(Pxy_SCOT));    
rxy_SCOT = fftshift(rxy_SCOT);     
Rxy_SCOT = rxy_SCOT(2:end); 
[coeff_SCOT, id1] = max(Rxy_SCOT);      
R1 = fix(length(Rxy_SCOT)/2)+2; 
delay_time1 = (id1-R1)/Fs;  
distance1 = (distance+(velocity*delay_time1))/2; 
rxx_SCOT = real(ifft(Pxx_SCOT));    
rxx_SCOT = fftshift(rxx_SCOT);     
Rxx_SCOT = rxx_SCOT(2:end); 
ryy_SCOT = real(ifft(Pyy_SCOT));   
ryy_SCOT = fftshift(ryy_SCOT);     
Ryy_SCOT = ryy_SCOT(2:end); 
coeff = coeff_SCOT/sqrt(Rxx_SCOT(win_nb)*Ryy_SCOT(win_nb));
DT(1,1) = delay_time1; 
Dist(1,1)=distance1; 
end