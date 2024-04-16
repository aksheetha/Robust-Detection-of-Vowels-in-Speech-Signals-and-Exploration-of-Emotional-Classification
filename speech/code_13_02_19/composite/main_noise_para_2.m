clc;
clear all;
close all;

addpath('E:\speech\code_13_02_19\ICS');
addpath(genpath('E:\speech\code_13_02_19\GA_code'));
addpath(genpath('E:\speech\code_13_02_19\fAI'));
addpath(genpath('E:\speech\code_13_02_19\Estimator'));


clean='E:\speech\code_13_02_19\input\in.txt';
clean=textread(clean,'%s');

noisy='E:\speech\code_13_02_19\NoiseX_92\noise.txt';
noisy=textread(noisy,'%s');

for jj=1:1%size(noise_file_path);
    jj
    noisyFile=char(noisy(jj,:));
    
    snr=[0 5 10 15];
    
    for kk=2:2 %length(snr)
    llr_mean1=0;segSNR1=0;wss_dist1=0;pesq_mos1=0; 
   
       for ii=1:10
        ii
        cleanFile=char(clean(ii,:));
        [speech_clean,fs]=audioread(cleanFile);
        [Noise,Fs1]=audioread(noisyFile);
        Noise = resample(Noise,fs,Fs1);
        Noise= Noise(1:length(speech_clean));
        speech_noise=addnoise(speech_clean,Noise,snr(kk));
        speech_noise=speech_noise./max(abs(speech_noise));
        wavwrite(Noise,fs,'noisy.wav');    
        wavwrite(speech_clean,fs,'cleanF.wav');
        %[xfinal]=mss_mmse_spzc_snru1(speech_noise',fs,'enhanced_map1.wav');
        %ics('noisy.wav','cleanF.wav','enhanced.wav',-10,-5)
        %fAI('cleanF.wav','noisy.wav','enhanced.wav');
        %mss_smpo('noisy.wav','enhanced.wav');
        weiner('cleanF.wav','noisy.wav');
        %kalu('cleanF.wav','noisy.wav');
        
        
        [Csig,Cbak,Covl,llr_mean,segSNR,wss_dist,pesq_mos]= composite('cleanF.wav','enhanced.wav');
        llr_mean1=llr_mean1+llr_mean;
        segSNR1=segSNR1+segSNR;
        wss_dist1=wss_dist1+wss_dist;
        pesq_mos1=pesq_mos1+pesq_mos;
        end
        SNRseg=segSNR1/length(cleanFile);
        LLR=llr_mean1/length(cleanFile);
        WSS=wss_dist1/length(cleanFile);
        PESQ=pesq_mos1/length(cleanFile);
        para=[LLR SNRseg WSS PESQ]
    end
end
        