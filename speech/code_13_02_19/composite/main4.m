clear all;
close all;
clc;
clean_path='E:\speech\code_13_02_19\input\in_1.txt';

clean_path1=textread(clean_path,'%s');

noise_path='E:\speech\code_13_02_19\NoiseX_92\noise_1.txt';

noise_path1=textread(noise_path,'%s');

for i=1:10
    i
    for j= 1:1
        j
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
    
    wavwrite(speech_clean,fs,'cleanf.wav');
    
    speech_noise=addnoise(speech_clean,Noise,5);
    
    PatchHW=16;
    
            P =160;
            
            targetSNR_lin=10.^(0./10);
            
            signalPower = var(speech_noise);
            
            targetNoiseSigma = sqrt(signalPower/targetSNR_lin);
            
            lambda=.8*targetNoiseSigma;
            
            [speech_enhanced,Z] = NLM_1d( speech_noise,lambda,P,PatchHW);
            audiowrite('enhanced_nlm.wav',speech_enhanced,fs);
            [Csig,Cbak,Covl,llr_mean,segSNR1,wss_dist,pesq_mos]= composite('cleanf.wav','enhanced_nlm.wav');
            figure();
            
            subplot(311);plot(speech_clean);
            subplot(312);plot(speech_noise);
            subplot(313);plot(speech_enhanced);
    end
end
