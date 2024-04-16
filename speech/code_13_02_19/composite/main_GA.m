clear all;
close all;
clc;

addpath(genpath('E:\speech\code_13_02_19\GA_code'));
clean_path='E:\speech\code_13_02_19\input\in1.txt';
clean_path1=textread(clean_path,'%s');

noise_path='E:\speech\code_13_02_19\NoiseX_92\noise1.txt';
noise_path1=textread(noise_path,'%s');

for j=1:1
    j
    llr_mean1=0;segSNR1=0;wss_dist1=0;pesq_mos1=0;x=0; 
yy=[1:5 9:13];
    for i=1:length(yy)
    i
    filename=char(clean_path1(yy(i),:));
    outfile=char(noise_path1(j,:));
%     [data fs]= audioread(filename);
%      data=resample(data1,1,2);
%      out3=data-mean(data);
%      out2=out3/max(abs(out3)); 
%      Srate=fs;
    [speech_clean,fs]= audioread(filename); 
    [noisy_data, fs1]= audioread(outfile);
    Noise=resample(noisy_data,fs,fs1);
    Noise=Noise(1:length(speech_clean));
    speech_noise=addnoise(speech_clean,Noise,5);
    wavwrite(speech_clean,fs,'cleanf_8.wav');
    wavwrite(noisy_data,fs,'noisy_8.wav');
    
     x = GA_SE('cleanf_8.wav','outf_8.wav');
     
     
            wavwrite(x,fs,'enhanced_out8.wav');
            figure();
            subplot(311);plot(speech_clean);
            subplot(312);plot(speech_noise);
            subplot(313);plot(x);
    
    
    [Csig,Cbak,Covl,llr_mean,segSNR,wss_dist,pesq_mos]= composite('cleanf_8.wav','enhanced_out8.wav');
    
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