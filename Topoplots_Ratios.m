%% ToDo_TopoPower
clear all; close all;

study={'SWS_Chord'};
stim={'down'};
stim_el=[104];           % SWS_Chord
%stim_el=[66 67 71 72];  % BMS
lfreq=[0.5 2 3 0.5];
ufreq=[2 3 4 4];
power={'rel','abs'};   % 'abs' or 'rel'


%% Plots for the mean power averaged across all subjects (baseline, stimulation and ratio stim/bas)

for fr=1:length(lfreq)
    
for pr=1:length(power)
    
Folder=['D:\SWS_Chord_PN\data\Ratios\',study{1},'\',stim{1},'\',num2str(lfreq(fr)),'-',num2str(ufreq(fr)),' Hz\',power{pr},'\'];
load([Folder,'ratios.mat'])

mPower_bas=nanmean(nPower_bas);  
mPower_down=nanmean(nPower_down);

figure

subplot(2,2,1)
mndxfinite_bas=isfinite(mPower_bas);
matnet128AM(mndxfinite_bas);
topoplottest3(mPower_bas(1,mndxfinite_bas),'test128.loc','maplimits','maxmin','conv','on','intrad',0.5,'electrodes','on','emarkersize',5,'gridscale',300,'whitebk','on');
colorbar
%title('Sham - Baseline','FontSize',15)
%title('Tone interval - Baseline','FontSize',15)
title([num2str(lfreq(fr)),'-',num2str(ufreq(fr)),' Hz, Baseline (',power{pr},')'],'FontSize',13)

subplot(2,2,2)
mndxfinite_stim=isfinite(mPower_down);
matnet128AM(mndxfinite_stim);
topoplottest3(mPower_down(1,mndxfinite_stim),'test128.loc','maplimits','maxmin','conv','on','intrad',0.5,'electrodes','on','emarkersize',5,'gridscale',300,'emarker2',{stim_el,'o','w'},'whitebk','on');
colorbar
%title('Sham - Stimulation','FontSize',15)
%title('Tone interval - Stimulation','FontSize',15)
title([num2str(lfreq(fr)),'-',num2str(ufreq(fr)),' Hz, Stimulation (',power{pr},')'],'FontSize',13)

subplot(2,2,3)
ratio=mPower_down./mPower_bas;
rationdxfinit=isfinite(ratio);
matnet128AM(rationdxfinit);
topoplottest3(ratio(rationdxfinit),'test128.loc','maplimits','maxmin','conv','on','intrad',0.5,'electrodes','on','emarkersize',5,'gridscale',300,'emarker2',{stim_el,'o','w'},'whitebk','on');
colorbar
%title('Sham - Ratio','FontSize',15) 
%title('Tone interval - Ratio','FontSize',15) 
title([num2str(lfreq(fr)),'-',num2str(ufreq(fr)),' Hz, Ratio (',power{pr},')'],'FontSize',13)

%% Plot ratio stim/bas (mean across subjects) with specific maplimits 

% figure
% ratio=mPower_down./mPower_bas;
% rationdxfinit=isfinite(ratio);
% matnet128AM(rationdxfinit);
% topoplottest3(ratio(rationdxfinit),'test128.loc','maplimits',[0.5 1.4],'conv','on','intrad',0.5,'electrodes','on','emarkersize',5,'gridscale',300);
% colorbar
% title(['Tone Interval - Ratio (',num2str(lowerbin/4-0.25),'-',num2str(upperbin/4-0.25),') Hz']) 

%% Paired t-test between baseline and stimulation and plot significance - MEAN

for ch=1:128
    [p(ch) T(ch)]=PTTEST(nPower_bas(:,ch),nPower_down(:,ch));
end

pndxfinit=isfinite(p);

subplot(2,2,4)
topoplottest3(p(pndxfinit),'test128.loc','maplimits',[0,0.1],'conv','on','intrad',0.5,'electrodes','on','emarkersize',5,'gridscale',300,'emarker2',{stim_el,'o','w'},'whitebk','on');
%title('Sham - p-values','FontSize',15) 
%title('Tone interval - p-values','FontSize',15)
title([num2str(lfreq(fr)),'-',num2str(ufreq(fr)),' Hz, p-values (',power{pr},')'],'FontSize',13)
colorbar

find((p)<=0.05)

%% Plots for the ratio stim/bas for each subject separately

figure
for ii=1:5
    
    subplot(4,4,ii)
    ratioii=nPower_down(ii,:)./nPower_bas(ii,:);
    mndxfinite_ii=isfinite(ratioii);
    matnet128AM(mndxfinite_ii);
    topoplottest3(ratioii(1,mndxfinite_ii),'test128.loc','maplimits','maxmin','conv','on','intrad',0.5,'electrodes','on','electrodes','on','emarkersize',5,'gridscale',300,'emarker2',{stim_el,'o','w',7},'whitebk','on');
    colorbar
    %title(['Sham - sub',num2str(ii)],'FontSize',15)
    %title(['Ratio-FH - sub',num2str(ii)],'FontSize',15)
    title([num2str(lfreq(fr)),'-',num2str(ufreq(fr)),' Hz, Ratio (',power{pr},') - sub',num2str(ii)],'FontSize',13)

    %pause
end

clear Folder mndxfinite_bas mndxfinite_stim ratio rationdxfinit p T pndxfinit ratioii mndxfinite_ii nPower_bas nPower_down 
clear ratio_abs_29 ratio_abs_117 ratio_abs_all mPower_bas mPower_down

end
end