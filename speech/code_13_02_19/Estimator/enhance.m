close all;
clear all;
clc;
s = 'E:\speech\code_13_02_19\input\SA'; %path of the clean speech
for j=1:18
            figure(j);   %for plot name
            
            x = strcat(s,int2str(j),'.WAV'); %string concatenation
            
            [speech_clean,Fs]=audioread(x);  %reading the clean speech
            
            speech_clean=resample(speech_clean,1,2); %resampling the clean speech 
            
            speech_clean=speech_clean/max(abs(speech_clean)); %
            
            fs=8000;
            
            [Noise,Fs1]=audioread('E:\speech\code_13_02_19\NoiseX_92\volvo.wav');
            
            Noise = resample(Noise,fs,Fs1);
            
            Noise = Noise(1:length(speech_clean));
            
            speech_noise=addnoise(speech_clean,Noise,0);
            
            speech_noise=speech_noise-mean(speech_noise);
            
            speech_noise=speech_noise./max(abs(speech_noise));
            
            PatchHW=16;
            P =160;
            targetSNR_lin=10.^(0./10);
            signalPower = var(speech_noise);
            targetNoiseSigma = sqrt(signalPower/targetSNR_lin);
            lambda=.8*targetNoiseSigma;
            [speech_enhanced,Z] = NLM_1d(speech_noise,lambda,P,PatchHW);
            figure(j);
            subplot(311);plot(speech_clean);
            subplot(312);plot(speech_noise);
            subplot(313);plot(speech_enhanced);
end