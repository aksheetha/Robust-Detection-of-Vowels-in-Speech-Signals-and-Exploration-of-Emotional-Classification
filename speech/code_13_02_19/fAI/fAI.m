function predscore= fAI(cleanFile, noisyFile, enhancedFile)

% ----------------------------------------------------------------------
%  MATLAB  implementation of the intelligibility index proposed in [1]
%
%  Usage:
%   fAI(cleanFile, noisyFile, enhancedFile)
%
%   cleanFile = name of stimulus file in quiet
%   noisyFile = name of noisy (corrupted) speech file 
%   enhancedFile = name of processed file
%
%   Above call will return the fractional AI index (fAI) value, ranging
%   from 0 (poor intelligibility) to 1 (high intelligibility). For mapping 
%   of fAI values to intelligibility scores, see Fig 4 [1].
%
%   WARNING: The three input wav files need to be in correct order as shown
%            above.
%   Routine was implemented assuming telephone bandwidth (4 kHz)
%   but can be easily extended to higher sampling frequencies.
%
%   Parameters that can be changed are "gamma" and "SNRL" given in lines
%   80-81.
%
%   Authors: Jianfen Ma and Philipos C. Loizou
%
%   Reference:
%   [1] Loizou,P. and Ma, J. (2011). "Extending the articulation index to 
%       account for non-linear distortions introduced by noise-suppression 
%       algorithms," J. Acoust. Soc. Am., 130(2), 986-995.
%
%   Copyright (c) 2011 - Philipos C. Loizou
% ----------------------------------------------------------------------

if nargin~=3
    fprintf('USAGE: dist=fAI(cleanFile.wav, noisyFile.wav, enhancedFile.wav)\n');
    fprintf('       For more help, type: help fAI\n');
    return;
end


[data1, Srate1, Nbits1]= wavread(cleanFile);
[data2, Srate2, Nbits2]= wavread(enhancedFile);
[data3, Srate3, Nbits3]= wavread(noisyFile);

if ( ( Srate1~= Srate2) || ( Nbits1~= Nbits2) || (Srate1~= Srate3))
    error( 'The two files do not match in terms of sampling freq or number of bits!\n');
end

len= min(length( data1), length( data2));
data1= data1( 1: len)+eps;
data2= data2( 1: len)+eps;

dist_vec= comp_fAI(data1,data2,data3,Srate1);
%------------------------------------------
predscore=mean(dist_vec);  % compute the mean of all fAI values

%plot(dist_vec)  % show instantaneous fAI values

% ----------------------------------------------------------------------
%%
function distortion = comp_fAI(clean_speech,  processed_speech, noisy_speech, sample_rate)


% ----------------------------------------------------------------------
% Check the length of the noisy, the clean and processed speech.  Must be the same.
% ----------------------------------------------------------------------


clean_length      = length(clean_speech);
processed_length  = length(processed_speech);

if ( clean_length ~= processed_length)
  disp('Error: Files  must have same length.');
  return
end;

% ----------------------------------------------------------------------
% Set parameters

Len=50;  % window duration in ms
gamma=2;  % used in weighting function - see Eq. 7, gamma=p - for no weighting set gamma=0
SNRL =11; %11; % SNRL in dB
SNRLa=10^(SNRL/10);  % SNRL in linear units 
% ----------------------------------------------------------------------


winlength   = round(Len*sample_rate/1000); 	   % window length in samples
skiprate    = floor(winlength/4);		   % window skip in samples
max_freq    = sample_rate/2;	   % maximum bandwidth
num_crit    = 25;		   % number of critical bands
n_fft       = 2^nextpow2(2*winlength);
n_fftby2    = n_fft/2;		   % FFT size/2

% ----------------------------------------------------------------------
% Critical Band Filter Definitions (Center Frequency and Bandwidths in Hz)
% ----------------------------------------------------------------------

cent_freq(1)  = 50.0000;   bandwidth(1)  = 70.0000;
cent_freq(2)  = 120.000;   bandwidth(2)  = 70.0000;
cent_freq(3)  = 190.000;   bandwidth(3)  = 70.0000;
cent_freq(4)  = 260.000;   bandwidth(4)  = 70.0000;
cent_freq(5)  = 330.000;   bandwidth(5)  = 70.0000;
cent_freq(6)  = 400.000;   bandwidth(6)  = 70.0000;
cent_freq(7)  = 470.000;   bandwidth(7)  = 70.0000;
cent_freq(8)  = 540.000;   bandwidth(8)  = 77.3724;
cent_freq(9)  = 617.372;   bandwidth(9)  = 86.0056;
cent_freq(10) = 703.378;   bandwidth(10) = 95.3398;
cent_freq(11) = 798.717;   bandwidth(11) = 105.411;
cent_freq(12) = 904.128;   bandwidth(12) = 116.256;
cent_freq(13) = 1020.38;   bandwidth(13) = 127.914;
cent_freq(14) = 1148.30;   bandwidth(14) = 140.423;
cent_freq(15) = 1288.72;   bandwidth(15) = 153.823;
cent_freq(16) = 1442.54;   bandwidth(16) = 168.154;
cent_freq(17) = 1610.70;   bandwidth(17) = 183.457;
cent_freq(18) = 1794.16;   bandwidth(18) = 199.776;
cent_freq(19) = 1993.93;   bandwidth(19) = 217.153;
cent_freq(20) = 2211.08;   bandwidth(20) = 235.631;
cent_freq(21) = 2446.71;   bandwidth(21) = 255.255;
cent_freq(22) = 2701.97;   bandwidth(22) = 276.072;
cent_freq(23) = 2978.04;   bandwidth(23) = 298.126;
cent_freq(24) = 3276.17;   bandwidth(24) = 321.465;
cent_freq(25) = 3597.63;   bandwidth(25) = 346.136;

% NewaCaWghts =[
% 
%          0
%          0
%     0.0092
%     0.0245
%     0.0354
%     0.0398
%     0.0414
%     0.0427
%     0.0447
%     0.0472
%     0.0473
%     0.0472
%     0.0476
%     0.0511
%     0.0529
%     0.0551
%     0.0586
%     0.0657
%     0.0711
%     0.0746
%     0.0749
%     0.0717
%     0.0681
%     0.0668
%     0.0653];
% % 
% Weight=NewaCaWghts';



NewSenWghts =[
    0.0064
    0.0154
    0.0240
    0.0373
    0.0803
    0.0978
    0.0982
    0.0809
    0.0690
    0.0608
    0.0529
    0.0473
    0.0440
    0.0440
    0.0470
    0.0489
    0.0486
    0.0491
    0.0492
    0.0500
    0.0538
    0.0551
    0.0545
    0.0508
    0.0449];
Weight=NewSenWghts';

% ----------------------------------------------------------------------
% Set up the critical band filters.  Note here that Gaussianly shaped
% filters are used.  Also, the sum of the filter weights are equivalent
% for each critical band filter.  Filter less than -30 dB and set to
% zero.
% ----------------------------------------------------------------------

bw_min     = bandwidth (1);	   % minimum critical bandwidth
min_factor = exp (-30.0 / (2.0 * 2.303));       % -30 dB point of filter
    for i = 1:num_crit
        f0 = (cent_freq (i) / max_freq) * (n_fftby2);
        all_f0(i) = floor(f0);
        bw = (bandwidth (i) / max_freq) * (n_fftby2);
        norm_factor = log(bw_min) - log(bandwidth(i));
        j = 0:1:n_fftby2-1;
        crit_filter(i,:) = exp (-11 *(((j - floor(f0)) ./bw).^2) + norm_factor);
        crit_filter(i,:) = crit_filter(i,:).*(crit_filter(i,:) > min_factor);
    end


num_frames = clean_length/skiprate-(winlength/skiprate); % number of frames
start      = 1;					% starting sample
window     = 0.5*(1 - cos(2*pi*(1:winlength)'/(winlength+1)));

for frame_count = 1:num_frames

   % ----------------------------------------------------------
   % (1) Get the Frames for the test and reference speech. 
   %     Multiply by Hanning Window.
   % ----------------------------------------------------------

   clean_frame       = clean_speech(start:start+winlength-1);
   processed_frame   = processed_speech(start:start+winlength-1);
   noisy_frame       = noisy_speech(start:start+winlength-1);
   noise_frame       = noisy_frame - clean_frame;  % masker signal
   clean_frame       = clean_frame.*window;
   processed_frame   = processed_frame.*window;
   noise_frame       = noise_frame.*window;

   % ----------------------------------------------------------
   % (2) Compute the magnitudes-squared Spectrum of Clean and Processed
   % ----------------------------------------------------------
    
       clean_spec     = abs(fft(clean_frame,n_fft)).^2;
       processed_spec = abs(fft(processed_frame,n_fft)).^2; 
       noise_spec     = abs(fft(noise_frame,n_fft)).^2; 

       % ----------------------------------------------------------
   % (3) Compute Filterbank Output Energies 
   % ----------------------------------------------------------
   
   clean_energy     = zeros(1,num_crit);
   processed_energy = zeros(1,num_crit);
   noise_energy     = zeros(1,num_crit);
   W_freq           = zeros(1,num_crit);

   for i = 1:num_crit
     
      clean_energy(i)     = sum(clean_spec(1:n_fftby2) ...
                         	.*crit_filter(i,:)');
      processed_energy(i) = sum(processed_spec(1:n_fftby2) ...
                            .*crit_filter(i,:)');
      noise_energy(i)     = sum(noise_spec(1:n_fftby2) ...
                            .*crit_filter(i,:)');   
                        
      W_freq(i)=(clean_energy(i))^gamma;                                       
                        
   end

%-------------------------------------------------------------
% get the SNR and "processed" SNR in linear domain
   
   true     = (clean_energy./noise_energy);  % True SNR
   pro      = (processed_energy./noise_energy);  % Processed SNR as per Eq. 4
   
%-------------------------------------------------------------
% find bins with SNR > SNRL
%
   true_p   = zeros(1,length(true));
   pro_p    = true_p;
   ind         = find(true>=SNRLa);   %  - see Eq. 5
   true_p(ind) = true(ind);
   pro_p(ind)  = pro(ind); 
   min_p     = min(true_p,pro_p);  
   
   
   AI_p = sum(max((min_p./true_p),0).*W_freq)/sum(W_freq);   % Eq. 5 and 6

   distortion(frame_count)=AI_p;

   start = start + skiprate;
     
end

