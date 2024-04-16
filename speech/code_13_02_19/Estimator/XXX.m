clear all
hold off
% parameters
srate=1000;
t=1:99/srate:10;
noiseAmplitude=2;
a=4;
f=4;
%signal
signal=a*sin(2*pi*f*t);
noise= signal + noiseAmplitude*randn(1,length(signal));
standdev=std(noise);
P=find(diff(noise<-standdev)==1);
for i=1:length(P)
  offset = min(10, size(noise,2)-P(i));
  M(i,:)=noise(P(i):P(i)+offset);
end
% for i=1:length(P)
%     M(i,:)=noise(P(i):P(i)+10); %(<-- ERROR: index exceeds matrix dimensions)
% end
plot(M)