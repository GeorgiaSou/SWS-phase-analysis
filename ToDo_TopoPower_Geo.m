%% Set parameters

clear all; close all;

% (0.5-2)HZ
upperbin = 9;        % Frequenz=(bin-1)/4 
lowerbin = 3;  
SWS=1;
timewin = '100';     % time in hours
nch=128;
power='rel';         % 'rel'
Path_Tamplate='D:\SWS_Chord_PN\Interpolation_Angelina\';

%% Stim down
% npower_stim(1,:)=powerindi128time_angi('L:\Somnus-Data\Manuela\Daten_Manuela\EGI\SC01AG\down\01_09_SC01AG_1201506021904.mat',lowerbin,upperbin,timewin); 
% npower_stim(2,:)=powerindi128time_angi('L:\Somnus-Data\Manuela\Daten_Manuela\EGI\SC03DK\down\01_09_SC03DK_1201506161903.mat',lowerbin,upperbin,timewin);
% npower_stim(3,:)=powerindi128time_angi('L:\Somnus-Data\Manuela\Daten_Manuela\EGI\SC04MS\down\01_09_SC04MS_3201507021919.mat',lowerbin,upperbin,timewin);
% npower_stim(4,:)=powerindi128time_angi('L:\Somnus-Data\Manuela\Daten_Manuela\EGI\SC06BL\down\01_09_SC06BL_3201507161911.mat',lowerbin,upperbin,timewin);  
% npower_stim(5,:)=powerindi128time_angi('L:\Somnus-Data\Manuela\Daten_Manuela\EGI\SC07AZ\down\01_09_SC07AZ_2201507211850.mat',lowerbin,upperbin,timewin);  

%% Stim up
npower_stim(1,:)=powerindi128time_noVis_interpol_Geo(0,'D:\SWS_Chord_PN\data\EGI\SC01AG\up\01_09_SC01AG_2201506091840.mat',lowerbin,upperbin,nch,timewin,power,Path_Tamplate); 
npower_stim(2,:)=powerindi128time_noVis_interpol_Geo(0,'D:\SWS_Chord_PN\data\EGI\SC03DK\up\01_09_SC03DK_3201506301907.mat',lowerbin,upperbin,timewin);  
npower_stim(3,:)=powerindi128time_noVis_interpol_Geo(0,'D:\SWS_Chord_PN\data\EGI\SC04MS\up\01_08_SC04MS_1201506182022.mat',lowerbin,upperbin,timewin);
npower_stim(4,:)=powerindi128time_noVis_interpol_Geo(0,'D:\SWS_Chord_PN\data\EGI\SC06BL\up\01_09_SC06BL_2201507091849.mat',lowerbin,upperbin,timewin);
npower_stim(5,:)=powerindi128time_noVis_interpol_Geo(0,'D:\SWS_Chord_PN\data\EGI\SC07AZ\up\01_09_SC07AZ_3201507281826.mat',lowerbin,upperbin,timewin);

%% Baseline        
npower_bas(1,:)=powerindi128time_noVis_interpol_Geo(0,'D:\SWS_Chord_PN\data\EGI\SC01AG\bas\01_09_SC01AG_3201506161859.mat',lowerbin,upperbin,timewin);
npower_bas(2,:)=powerindi128time_noVis_interpol_Geo(0,'D:\SWS_Chord_PN\data\EGI\SC03DK\bas\01_09_SC03DK_2201506231914.mat',lowerbin,upperbin,timewin);  
npower_bas(3,:)=powerindi128time_noVis_interpol_Geo(0,'D:\SWS_Chord_PN\data\EGI\SC04MS\bas\01_09_SC04MS_2201506251929.mat',lowerbin,upperbin,timewin);
npower_bas(4,:)=powerindi128time_noVis_interpol_Geo(0,'D:\SWS_Chord_PN\data\EGI\SC06BL\bas\01_09_SC06BL_1201507021934.mat',lowerbin,upperbin,timewin);
npower_bas(5,:)=powerindi128time_noVis_interpol_Geo(0,'D:\SWS_Chord_PN\data\EGI\SC07AZ\bas\01_09_SC07AZ_1201507141855.mat',lowerbin,upperbin,timewin);
       
%% GroupMean / Averaged across all subjects

mPower_bas=nanmean(nPower_bas);  
mPower_up=nanmean(nPower_up);


ndxscalemax=max([mPower_bas mPower_stim]);
ndxscalemin=min([mPower_bas mPower_stim]);

%% Plots for the mean power averaged across all subjects (baseline, stimulation and ratio stim/bas)

figure

subplot(3,1,1)
mndxfinite_bas=isfinite(mPower_bas);
matnet128AM(mndxfinite_bas);
topoplottest3(mPower_bas(1,mndxfinite_bas),'test128.loc','maplimits','maxmin','conv','on','intrad',0.5,'electrodes','on','emarkersize',5,'gridscale',300);
colorbar
if strcmp(timewin,'FH')
    title(['FH Baseline ',num2str(lowerbin/4-0.25),'-',num2str(upperbin/4-0.25)])
elseif strcmp(timewin,'LH')
    title(['LH Baseline ',num2str(lowerbin/4-0.25),'-',num2str(upperbin/4-0.25)])
elseif strcmp(timewin,'all')
    title(['all Night Baseline ',num2str(lowerbin/4-0.25),'-',num2str(upperbin/4-0.25)])
end

subplot(3,1,2)
mndxfinite_stim=isfinite(mPower_stim);
matnet128AM(mndxfinite_stim);
topoplottest3(mPower_stim(1,mndxfinite_stim),'test128.loc','maplimits','maxmin','conv','on','intrad',0.5,'electrodes','on','emarkersize',5,'gridscale',300);
colorbar
title(['Stim ',num2str(lowerbin/4-0.25),'-',num2str(upperbin/4-0.25)])

subplot(3,1,3)
ratio=mPower_stim./mPower_bas;
rationdxfinit=isfinite(ratio);
matnet128AM(rationdxfinit);
topoplottest3(ratio(rationdxfinit),'test128.loc','maplimits','maxmin','conv','on','intrad',0.5,'electrodes','on','emarkersize',5,'gridscale',300);
colorbar
title(['Ratio (Stim/Baseline) ',num2str(lowerbin/4-0.25),'-',num2str(upperbin/4-0.25)])  

%% Plot ratio stim/bas (mean across subjects) with specific maplimits 

figure
ratio=mPower_stim./mPower_bas;
rationdxfinit=isfinite(ratio);
matnet128AM(rationdxfinit);
topoplottest3(ratio(rationdxfinit),'test128.loc','maplimits',[0.5 1.4],'conv','on','intrad',0.5,'electrodes','on','emarkersize',5,'gridscale',300);
colorbar
title(['Ratio(Stim/Baseline) ',num2str(lowerbin/4-0.25),'-',num2str(upperbin/4-0.25)])  

%% Paired t-test between baseline and stimulation and plot significance

for ch=1:128
    [p(ch) T(ch)]=PTTEST(npower_bas(:,ch),npower_stim(:,ch));
end

pndxfinit=isfinite(p);

figure
topoplottest3(p(pndxfinit),'test128.loc','maplimits',[0,0.1],'conv','on','intrad',0.5,'electrodes','on','emarkersize',5,'gridscale',300);
title(['p-values (Stim/Baseline) ',num2str(lowerbin/4-0.25),'-',num2str(upperbin/4-0.25)])  
colorbar

find((p)<=0.05)

%% Plots for the ratio stim/bas for each subject separately

for ii=1:6
    ratioii=npower_stim(ii,:)./npower_bas(ii,:);
    
    figure
    mndxfinite_ii=isfinite(ratioii);
    matnet128AM(mndxfinite_ii);
    topoplottest3(ratioii(1,mndxfinite_ii),'test128.loc','maplimits','maxmin','conv','on','intrad',0.5,'electrodes','on','electrodes','on','emarkersize',5,'gridscale',300);
    colorbar
    
    pause
end
