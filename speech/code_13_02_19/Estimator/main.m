clc;
clear all;
close all;
 
input_file_path='E:\speech\code_13_02_19\NoiseX_92\noise_p.txt';
input_file_path=textread(input_file_path,'%s');
out_path='E:\speech\.Trash-1000\files\MSS_Estimators\out.wav';
outfile_text=textread(out_path,'%s');
%addpath(genpath('/home/acer/my_work/exp_noisy/speech_enhan/SSF_INTERSPEECH2010'));
%noi={'BN0dB','BN1dB','BN2dB','BN3dB','BN4dB','BN5dB','BN10dB','BN15dB',};
noise_db=0;
for i=1:1
    i
    filename=char(input_file_path(i,:));
    outfile=char(outfile_text(i,:));
    [data1] = audioread(filename);
     data=resample(data1,1,2);
%     [noise_data,samp_frequency,nbit]=wavread('/home/acer/my_work/new_paper/NoiseX_92/babble.wav');
%     noise_resample=resample(noise_data,8000,samp_frequency);
%     noise_resample_datalen=noise_resample(1:length(data));
%     [out5]=addnoise(data,noise_resample_datalen,noise_db);
    out3=data-mean(data);
    out2=out3/max(abs(out3));
    Srate=8000;
   % output=SSBoll79(out2,8000,.25)
   % [xfinal]=mss_map1(out2,Srate);
     PatchHW=16;  
     P =160;                
%            
     targetSNR_lin=10.^(0./10);       
     signalPower = var( out2);
% 
     targetNoiseSigma = sqrt(signalPower/targetSNR_lin);
% 
     lambda=.4*targetNoiseSigma;
     [nlm] = NLM_1d( out2,lambda,P,PatchHW);
     clean_signal=diff(nlm);
     clean_signal=clean_signal/max(abs(clean_signal));
%      audiowrite(clean_signal,outfile,160,16);
end
    
  
  




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






