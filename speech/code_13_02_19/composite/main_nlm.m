clear all;
close all;
clc;

% addpath(genpath('E:\speech\code_13_02_19\ICS'));
clean_path='E:\speech\code_13_02_19\input\in1.txt';
clean_path1=textread(clean_path,'%s');

noise_path='E:\speech\code_13_02_19\NoiseX_92\noise1.txt';
noise_path1=textread(noise_path,'%s');

for j=3:3
    j
    llr_mean1=0;segSNR1=0;wss_dist1=0;pesq_mos1=0;x=0; 

    
    for i=1:1
    i
    filename=char(clean_path1(i,:));
    outfile=char(noise_path1(j,:));
    [data1]= audioread(filename);
     data=resample(data1,1,2);
     out3=data-mean(data);
     out2=out3/max(abs(out3)); 
     Srate=8000;
    [speech_clean,fs]= audioread(filename); 
    [noisy_data, fs1]= audioread(outfile);
    Noise=resample(noisy_data,fs,fs1);
    Noise=Noise(1:length(speech_clean));
    speech_noise=addnoise(speech_clean,Noise,15);
    wavwrite(speech_clean,fs,'clean_4.wav');
    wavwrite(noisy_data,fs,'noise_4.wav');
    
 [cA,cD] = dwt(speech_noise,'db10');
 PatchHW1=2;
 P1=100;

 targetSNR_lin=10.^(0./10);
 signalPower = var(cA);
 targetNoiseSigma = sqrt(signalPower/targetSNR_lin);
 lambda1=.4*targetNoiseSigma;
 
 [n1, Z] = NLM_1d(cA,lambda1,P1,PatchHW1);
 PatchHW2=5;
 P2=200;

 targetSNR_lin=10.^(0./10);
 signalPower = var(cD);
 targetNoiseSigma = sqrt(signalPower/targetSNR_lin);
 lambda2=.9*targetNoiseSigma;

 [n2, Z] = NLM_1d(cD,lambda2,P2,PatchHW2);
%  figure;
%  subplot(211);plot(cD)
%  subplot(212);plot(n2)
 de = idwt(n1,n2,'db10');
 wavwrite(de,'enhanced_nlm.wav')
     
     
          figure();
             subplot(231);plot(speech_clean);title('Clean Speech');
            subplot(232);plot(speech_noise);title ('Clean Speech with Noise');
            subplot(233);plot(de);title('Enhanced Speech');
            subplot(234);spectrogram(speech_clean);title('Spectrogram of Clean Speech');
            subplot(235);spectrogram(speech_noise);title('Spectrogram of Mixed Speech');
            subplot(236);spectrogram(de);title('Spectrogram of Enhanced Speech');
    
    [Csig,Cbak,Covl,llr_mean,segSNR,wss_dist,pesq_mos]= composite('enhanced_nlm.wav','clean_4.wav');
    
        llr_mean1=llr_mean1+llr_mean;
        segSNR1=segSNR1+segSNR;
        wss_dist1=wss_dist1+wss_dist;
        pesq_mos1=pesq_mos1+pesq_mos;
        end
        SNRseg=segSNR1/length(clean_path1);
        LLR=llr_mean1/length(clean_path1);
        WSS=wss_dist1/length(clean_path1);
        PESQ=pesq_mos1/length(clean_path1);
        para=[LLR SNRseg WSS PESQ]
    
end