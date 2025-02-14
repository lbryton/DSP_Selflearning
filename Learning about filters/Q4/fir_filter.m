% Clearing data
clc;
close all;
clf reset;
clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up
% Math for stopband edge frequency
% W1 = (stopband frequency) / (sampling rate / 2)
f_s = 80e3;
f_pass = 5e3;
f_stop = 10e3;
f_ss = f_s/2;
stopband_ripple = 60;
Rs= 60;     % Stopband ripple (dB)

% Filter Order
% N = (f_s/(f_stop-f_pass)) * attenuation(db) / 22
N = ceil(f_s/(f_stop - f_pass)*stopband_ripple/22);


% We do freq * 2 / samp_freq to get ratio between passband frequency and
% nquist frequency

% Remez filter
h1 = firpm(N,[0 f_pass f_stop f_s/2]/(f_s/2), [1 1 0 0], [1 10]);

% Modified Remez filter
h2 = firpm(N,[0 f_pass f_stop f_s/2]/(f_s/2), {'myfrf', [1 1 0 0]}, [1 10]);

% Window sinc filter
cc=1.45;
sinc_filter =sinc((-4-1/8:1/8:4+1/8)*cc);
h3 = sinc_filter.*kaiser(length(sinc_filter),5.8)'; 
scl = 8/cc;
h3 = h3/scl;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Impulse Response

figure(1)
subplot(3,1,1)
plot(0:length(h1)-1,h1,'linewidth',2)
grid on
% axis([0 50 -0.05 0.20])
set(gca,'fontsize',14)
set(gca,'xtick',[0:5:50])
title('Impulse response, Remez','fontsize',14)
xlabel('Time Index','fontsize',14)
ylabel('Amplitude','fontsize',14)


subplot(3,1,2)
plot(0:length(h2)-1,h2,'linewidth',2)
grid on
% axis([0 50 -0.05 0.20])
set(gca,'fontsize',14)
set(gca,'xtick',[0:5:50])
title('Impulse response, Remez','fontsize',14)
xlabel('Time Index','fontsize',14)
ylabel('Amplitude','fontsize',14)

subplot(3,1,3)
plot(0:length(h3)-1,h3,'linewidth',2)
grid on
% axis([0 50 -0.05 0.20])
set(gca,'fontsize',14)
set(gca,'xtick',[0:5:70])
title('Impulse response, Remez','fontsize',14)
xlabel('Time Index','fontsize',14)
ylabel('Amplitude','fontsize',14)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Log magnitude frequency response

% Remez filter
figure(2)
fft_h1 = 20*log10(abs(fftshift(fft(h1,4096))));
plot(-0.5:1/4096:0.5-1/4096,fft_h1,'linewidth',2)
grid on
axis([-0.5 0.5 -100 10])
set(gca,'fontsize',14)
title('Log magnitude frequency response for Remez filter')
xlabel('Normalized frequency')
ylabel('Log Magnitude (dB)')

axes('position',[0.596 0.25 0.231 0.128])
plot(-0.5:1/4096:0.5-1/4096,fft_h1,'linewidth',2)
grid on
axis([-0.1 0.1 -0.15 0.1])
title('Zoom to Passband Ripple','fontsize',14)
xlabel('Frequency','fontsize',14)
ylabel('(dB)','fontsize',14)

% Modified Remez filter
figure(3)
fft_h2 = 20*log10(abs(fftshift(fft(h2,4096))));
plot(-0.5:1/4096:0.5-1/4096,fft_h2,'linewidth',2)
grid on
axis([-0.5 0.5 -100 10])
set(gca,'fontsize',14)
title('Log magnitude frequency response for modified Remez filter')
xlabel('Normalized frequency')
ylabel('Log Magnitude (dB)')

axes('position',[0.596 0.25 0.231 0.128])
plot(-0.5:1/4096:0.5-1/4096,fft_h2,'linewidth',2)
grid on
axis([-0.1 0.1 -0.15 0.1])
title('Zoom to Passband Ripple','fontsize',14)
xlabel('Frequency','fontsize',14)
ylabel('(dB)','fontsize',14)

% sinc filter
figure(4)
fft_h3 = 20*log10(abs(fftshift(fft(h3,4096))));
plot(-0.5:1/4096:0.5-1/4096,fft_h3,'linewidth',2)
grid on
axis([-0.5 0.5 -100 10])
set(gca,'fontsize',14)
title('Log magnitude frequency response for sinc filter')
xlabel('Normalized frequency')
ylabel('Log Magnitude (dB)')

axes('position',[0.596 0.25 0.231 0.128])
plot(-0.5:1/4096:0.5-1/4096,fft_h3,'linewidth',2)
grid on
axis([-0.1 0.1 -0.15 0.1])
title('Zoom to Passband Ripple','fontsize',14)
xlabel('Frequency','fontsize',14)
ylabel('(dB)','fontsize',14)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Zero Pole

figure(5)
set(gcf, 'WindowState', 'maximized');
subplot(2,2,1)
plot(0,0)
plot(exp(1i*2*pi*(0:0.01:1)),'b','linewidth',2)
hold on
plot(roots(h1),'ro','linewidth',2)
hold off
grid on
axis('equal')
axis([-1.2 1.2 -1.2 1.2])
title('Zero-pole: Remez filter')

subplot(2,2,2)
plot(0,0)
plot(exp(1i*2*pi*(0:0.01:1)),'b','linewidth',2)
hold on 
plot(roots(h2),'ro','linewidth',2)
hold off
grid on
axis('equal')
axis([-1.2 1.2 -1.2 1.2])
title('Zero-pole: Modified Remez filter')

subplot(2,1,2)
plot(0,0)
plot(exp(1i*2*pi*(0:0.01:1)),'b','linewidth',2)
hold on 
plot(roots(h3),'ro','linewidth',2)
hold off
grid on
axis('equal')
axis([-1.2 1.2 -1.2 1.2])
title('Zero-pole: Sinc filter')