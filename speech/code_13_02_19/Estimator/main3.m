clear all;
close all;
clc;
clean_path='E:\speech\code_13_02_19\FDRD1\SA1.WAV';
noise_path='E:\speech\code_13_02_19\NoiseX_92\white.wav';
[speech_clean, fs]=audioread(clean_path);
[noisy_data, fs1]=audioread(noise_path);
Noise=resample(noisy_data,fs,fs1);
Noise=Noise(1:length(speech_clean));
speech_noise=addnoise(speech_clean,Noise,5);

   PatchHW=16;
            P =160;
            targetSNR_lin=10.^(0./10);
            signalPower = var( speech_noise);
            targetNoiseSigma = sqrt(signalPower/targetSNR_lin);
            lambda=.8*targetNoiseSigma;
            [speech_enhanced,Z] = NLM_1d( speech_noise,lambda,P,PatchHW);
            audiowrite('enhanced_nlm.wav',speech_enhanced,fs);
            [Csig,Cbak,Covl,llr_mean,segSNR1,wss_dist,pesq_mos]= composite(clean_path,'enhanced_nlm.wav');
            figure();
            subplot(311);plot(speech_clean);
            subplot(312);plot(speech_noise);
            subplot(313);plot(speech_enhanced);
            
