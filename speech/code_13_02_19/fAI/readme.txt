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
%   Authors: Jianfen Ma and Philipos Loizou
%
%   Reference:
%   [1] Loizou,P. and Ma, J. (2011). "Extending the articulation index to 
%       account for non-linear distortions introduced by noise-suppression 
%       algorithms," J. Acoust. Soc. Am., 130(2), 986-995.
%

%   Example 1: 

>> fAI('S_51_09.wav','S_51_09_car_sn5.wav','S_51_09_car_sn5_scalart.wav')

ans =

    0.3082

%  Parameters that can be changed are "gamma" and "SNRL".
%  If gamma=0 (same as setting p=0 in Eq. 7) and SNRL=0 dB, then one can generate
%  bottom panel of Fig 3 in [1] (after uncommenting line 58: plot(dist_vec))
%
%  Example 2 (with above parameters) uses same sentences shown in Fig 3 [1]:
%
%  
>> fAI('S_15_01.wav','S_15_01_babble_sn0.wav','S_15_01_babble_sn0_rdc.wav')

ans =

    0.0314

