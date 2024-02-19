% Design a moving average filter
% Author : Kwadwo Boateng

close all;
clear all;
clc

 fs = 512; % Sampling frequency (samples per second) 
 dt = 1/fs; % seconds per sample 
 StopTime = 1.0; % seconds 
 t = (0:dt:StopTime)'; % seconds 
 Fc = 6; % Sine wave frequency (hertz) 
 Xn = sin(2*pi*Fc*t);

 figure(1)
 plot(t,Xn)

 samples = length(t);
 Noise = randn(1,samples); % Create random noise of the same length as the samples 
 Zn = Xn + Noise;  % Add noise to the input sine wave
 
 figure(2)
 plot(t, Zn)
 
 Num = ones(1,samples); % Numerator of the Moving Average Filter
 Num1 = Num*(1/samples);

 Den = 1;
 Yn = filter(Num,Den,Xn); % Perform the filtering  

 figure(3)
 plot(Yn, 'r', 'linewidth', 3);