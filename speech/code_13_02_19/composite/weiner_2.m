clc; clear all; close all;

[Signal,fs]=audioread('E:\speech\code_13_02_19\composite\cleanFile.wav');
signl=Signal;
%soundsc(signl)
[nse,Fs]=audioread('E:\speech\code_13_02_19\NoiseX_92\white.wav');
%I1=decimate(nse,4);
nse=resample(nse,fs,Fs);
noise=nse(1:length(signl));
%soundsc(noise)

num3=numel(signl);          %quantity of input signal samples
num4=numel(noise);          %quantity of noise samples
m3=ceil(num3/num4);
snr=5;
noi3=repmat(noise,m3,1);    %array of noise with length not less than num
noi3=noi3(1:num3);          %array of noise with length equals to num
sa3=sqrt(sum(signl.^2));    %numerator of power ratio
sb13=sqrt(sum(noi3.^2));    %denominator of power ratio
varargout3(1)={20*log10(sa3/sb13)}; %SNR of SIGNAL corrupted by NOI
ns3=sa3*10^(-snr/20)/sb13;  %coefficient intended to get a specified SNR
s3=noi3*ns3+(signl);        %array of corrupted signal with a specified SNR
c3=32767/32768;
% if nargin==4
%     switch  varargin{1}
%         case 8
%             c3=255/256;
%         case 24
%             c3=(2^23-1)/2^23;
%         case 16
%         case 32
%             return
%         otherwise
%             warning('The 4th argument (nbits) is wrong. Replaced by 16 (default)')
%     end
%  end
% if max(s)>c
%   s=s/max(s)*c;
% end
s3;
sig=s3;
%  plot(M1(1:75000))
winsize=8;
hamwin = hamming(winsize);
hamwin = hamwin./sum(hamwin);
windows = 1;
fs=8000;
IS=.25;            %Initial Silence or Noise Only part in seconds
W=fix(.025*fs);     %Window length is 25 ms
Sk=.4;
wnd=hamming(W);
pre_emph=0;
sig=filter([1 -pre_emph],1,sig);
NIS=fix((IS*fs-W)/(Sk*W) +1);   %number of initial silence segments
Sk=.4;
L=length(sig);
SP=fix(W.*Sk);
N=fix((L-W)/SP +1); %number of segments
pos=1;
windows=1;

wwf6=zeros(winsize,round(length(signl)/winsize));
pos=zeros(round(length(signl)/winsize));
for b=1:round(length(signl)/winsize)
    pos(1)=1;
    data1 = sig(pos(b): pos(b)+winsize-1).*(hamwin);
    wwf6(:,b) = fft(data1);
    windows = windows + 1;
    pos(b+1) = pos(b) + winsize;
end

wwf6;
Y=reshape(wwf6,length(signl),1);
YPhase=angle(Y(1:fix(wnd/2)+1,:));  %Noisy Speech Phase
Y1=abs(Y(1:length(signl),:));       %Specrogram
numberOfFrames=size(Y,2);
o=fft(noise);
son=(abs(o));

N1=mean(Y1(1:NIS,:)')';
LambdaD=mean((Y1(:,1)').^2)'
alpha=.99;
NoiseCounter=0;
NoiseLength=9;
G=ones(size(N1));
Gamma=G;
X3=zeros(size(Y));
h=waitbar(0,'Wait...');

for i=1:numberOfFrames
    %%%%%%%%    VAD and Noise Estimation START   %%%%%%%%
    if i<=NIS           %If initial silence ignore VAD
        SpeechFlag=0;
        NoiseCounter=100;
    else                %Else Do VAD
        % if nargin<4
        NoiseMargin=3;
        % end
        % if nargin<5
        Hangover=8;
        % end
        % if nargin<3
        NoiseCounter=0;
        % end
        FreqResol=length(sig);
        
        SpectralDist= 20*(log10(Y1)-log10(son));
        SpectralDist(find(SpectralDist<0))=0;
        
        Dist=mean(SpectralDist);
        if (Dist < NoiseMargin)
            NoiseFlag=1;
            NoiseCounter=NoiseCounter+1;
        else
            NoiseFlag=0;
            NoiseCounter=0;
        end
        
        % Detect noise only periods and attenuate the signal
        if (NoiseCounter > Hangover)
            SpeechFlag=0;
        else
            SpeechFlag=1;
        end
    end
    if SpeechFlag==0        %If not Speech Update Noise Parameters
        N=(NoiseLength*N+Y1(:,i))/(NoiseLength+1); %Update and smooth noise mean
        LambdaD=(NoiseLength*LambdaD+(Y1(:,i).^2))./(1+NoiseLength); %Update and smooth noise variance
    end
    gammaNew=(Y1(:,i).^2)./LambdaD;   %A postiriori SNR
    xi=alpha*(G.^2).*Gamma+(1-alpha); %Decision Directed Method for A Priori SNR
    Gamma=gammaNew;
    G=(xi./(xi+1));
    X3(:,i)=G.*Y1(:,i);         %Obtain the new Cleaned value
    waitbar(i/numberOfFrames,h,num2str(fix(100*i/numberOfFrames)));
end
X3;
M=reshape(X3,length(signl),1);
%t=idct(M);
ps=1;
% dap=[];
for j=1:length(signl)/winsize
    ps(1)=1;
    dta4=M(ps(j):ps(j)+winsize-1);
    dap(:,j)=ifft(dta4);
    ps(j+1) = ps(j) + winsize;
end
dap;
M11=reshape(dap,round(length(signl)),1);

subplot(3,1,1);
spectrogram(signl(1:20000),256,224,1024,fs,'yaxis')
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title('Spectogram of Clean speech signal')
soundsc(signl,16000);

subplot(3,1,2);
spectrogram(s3(1:20000),256,224,1024,fs,'yaxis')
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title('Spectogram of Noisy speech signal')
soundsc(s3,16000);

subplot(3,1,3);
spectrogram(500*M11(1:20000),256,224,1024,fs,'yaxis')
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title('Spectogram of Enhanced speech signal')
soundsc(M11,16000);
