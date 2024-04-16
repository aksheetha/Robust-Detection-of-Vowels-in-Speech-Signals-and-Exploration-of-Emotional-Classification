clc;
clear all;
close all;
 
addpath(genpath('E:\speech\code_13_02_19\ICS'));
clean='E:\speech\code_13_02_19\input\in1.txt';
clean=textread(clean,'%s');

noise='E:\speech\code_13_02_19\NoiseX_92\noise1.txt';
noise=textread(noise,'%s');

for jj=1:1%size(noise_file_path);
    jj
    noiseFile=char(noise(jj,:));
    
    snr=[0 5 10 15];
    
    for kk=2:2 %length(snr)
    llr_mean1=0;segSNR1=0;wss_dist1=0;pesq_mos1=0; 
    
    for ii=1:10
        ii
        cleanFile=char(clean(ii,:));
        [speech_clean,fs]=audioread(cleanFile);
        [Noise,Fs1]=audioread(noiseFile);
        Noise = resample(Noise,fs,Fs1);
        Noise= Noise(1:length(speech_clean));
        speech_noise=addnoise(speech_clean,Noise,snr(kk));
        speech_noise=speech_noise./max(abs(speech_noise));
        wavwrite(Noise,fs,'noisy.wav');    
        wavwrite(speech_clean,fs,'cleanF.wav');
        %[xfinal]=mss_mmse_spzc_snru1(speech_noise',fs,'enhanced_map2.wav');
        %ics('noise.wav','cleanFyl.wav','enhanced.wav',-10,-5)
        %fAI('cleanFyl.wav','noise.wav','enhanced.wav');
        %mss_smpo('noisy.wav','enhanced.wav');
        %weiner('cleanFy2.wav','noise2.wav');
        kalu('cleanF.wav','noisy.wav');
        
        
        [Csig,Cbak,Covl,llr_mean,segSNR,wss_dist,pesq_mos]= composite('cleanF.wav','enhancedly.wav');
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
        
        