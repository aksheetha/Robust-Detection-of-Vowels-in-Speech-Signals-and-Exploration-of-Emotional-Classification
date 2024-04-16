clear all;
close all;
clc;
addpath(genpath('E:\speech\code_13_02_19\ICS'));
addpath(genpath('E:\speech\code_13_02_19\fAI'));
addpath(genpath('E:\speech\code_13_02_19\GA_code'));
addpath(genpath('E:\speech\code_13_02_19\Estimator'));

clean_file_path='E:\speech\code_13_02_19\input\in.txt';
clean_file_path=textread(clean_file_path,'%s');

noisy_file_path='E:\speech\code_13_02_19\NoiseX_92\noise_p.txt';
noisy_file_path=textread(noisy_file_path,'%s');

noise_file_path1='E:\speech\code_13_02_19\NoiseX_92\noise_p.txt';
noise_file_path1=textread(noise_file_path1,'%s');

for j=2:2%size(noise_file_path);
    j
 noise_path=char(noise_file_path1(j,:)); 
llr_mean1=0;segSNR1=0;wss_dist1=0;pesq_mos1=0;

for i=1:10%size(clean_file_path)
    i
    cleanFile=char(clean_file_path(i,:));
    enhancedFile=char(noisy_file_path(i,:));
    [speech_clean, fs]=audioread(cleanFile);
    [Noise,Fs1]=audioread(cleanFile);
    Noise = resample(Noise,fs,Fs1);
    Noise= Noise(1:length(speech_clean));  
    speech_noise=addnoise(speech_clean,Noise,5);
    speech_noise=speech_noise./max(abs(speech_noise));
    wavwrite(speech_noise,'noisy.wav')
    wavwrite(speech_clean,fs,'clean.wav') 
    %[xfinal]=mss_mmse_spzc_snru1(speech_noise',8000,'enhanced_map1.wav');
    %ics('noisy.wav','clean.wav','enhanced.wav',-10,-5);
    %fAI('clean.wav','noisy.wav');
    GA_SE('noisy.wav','enhanced.wav');
    %mss_smpo('noisy.wav','enhanced.wav');
    %weiner('clean.wav','noisy.wav');
    
    [Csig,Cbak,Covl,llr_mean,segSNR,wss_dist,pesq_mos]= composite('cleanf.wav','enhanced.wav');
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