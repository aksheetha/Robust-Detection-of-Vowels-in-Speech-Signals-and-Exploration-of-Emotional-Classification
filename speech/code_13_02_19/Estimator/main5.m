close all;      
clear all;
clc;
%giving input .wav files and one noise file and then enhance
s = 'E:\speech\code_13_02_19\input\SA'; %path of the clean speech
noisy = 'E:\speech\code_13_02_19\NoiseX_92\noise_';
for kk=1:2
     noisy_path = strcat(noisy,int2str(kk),'.WAV') %string concatenation
     snr=[0 5 10 15];
      for mm=2:2%length(snr)      
            
for j=1:1
%             figure(j);   %for plot name
            
            x = strcat(s,int2str(j),'.WAV'); %string concatenation
            
            [speech_clean,Fs]=audioread(x);  %reading the clean speech
            
            speech_clean=resample(speech_clean,1,2); %resampling the clean speech 
            
            
            
            speech_clean=speech_clean/max(abs(speech_clean)); %
            
            fs=8000;
            
            [Noise,Fs1]=audioread(noisy_path);
            
            Noise = resample(Noise,fs,Fs1);
            
            Noise = Noise(1:length(speech_clean));
            
            speech_noise=addnoise(speech_clean,Noise,snr(mm));
            
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
      end
end