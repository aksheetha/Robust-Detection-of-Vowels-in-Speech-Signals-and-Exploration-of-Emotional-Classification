clear all;
close all;
clc;
addpath(genpath('C:\Users\Love & Thunder\Downloads\Compressed\composite'));
clean_path='E:\speech\code_13_02_19\input\in.txt';

clean_path1=textread(clean_path,'%s');

noise_path='E:\speech\code_13_02_19\NoiseX_92\noise_p.txt';

noise_path1=textread(noise_path,'%s');
 
snr=[0 5 10 15];
for mm= 2:2 %length(snr)  

for i=3:3;
    i;
   cleanFile=char(clean_path1(i,:));
for j =1:1
    j;
    outfile=char(noise_path1(j,:));
    
     [data1]= audioread(cleanFile);
    
     data=resample(data1,1,2);
     
     out3=data-mean(data);
     
     out2=out3/max(abs(out3));
     
     Srate=8000;
     
    [speech_clean,fs]= audioread(cleanFile);
    
    [noisy_data, fs1]= audioread(outfile);
    
    Noise=resample(noisy_data,fs,fs1);
    
    Noise=Noise(1:length(speech_clean));
    
    speech_noise=addnoise(speech_clean,Noise,snr(mm));
    
    PatchHW=160;
    
            P =160;
            
            targetSNR_lin=10.^(0./10);
            
            signalPower = var(speech_noise);
            
            targetNoiseSigma = sqrt(signalPower/targetSNR_lin);
            
            lambda=.8*targetNoiseSigma;
            
            [speech_enhanced,Z] = NLM_1d( speech_noise,lambda,P,PatchHW);
             audiowrite('enhanced_nlm.wav',speech_enhanced,fs);
           [data1, Srate1]= audioread(cleanFile);
%             [Csig,Cbak,Covl,llr_mean,segSNR1,wss_dist,pesq_mos]= composite(filename,'enhanced_nlm.wav');
           % [Csig,Cbak,Covl,llr_mean,segSNR,wss_dist,pesq_mos]= composite('E:\speech\code_13_02_19\input\SA1.wav', 'enhanced_nlm.wav')
           figure();
            
            subplot(231);plot(speech_clean);title('Clean Speech');
            subplot(232);plot(speech_noise);title ('Clean Speech with Noise');
            subplot(233);plot(speech_enhanced);title('Enhanced Speech');
            subplot(234);spectrogram(speech_clean);title('Spectrogram of Clean Speech');
            subplot(235);spectrogram(speech_noise);title('Spectrogram of Mixed Speech');
            subplot(236);spectrogram(speech_enhanced);title('Spectrogram of Enhanced Speech');           
    end
end
      end
