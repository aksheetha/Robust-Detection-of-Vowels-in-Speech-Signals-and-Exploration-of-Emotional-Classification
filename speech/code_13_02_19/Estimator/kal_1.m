clc;
clear all;
close all;

WinLenSec = 0.0025; % Window length in seconds.
HopPercent = 1; % percentage of hopping.
AROrder = 20; % Auto regressive filter order.
NumIter = 7;

[Input, Fs] = audioread('E:\speech\code_13_02_19\input\SA1.wav');
Input = Input(:,1);
[Noise,fs] = audioread('E:\speech\code_13_02_19\NoiseX_92\factory.wav');
Noise = Noise(:,1);
Noise1= resample(Noise,Fs,fs);
Noise1= Noise(1:length(Input));
NoisyInput=addnoise(Input,Noise1,5)';
Time = (0:1/Fs:(length(Input)-1)/Fs)';

%% Chopping session.
WinLenSamples = fix(WinLenSec * Fs);
Window = ones(WinLenSamples,1);
[ChoppedSignal, NumSegments] = Chopper(NoisyInput, WinLenSamples, Window, HopPercent);

%% Matrix initializations.
H = [zeros(1,AROrder-1),1];   % Measurement matrix.
R = var(Noise);     % Variance of noise.

[FiltCoeff, Q] = lpc(ChoppedSignal, AROrder);   % Finding filter coefficients.

P = R * eye(AROrder,AROrder);   % Error covariance matrix.
Output = zeros(1,size(NoisyInput,1));   % Allocating memory for output signal.
Output(1:AROrder) = NoisyInput(1:AROrder,1)';   % Initializing output signal according to equation (13)
OutputP = NoisyInput(1:AROrder,1);

%% Iterators.
i = AROrder+1;
j = AROrder+1;

%% Processing.
for k = 1:NumSegments   % For every segment of chopped signal...
    jStart = j;     % Keeping track of AROrder+1 value for every iteration.
    OutputOld = OutputP;    % Keeping the first AROrder amount of samples for every iteration.
    
    for l = 1:NumIter
        A = [zeros(AROrder-1,1) eye(AROrder-1); fliplr(-FiltCoeff(k,2:end))];
        
        for ii = i:WinLenSamples
            OutputC = A * OutputP;
            Pc = (A * P * A') + (H' * Q(k) * H);
            K = (Pc * H')/((H * Pc * H') + R);
            OutputP = OutputC + (K * (ChoppedSignal(ii,k) - (H*OutputC)));
            Output(j-AROrder+1:j) = OutputP';
            P = (eye(AROrder) - K * H) * Pc;
            j = j+1;
        end
        
        i = 1;
        if l < NumIter
            j = jStart;
            OutputP = OutputOld;
        end
        
        % update lpc on filtered signal
        [FiltCoeff(k,:), Q(k)] = lpc(Output((k-1)*WinLenSamples+1:k*WinLenSamples),AROrder);
    end
end
Output = Output';

%% Plotting the results
figure
plot(Input)
xlabel('Time in seconds')
ylabel('Amlitude')
title('Clean speech signal')
figure
plot(Noise)
xlabel('Time in seconds')
ylabel('Amlitude')
title('Observation noise')
figure
plot(NoisyInput)
xlabel('Time in seconds')
ylabel('Amlitude')
title('Noisy input signal')
figure
plot (Output)
xlabel('Time in seconds')
ylabel('Amlitude')
title('Estimated clean output signal')

