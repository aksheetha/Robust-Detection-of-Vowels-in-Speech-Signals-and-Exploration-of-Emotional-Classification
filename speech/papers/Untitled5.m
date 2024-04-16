% % t = 0:0.001:2;
% x = chirp(t,100,1,200,'quadratic');
% spectrogram(x,128,120,128,1e3)

Fs = 1000;
t = 0:1/Fs:2-1/Fs;
y = chirp(t,100,1,200,'quadratic');
spectrogram(y,100,80,100,Fs,'yaxis')
view(-77,72)
shading interp
colorbar off