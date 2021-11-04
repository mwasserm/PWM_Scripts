%FFT redo 
%Created from matlab documentation to double check. Basically copied
%verbatim from: https://www.mathworks.com/help/releases/R2019a/matlab/ref/fft.html

clear all;

[d,s] = xlsread("iss064m450891736_clip4-00001.csv"); 

Fs = 60;                % Sampling frequency                    
T = 1/Fs;               % Sampling period       
L = size(d,1);          % Length of signal
t = (0:L-1)*T;          % Time vector

Y = fft(d(:,2));        % Output from ImageJ has data in column 2 (col 1 is slice n)
P2 = abs(Y/L);          % 2-sided spectrum P2
P1 = P2(1:L/2+1);       % 1-sided P1
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')