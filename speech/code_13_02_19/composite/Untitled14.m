clear all;
close all;
clc;

clean_path='E:\speech\code_13_02_19\input\in_1.txt';
clean_path1=textread(clean_path,'%s');

noise_path='E:\speech\code_13_02_19\NoiseX_92\noise_1.txt';
noise_path1=textread(noise_path,'%s');

for j=1:1
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
    speech_noise=addnoise(speech_clean,Noise,5);
     wavwrite(speech_clean,fs,'cleanf_5.wav');
    wavwrite(noisy_data,fs,'noisy_5.wav');
    
     x = kalu('cleanf_6.wav','noisy_6.wav');
     
     
            wavwrite(x,fs,'enhanced_out6.wav');
            figure();
            subplot(311);plot(speech_clean);
            subplot(312);plot(speech_noise);
            subplot(313);plot(x);
    
    
    [Csig,Cbak,Covl,llr_mean,segSNR,wss_dist,pesq_mos]= composite('cleanf_.wav','enhanced_out.wav');
    
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