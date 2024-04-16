clear all;
close all;
clc;
clean_path='E:\speech\code_13_02_19\input\in.txt';

clean_path1=textread(clean_path,'%s');

noise_path='E:\speech\code_13_02_19\NoiseX_92\noise_p.txt';

noise_path1=textread(noise_path,'%s');

speech = input('input index of speech : ');

noise = input('input index of noise : ');

figure();

t=1;

for i= 1:1
    
    filename=char(clean_path1(speech,:));
    
    outfile=char(noise_path1(noise(i),:));
    
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
    
    PatchHW=16;
    
            P =160;
            
            targetSNR_lin=10.^(0./10);
            
            signalPower =  var(speech_noise);
            
            targetNoiseSigma = sqrt(signalPower/targetSNR_lin);
            
            lambda=.8*targetNoiseSigma;
            
            [speech_enhanced,Z] = NLM_1d( speech_noise,lambda,P,PatchHW);
             audiowrite('enhanced_nlm.wav',speech_enhanced,fs);
            [Csig,Cbak,Covl,llr_mean,segSNR1,wss_dist,pesq_mos]= composite(clean_path,'enhanced_nlm.wav');
            
           
            subplot(3,1,i);plot(speech_clean);title(' speech signal ');
            subplot(3,1,i+1);plot(speech_noise);title(' noise + speech signal ');
            subplot(3,1,i+2);plot(speech_enhanced);title(' enhanced speech signal ');
end     