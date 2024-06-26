clear all;
close all;
clc;
addpath(genpath('/home/acer/new_work1/nlm_denoise'));
addpath(genpath('/home/acer/my_work/exp_noisy/speech_enhan/MSS_Estimators'));
clean_file_path='/home/acer/my_work/exp_noisy/speech_enhan/composite/in_path.txt';
clean_file_path=textread(clean_file_path,'%s');
noisy_file_path='/home/acer/my_work/exp_noisy/speech_enhan/composite/out_path.txt';
noisy_file_path=textread(noisy_file_path,'%s');
noise_file_path='/home/acer/my_work/new_paper/analysis_code/noise_path.txt';
noise_file_path=textread(noise_file_path,'%s');
 for j=1:1%size(noise_file_path);
 noise_path=char(noise_file_path(j,:));
llr_mean1=0;segSNR1=0;wss_dist1=0;pesq_mos1=0;
      for i=1:10%size(clean_file_path)
    i
    cleanFile=char(clean_file_path(i,:));
    enhancedFile=char(noisy_file_path(i,:));
    speech_clean=audioread(cleanFile);
    fs=8000;
[Noise,Fs1]=audioread(noise_path);
Noise = resample(Noise,fs,Fs1);
Noise = Noise(1:length(speech_clean));  
speech_noise=addnoise(speech_clean,Noise,5);
speech_noise=speech_noise-mean(speech_noise);
speech_noise=speech_noise./max(abs(speech_noise));
[xfinal]=mss_mmse_spzc_snru1(speech_noise',8000,'enhanced_map.wav');
%---------------------------------------------------------------------------
% % % 
% % % [cA,cD] = dwt(speech_noise,'db10');
% % % 
% % % 
% % % 
% % % PatchHW1=2;
% % %  P1=100;
% % % 
% % %  targetSNR_lin=10.^(0./10);
% % %  signalPower = var(cA);
% % %  targetNoiseSigma = sqrt(signalPower/targetSNR_lin);
% % %  lambda1=.4*targetNoiseSigma;
% % %  
% % %  [n1, Z] = NLM_1d(cA,lambda1,P1,PatchHW1);
% % %  
% % %  
% % %  
% % %  
% % %  
% % % 
% % %   
% % %  %%%%%%%%%%%%%%%%%%%%%%%%%%
% % %  PatchHW2=5;
% % %  P2=200;
% % % 
% % %  targetSNR_lin=10.^(0./10);
% % %  signalPower = var(cD);
% % %  targetNoiseSigma = sqrt(signalPower/targetSNR_lin);
% % %  lambda2=.9*targetNoiseSigma;
% % %   
% % % 
% % %  
% % %  [n2, Z] = NLM_1d(cD,lambda2,P2,PatchHW2);
% % % %  figure;
% % % %  subplot(211);plot(cD)
% % % %  subplot(212);plot(n2)
% % %  de = idwt(n1,n2,'db10');
% % %  wavwrite(de,'enhanced_nlm.wav')
%---------------------------------------------------------------------------

[Csig,Cbak,Covl,llr_mean,segSNR,wss_dist,pesq_mos]= composite(cleanFile,'enhanced_map.wav');
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
