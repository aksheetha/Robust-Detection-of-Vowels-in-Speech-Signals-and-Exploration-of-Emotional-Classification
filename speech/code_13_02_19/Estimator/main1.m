close all;
clear all;
clc;
s = 'E:\speech\code_13_02_19\input\SA';
for j=1:10
            figure(j);
            x = strcat(s,int2str(j),'.WAV');
            [speech_clean,Fs]=audioread(x);
            
            speech_clean=resample(speech_clean,1,2);
            speech_clean=speech_clean/max(abs(speech_clean));
            fs=8000;
            [Noise,Fs1]=audioread('E:\speech\code_13_02_19\NoiseX_92\babble.wav');
            Noise = resample(Noise,fs,Fs1);
            Noise = Noise(1:length(speech_clean));
            speech_noise=addnoise(speech_clean,Noise,0);
            
            speech_noise=addnoise(speech_clean',Noise,10);
            speech_noise=speech_noise-mean(speech_noise);
            speech_noise=speech_noise./max(abs(speech_noise));
            
            %plotting purpose
            n = length(speech_noise);
            y = fft(speech_noise);
            inputpower = abs(y).^2/n;
            inputfreq = (0:n-1)*(Fs/n);
            subplot(1,2,1)
            plot(inputfreq,inputpower);
            %----------------
            
            PatchHW=16;
            P =160;
            targetSNR_lin=10.^(0./10);
            signalPower = var( speech_noise);
            targetNoiseSigma = sqrt(signalPower/targetSNR_lin);
            lambda=.8*targetNoiseSigma;
            [denoisedSig1,Z] = NLM_1d( speech_noise,lambda,P,PatchHW);
            denoisedSig=diff(denoisedSig1);
            denoisedSig(end+1)=denoisedSig(end);
            denoisedSig=denoisedSig/max(abs(denoisedSig));
            
            audiowrite(strcat('enhancedSA',int2str(j),'.wav'),denoisedSig,8000);
            %plotting purpose
            n = length(denoisedSig);
            y = fft(denoisedSig);
            outputpower = abs(y).^2/n;
            outputfreq = (0:n-1)*(8000/n);
            subplot(1,2,2)
            plot(outputfreq,outputpower);
            %----------------
end
