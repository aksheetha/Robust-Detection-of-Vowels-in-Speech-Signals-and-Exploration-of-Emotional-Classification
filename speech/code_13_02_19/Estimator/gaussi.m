sigma=0.1;
fs=80;
t=-0.5:1/fs:0.5; %time base

%generation of gaussian pulse

variance=sigma^2;
x=1/(sqrt(2*pi*variance))*(exp(-t.^2/(2*variance)));
subplot(311);plot(t,x,'b');title(['Gaussian Pulse \sigma=', num2str(sigma),'s']);

L=length(x);
NFFT = 1024;
X = fftshift(fft(x,NFFT));
Pxx=X.*conj(X)/(NFFT*NFFT); %computing power with proper scaling
f = fs*(-NFFT/2:NFFT/2-1)/NFFT; %Frequency Vector

Pxx=X.*conj(X)/(L*L); %computing power with proper scaling
subplot(312);plot(f,10*log10(Pxx),'r');title('Double Sided - Power Spectral Density');

X = fft(x,NFFT);
X = X(1:NFFT/2+1);%Throw the samples after NFFT/2 for single sided plot
Pxx=X.*conj(X)/(L*L);
f = fs*(0:NFFT/2)/NFFT; %Frequency Vector
subplot(313);plot(f,10*log10(Pxx),'m');title('Single Sided - Power Spectral Density');

%first derivative of GP 
figure;
y=diff(x);
subplot(311);plot(y);title('First derivative of Gaussian Pulse');

L1=length(y);
NFFT = 1024;
Y = fftshift(fft(y,NFFT));
Pyy=Y.*conj(Y)/(NFFT*NFFT); %computing power with proper scaling
f = fs*(-NFFT/2:NFFT/2-1)/NFFT; %Frequency Vector

Pyy=Y.*conj(Y)/(L1*L1); %computing power with proper scaling
subplot(312);plot(f,10*log10(Pyy),'r');title('Double Sided - Power Spectral Density');

Y = fft(y,NFFT);
Y = Y(1:NFFT/2+1);%Throw the samples after NFFT/2 for single sided plot
Pyy=Y.*conj(Y)/(L1*L1);
f = fs*(0:NFFT/2)/NFFT; %Frequency Vector
subplot(313);plot(f,10*log10(Pyy),'m');title('Single Sided - Power Spectral Density');

%second derivative of GP
figure;
y1=diff(y);
subplot(311);plot(y1);title('Second derivative of Gaussian Pulse');

L2=length(y1);
NFFT = 1024;
Y1 = fftshift(fft(y1,NFFT));
Pyy1=Y1.*conj(Y1)/(NFFT*NFFT); %computing power with proper scaling
f = fs*(-NFFT/2:NFFT/2-1)/NFFT; %Frequency Vector

Pyy1=Y1.*conj(Y1)/(L2*L2); %computing power with proper scaling
subplot(312);plot(f,10*log10(Pyy1),'r');title('Double Sided - Power Spectral Density');

Y1 = fft(y1,NFFT);
Y1 = Y1(1:NFFT/2+1);%Throw the samples after NFFT/2 for single sided plot
Pyy1=Y1.*conj(Y1)/(L2*L2);
f = fs*(0:NFFT/2)/NFFT; %Frequency Vector
subplot(313);plot(f,10*log10(Pyy1),'m');title('Single Sided - Power Spectral Density');


