clc;
close all;
clear all;

clean_path='E:\speech\code_13_02_19\input\in.txt';
clean = textread(clean_path,'%s')
noise_path='E:\speech\code_13_02_19\NoiseX_92\noise_p.txt';
noise1 = textread(noise_path,'%s')


for kk = 1:1
    
    outfile=char(noise1(kk,:))
    [noisy_data, fs1]= audioread(outfile)
     Noise=resample(noisy_data,fs,fs1);
    snr=[0 5 10 15];
     
    for mm = length(snr) 
    
          for j = 1:1
        clean = textread(clean_path,'%s')
        filename=char(clean(j,:))
        [data1]= audioread(filename)
        data=resample(data1,1,2);
        out3=data-mean(data);
        out2=out3/max(abs(out3));
        Srate=8000;
        [speech_clean,fs]= audioread(filename);
         Noise=Noise(1:length(speech_clean));
         speech_noise=addnoise(speech_clean,Noise,5);
          PatchHW=16;
    
            P =160;
            
            targetSNR_lin=10.^(0./10);
            
            signalPower = var(speech_noise);
            
            targetNoiseSigma = sqrt(signalPower/targetSNR_lin);
            
            lambda=.8*targetNoiseSigma;
            
            [speech_enhanced,Z] = NLM_1d( speech_noise,lambda,P,PatchHW);
            figure();
            
            subplot(311);plot(speech_clean);
            subplot(312);plot(speech_noise);
            subplot(313);plot(speech_enhanced);
          end
    end
end

        
