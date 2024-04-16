[S, FS] = wavread('E:\speech\code_13_02_19\input\SA2.wav');  %Replace wavread input with  your file name
IS = 0.3; %replace with your value
OUTPUT = SSBoll79(S, FS, IS)