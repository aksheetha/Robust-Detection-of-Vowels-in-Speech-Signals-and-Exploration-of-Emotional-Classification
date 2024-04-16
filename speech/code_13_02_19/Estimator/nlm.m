close all;
clear all;
clc;
% % % addpath(genpath('/home/acer/my_work/new_paper/code_interspeech_2017'));
% % % in_path='/home/acer/my_work/new_paper/code_interspeech_2017/avi_200.txt';
% % % input_path=textread(in_path,'%s');
% noise_file_path='/home/acer/my_work/new_paper/analysis_code/noise_path.txt';
% noise_file_path=textread(noise_file_path,'%s');
 for j=1:1%size(noise_file_path);
%  noise_path=char(noise_file_path(j,:));
% % %  c=upper(noise_path(40:40));
% % %  snr_db=[0 5 10 15];
% % %  for k=1:1%length(snr_db)
% % % %  fid=fopen('/home/acer/my_work/new_paper/result_table/n1_vop.txt','a');
% % % %  
% % % %  spd=strcat('D','_',c,'N',num2str(snr_db(k)),'dB');
% % % %  sps=strcat('S','_',c,'N',num2str(snr_db(k)),'dB');
% % % 
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % totalref_mark=0;
% % % auto_mark_vop=0;
% % % speakerno=0;
% % % VOP_det1=zeros(1,22);
% % % 
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % 
% % % for i=1:size(input_path)
    i
% % speech_path=char(input_path(i,:));
%[speech_clean,phoneme,endpoints] = audioread(speech_path);
[speech_clean,Fs]=audioread('E:\speech\code_13_02_19\input\SA1.WAV');
speech_clean=resample(speech_clean,1,2);
speech_clean=speech_clean/max(abs(speech_clean));
% % Fs=16000;
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % phinimfilename=strcat(speech_path(1:end-3),'PHN');
% % [start_point,end_point,ch]=textread(phinimfilename,'%d%d%s');
% % possi_vowel={'iy','ix','ae','aa','uw','ao','ax','ih','axr','eh','oy','ay','ey','aw','ah','ow','uh','ux','er','ax-h'};%%,'r','w','y','l','hh','hv','el'};%
% % 
% % indon=[];
% % for i=1:length(ch)
% % for j=1:length(possi_vowel)
% % if(strcmp(ch(i),possi_vowel(j))==1)
% % indon=[indon,i];
% % end
% % end
% % end
% % 
% % tt=find(diff(indon)==1);
% % indon1=indon;
% % indon2=indon;
% % indon1(tt+1)=[];
% % indon2(tt)=[];
% % 
% % 
% % VOP_ref=round(start_point(indon1)/2);
% % VEP_ref=round(end_point(indon2)/2);
% % totalref_mark=totalref_mark+length(VOP_ref);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs=8000;
 

[Noise,Fs1]=audioread("E:\speech\code_13_02_19\NoiseX_92\white.wav");
Noise = resample(Noise,fs,Fs1);
Noise = Noise(1:length(speech_clean));
  
speech_noise=addnoise(speech_clean,Noise,0);
%speech_noise=addnoise(speech_clean',Noise,10);
speech_noise=speech_noise-mean(speech_noise);
speech_noise=speech_noise./max(abs(speech_noise));


%speech_noise=speech_clean';


%[speech_noise,cf]=filterbank_linear_fir_V2(speech_noise,0,2500,8000,1,100,0);
%speech_noise=speech_noise/max(abs(speech_noise));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% enhancement NLM

PatchHW=16;
P =160;

targetSNR_lin=10.^(0./10);
signalPower = var( speech_noise);
targetNoiseSigma = sqrt(signalPower/targetSNR_lin);
lambda=.8*targetNoiseSigma;
[denoisedSig1,Z] = NLM_1d( speech_noise,lambda,P,PatchHW);
denoisedSig=diff(denoisedSig1);
denoisedSig(end+1)=denoisedSig(end);
denoisedSig=denoisedSig/max(abs(denoisedSig));
audiowrite('enhanced.wav',denoisedSig,8000);
plot(denoisedSig);
% %   [xfinal]=mss_mmse_spzc_snru1(speech_noise',8000,'enhanced.wav');
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % %  denoisedSig=xfinal;
% % % % 
% % % % [energy_con1]=energy_std(denoisedSig',5,1,fs);
% % % % she=energy_con1./max(abs(energy_con1));
% % % % she=she-mean(she);
% % % % %===================================================
% % % % she=meansmooth(she,400,0);
% % % % she=she/max(abs(she));
% % % % % she(she>.001)=0;
% % % % [she]=sigmamapping(she,20,.001,0,0);
% % % % % she=meansmooth(she,400,0);
% % % % % she(she<.5)=0;
% % % % she=she/max(abs(she));
% % % % SHE=she;
% % % % 
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % [V,Amp]=findpeaks_V4(-SHE1,400,0);
% % % % % % SHE=zeros(1,length(SHE1));
% % % % % % x=find(Amp~=0);
% % % % % % length(x)
% % % % % %  for kk=1:length(x)-2
% % % % % %     SHE(x(kk):x(kk+1))=SHE1(x(kk):x(kk+1))/max(SHE1(x(kk):x(kk+2)));     
% % % % % %  end
% % % % % % 
% % % % % % SHE(x(end-2):end)=SHE1(x(end-2):end)/max(SHE1(x(end-2):end));
% % % % 
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % %  she = RemTrend(she,8,0);
% % % % 
% % % % 
% % % % [G,Gd]= gausswin(801,100);
% % % % nc=conv(SHE,Gd);
% % % % n3=nc(401:length(nc)-400);
% % % % n3=n3/max(abs(n3));
% % % % y=n3;
% % % % 
% % % % Thre=0.003;
% % % % [VOP,pp1]=peakpicking_v1(y,Thre);
% % % % 
% % % % 
% % % % 
% % % % 
% % % % VOP1=[];
% % % % for i=1:length(VOP)
% % % % if VOP(i)>=400
% % % % VOP1=[VOP1,VOP(i)];
% % % % end
% % % % end
% % % % clear VOP
% % % % VOP=VOP1;
% % % % VOP1=[];
% % % % for i=1:length(VOP)
% % % % if VOP(i)<=length(y)-800
% % % % VOP1=[VOP1,VOP(i)];
% % % % end
% % % % end
% % % %     
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % Detected_VOP=VOP1;    
% % % % 
% % % % [VOP_det2] = performance_eva_vop_vep_v6(speech_clean,Detected_VOP,VOP_det1,VOP_ref,VEP_ref);
% % % % 
% % % % VOP_det1=VOP_det2;
% % % %     
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % %     
% % % % mar=zeros(1,length(speech_clean));
% % % % for i=1:length(VOP_ref)
% % % % mar(VOP_ref(i))=1;
% % % % end
% % % % %for i=1:length(VEP_ref)
% % % % %mar(VEP_ref(i))=-1;
% % % % %end
% % % % oneidxmar=VOP_ref;toneidxmar=oneidxmar.*(1/fs);
% % % % %oneidxmar1=VEP_ref;toneidxmar1=oneidxmar1.*(1/fs);
% % % % abcd=[1:length(speech_clean)]/fs;
% % % %     
% % % %    
% % % % clear pp1
% % % % pp1=zeros(1,length( speech_noise));
% % % % for i=1:length(VOP1)
% % % % pp1(VOP1(i))=1;
% % % % end
% % % % oneidxpp1=find(pp1~=0);toneidxpp1=oneidxpp1.*(1/fs);  
% % % % 
% % % % mar1=zeros(1,length(speech_clean));
% % % % for i=1:length(VOP1)
% % % %     mar1(VOP1(i))=1;
% % % % end
% % % % 
% % % % oneidxmar2=VOP1;toneidxmar2=oneidxmar2.*(1/fs);
% % % % 
% % % % fp=0;
% % % % 
% % % % if fp==1    
% % % %      
% % % % figure;
% % % % ax1=subplot(411);plot(abcd,speech_clean);hold on; plot(abcd,SHE,'r');hold on;stem(toneidxmar,mar(oneidxmar),'k^');
% % % % ax2=subplot(412);plot(abcd,denoisedSig);hold on; plot(abcd,SHE,'r');hold on;stem(toneidxmar,mar(oneidxmar),'k^');hold on;stem(toneidxpp1,pp1(oneidxpp1),'bo');
% % % % ax3=subplot(413); plot(abcd,SHE);hold on; stem(toneidxmar,mar(oneidxmar),'k^');hold on;stem(toneidxpp1,pp1(oneidxpp1),'bo');
% % % % ax4=subplot(414); plot(abcd,y);hold on;stem(toneidxmar,mar(oneidxmar),'k^');hold on;stem(toneidxpp1,pp1(oneidxpp1),'bo');
% % % % linkaxes([ax1,ax2,ax3,ax4],'x');
% % % %    
% % % % end
% % % % 
% % % % end
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % 
% % % % % s_path='/home/acer/my_work/new_paper/plot/nlm/';
% % % % 
% % % % 
% % % % detec_rate=(VOP_det2/totalref_mark)*100;
% % % % spu_rate=(VOP_det2/VOP_det2(end))*100
% % % % 
% % % % % save([s_path,spd],'detec_rate');
% % % % % save([s_path,sps],'spu_rate');
% % % % % 
% % % % % dd=(VOP_det2(end-2)/totalref_mark)*100;
% % % % % ss=(VOP_det2(end-1)/VOP_det2(end))*100;
% % % % %     yy=[dd ss];
% % % % %       fprintf(fid, '\n%6.2f  %6.2f %6.2f %6.2f\n',yy,snr_db(k));
% % % % %    fclose('all');
% % % % 
% % % %  end
  end































%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%extra codes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%     Th=.1*mean( SHE1);
%     tmin=0;
%     [SHE2]=sigmamapping(SHE1,50,Th,tmin,0);
%     SHE2= SHE1'./SHE2;
%      th1=.01;
%     th2=.25;
% % ZZ2=[];
% % ZZ3=ZZ2';
% YY2=[];
% for i=1:length(SHE1)
%     if (abs(SHE1(i))<=th2&&abs(SHE1(i))>=th1);
%       YY2(i) = 5*SHE1(i);
%     elseif abs(SHE1(i))<=th1
%             YY2(i) =0;
%         else
%        YY2(i) = SHE1(i);   
%     end
% end





% [VOP2,Amp]=findpeaks_V4(y,200,0);
% Amp(abs(Amp)<=0.01)=0;
% VOP=[];
% VOP2=find(Amp~=0);
% 
% % [VEP2,Amp1]=findpeaks_V4(-y,300,0);
% % Amp1(abs(Amp1)<=0.001)=0;
% % 
% % VEP=find(Amp1~=0);
% 
% % for mm=1:length(VOP2);
% %     if SHE(VOP2(mm))>=0.01
% %     VOP=[VOP, VOP2(mm)];
% %     end
% % end
     
% for mm=1:length(VOP2)-1;
%     te=min(y(VOP2(mm):VOP2(mm+1)));
%     if abs(y(VOP2(mm)))+abs(te)>=0.01
%     VOP=[VOP, VOP2(mm)];
%     end
% end
% 
% te=min(y(VOP2(end):end));
%     if abs(y(VOP2(end)))+abs(te)>=0.01
%     VOP=[VOP, VOP2(end)];
%     end