addpath(genpath('E:\speech\code_13_02_19\composite'));
path=('E:\speech\code_13_02_19\input\in_path.txt');  %Replace wavread input with  your file name
path=textread(path, '%s');
for ii = 1:100
    clean=char(path(ii,:));
    [speech_clean,fs]=audioread(clean);
    wavwrite(speech_clean,fs,'cleanF.wav');
    OUTPUT=SSBerouti79('cleanF.wav',fs, 0.3);

end