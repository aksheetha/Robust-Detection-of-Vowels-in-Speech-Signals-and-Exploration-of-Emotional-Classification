clc;
close all;
clear all;

clean_path = 'E:\speech\code_13_02_19\input\in.txt';
clean_path_1 = textread(clean_path,'%s');
noise_path = 'E:\speech\.Trash-1000\files\MSS_Estimators\data\path_1.txt';
noise_path_1 = textread(noise_path,'%s');

for i=1:18
    i;
    filename = char(clean_path_1(i,:));
    outfile = char(noise_path_1(i,:));
    data1 = audioread(filename);
    data=resample(data1,1,2);
    out3=data-mean(data);
    out2=out3/max(abs(out3));
    Srate=8000;
    PatchHW=16;  
    P =160;                           
    targetSNR_lin=10.^(0./10);       
    signalPower = var(out2);
    targetNoiseSigma = sqrt(signalPower/targetSNR_lin);
    lambda=.4*targetNoiseSigma;
    [nlm] = NLM_1d( out2,lambda,P,PatchHW);
    clean_signal=diff(nlm);
    clean_signal=clean_signal/max(abs(clean_signal));
    figure();
    plot(nlm);
end