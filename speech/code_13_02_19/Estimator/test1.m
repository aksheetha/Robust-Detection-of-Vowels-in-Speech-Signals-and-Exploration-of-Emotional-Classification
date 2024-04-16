clear all;
close all;
% Step 0: Reading the File & initializing the Time and Freq.
    [x,fs]=audioread('enhancedSA1.wav');
    ts=1/fs;
    N=length(x);
    Tmax=(N-1)*ts;
    fsu=fs/(N-1);
    t=(0:ts:Tmax);
    f=(-fs/2:fsu:fs/2);
    figure, subplot(411),plot(t,x),xlabel('Time'),title('Original audio');
    subplot(412),plot(f,fftshift(abs(fft(x)))),xlabel('Freq (Hz)'),title('Frequency Spectrum');
% Step 1: Pre-Emphasis
% 
% a=[1];
%     b=[1 -0.95];
%     y=filter(b,a,x);
%     subplot(413),plot(t,y),xlabel('Time'),title('Signal After High Pass Filter - Time Domain');
%     subplot(414),plot(f,fftshift(abs(fft(y)))),xlabel('Freq (Hz)'),title('Signal After High Pass Filter - Frequency Spectrum');
% Step 2: Frame Blocking
     frameSize=1000;
%     frameOverlap=128;
%     frames=enframe(y,frameSize,frameOverlap);
%     NumFrames=size(frames,1);
frame_duration=0.06;
frame_len = frame_duration*fs;
framestep=0.01;
framestep_len=framestep*fs;
% N = length (x);
num_frames =floor(N/frame_len);
% new_sig =zeros(N,1);
% count=0;
% frame1 =x(1:frame_len);
% frame2 =x(frame_len+1:frame_len*2);
% frame3 =x(frame_len*2+1:frame_len*3);
frames=[];
for j=1:num_frames
     frame=x((j-1)*framestep_len + 1: ((j-1)*framestep_len)+frame_len);
%     frame=x((j-1)*frame_len +1 :frame_len*j);
%     identify the silence by finding frames with max amplitude less than
%     0.025
max_val=max(frame);
   if (max_val>0.025)
%     count = count+1;
%     new_sig((count-1)*frame_len+1:frame_len*count)=frames;
        frames=[frames;frame];
   end
end
% Step 3: Hamming Windowing
NumFrames=size(frames,1);
hamm=hamming(1000)';

    windowed = bsxfun(@times, frames, hamm);
    % Step 4: FFT 
% Taking only the positive values in the FFT that is the first half of the frame after being computed. 
    ft = abs( fft(windowed, 480, 2) );
    
    
% Step 5: Mel Filterbanks
Lower_Frequency = 100;
Upper_Frequency = fs/2;
% With a total of 22 points we can create 20 filters.
    Nofilters=20;
    lowhigh=[300 fs/2];
    %Here logarithm is of base 'e'
    lh_mel=1125*(log(1+lowhigh/700));
    mel=linspace(lh_mel(1),lh_mel(2),Nofilters+2);
    melinhz=700*(exp(mel/1125)-1);
    %Converting to frequency resolution
    fres=floor(((frameSize)+1)*melinhz/fs); 
    %Creating the filters
    for m =2:length(mel)-1
        for k=1:frameSize/2
             if k<fres(m-1)
                H(m-1,k) = 0;
            elseif (k>=fres(m-1)&&k<=fres(m))
                H(m-1,k)= (k-fres(m-1))/(fres(m)-fres(m-1));
            elseif (k>=fres(m)&&k<=fres(m+1))
               H(m-1,k)= (fres(m+1)-k)/(fres(m+1)-fres(m));
            elseif k>fres(m+1)
                H(m-1,k) = 0;    
             end
       end
    end
    %H contains the 20 filterbanks, we now apply it to the
    %processed signal.
    
    for i=1:NumFrames
        for j=1:Nofilters
            bankans(i,j)=sum((ft(i,:).*H(j,1:480)).^2);
        end
    end
    
    % Step 6: Nautral Log and DCT
%     pkg load signal
    %Here logarithm is of base '10'
    mfcc = [];
    logged=log10(bankans);
    for i=1:NumFrames
        mfcc(i,:)=dct2(logged(i,:));
    end
    %plotting the MFCC
    figure 
    hold on
    for i=1:NumFrames
        plot(mfcc(i,1:13));
    end
    hold off
% save c5 mfcc
i= mfcc;
save i i
load i.mat
X=i;
k=1;
[IDXi,ci] = kmeans(X,k);
save c41i ci
mfcccombined.m
Displaying mfcccombined.m.