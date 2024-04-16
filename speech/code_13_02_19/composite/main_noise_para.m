clear all;
close all;
clc;
addpath('E:\speech\code_13_02_19\ICS');
addpath(genpath('E:\speech\code_13_02_19\GA_code'));
addpath(genpath('E:\speech\code_13_02_19\fAI'));
addpath(genpath('E:\speech\code_13_02_19\Estimator'))

clean_file_path='E:\speech\code_13_02_19\input\in.txt';
clean_file_path=textread(clean_file_path,'%s');

noisy_file_path='E:\speech\code_13_02_19\NoiseX_92\noise.txt';
noisy_file_path=textread(noisy_file_path,'%s');

for jj=1:1%size(noise_file_path);
    jj
    noise_path=char(noisy_file_path(jj,:));
    
    snr=[0 5 10 15];
   
    for kk=2:2%length(snr)
    llr_mean1=0;segSNR1=0;wss_dist1=0;pesq_mos1=0;
    
    for ii=1:10%size(clean_file_path)
    ii
        cleanFile=char(clean_file_path(ii,:));
        [speech_clean,fs]=audioread(cleanFile);
        [Noise,Fs1]=audioread(noise_path);
        Noise = resample(Noise,fs,Fs1);
        Noise= Noise(1:length(speech_clean));
        speech_noise=addnoise(speech_clean,Noise,snr(kk));
        speech_noise=speech_noise./max(abs(speech_noise));
        wavwrite(Noise,fs,'noisy.wav');    
        wavwrite(speech_clean,fs,'cleanFile.wav');
        %[xfinal]=mss_mmse_spzc_snru1(speech_noise',fs,'enhanced_map1.wav');
        %ics('noisy.wav','cleanFile.wav','enhanced.wav',-10,-5)
        %GA_SE('noisy.wav','enhanced.wav');
        %fAI('cleanFile.wav','noisy.wav','enhanced.wav');
        %mss_smpo('noisy.wav','enhanced.wav');
        %weiner('cleanFile.wav','noisy.wav');
        %mss_mmse_spzc('noisy.wav', 'out1.wav')
        %kalu('cleanFile.wav','noisy.wav');
        [Csig,Cbak,Covl,llr_mean,segSNR,wss_dist,pesq_mos]= composite('cleanFile.wav','enhanced.wav');
        llr_mean1=llr_mean1+llr_mean;
        segSNR1=segSNR1+segSNR;
        wss_dist1=wss_dist1+wss_dist;
        pesq_mos1=pesq_mos1+pesq_mos;
        end
        SNRseg=segSNR1/length(clean_file_path);
        LLR=llr_mean1/length(clean_file_path);
        WSS=wss_dist1/length(clean_file_path);
        PESQ=pesq_mos1/length(clean_file_path);
        para=[LLR SNRseg WSS PESQ]
    end
end