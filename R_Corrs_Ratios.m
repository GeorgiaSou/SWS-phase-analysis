%% SWA
clear all; close all;

StimCh=[13 15 19 20 23 24 27 28 29 30 104 112 117 118 122 123 124];
ch_inc=[13 19 20 23 24 27 28 29 30];
ch_dec=[117 118];
ch_inc_ind=find(ismember(StimCh,ch_inc));
ch_dec_ind=find(ismember(StimCh,ch_dec));
sub={'SC01AG','SC03DK','SC04MS','SC06BL','SC07AZ'};
cd('D:\SWS_Chord_PN\data\Ratios\')
load('Phase_trigs_allSubs_FH')
cd('D:\SWS_Chord_PN\data\Ratios\3-4 Hz\')
load('ratios_FH')

%data=Phase_trigs_allSubs;
data=Phase_trigs_allSubs_FH;

%%
%channel 29
for s=1:5
eval(['ntig_neghalf(s)=data.',sub{s}(1:end),'(6).Ntrig_phase(4)+data.',sub{s}(1:end-1),'(6).Ntrig_phase(5)+data.',sub{s}(1:end-1),'(6).Ntrig_phase(6);'])
eval(['ntig_poshalf(s)=data.',sub{s}(1:end),'(6).Ntrig_phase(1)+data.',sub{s}(1:end-1),'(6).Ntrig_phase(2)+data.',sub{s}(1:end-1),'(6).Ntrig_phase(3);'])
eval(['ntig_pos(s)=data.',sub{s}(1:end),'(6).ntrig_pos;'])
%eval(['select_pos(s)=data.',sub{s}(1:end-1),'(6).Ntrig_phase(1);'])
end

%bins-ch29
for s=1:5
eval(['ntig_29_1(s)=data.',sub{s}(1:end),'(6).Ntrig_phase(1);'])
eval(['ntig_29_2(s)=data.',sub{s}(1:end),'(6).Ntrig_phase(2);'])
eval(['ntig_29_3(s)=data.',sub{s}(1:end),'(6).Ntrig_phase(3);'])
eval(['ntig_29_4(s)=data.',sub{s}(1:end),'(6).Ntrig_phase(4);'])
eval(['ntig_29_5(s)=data.',sub{s}(1:end),'(6).Ntrig_phase(5);'])
eval(['ntig_29_6(s)=data.',sub{s}(1:end),'(6).Ntrig_phase(6);'])
eval(['ntig_29_pos(s)=data.',sub{s}(1:end),'(6).ntrig_pos;'])
end

%channel 117
for s=1:5
eval(['ntig_neghalf(s)=data.',sub{s}(1:end),'(8).Ntrig_phase(4)+data.',sub{s}(1:end-1),'(8).Ntrig_phase(5)+data.',sub{s}(1:end-1),'(8).Ntrig_phase(6);'])
eval(['ntig_poshalf(s)=data.',sub{s}(1:end),'(8).Ntrig_phase(1)+data.',sub{s}(1:end-1),'(8).Ntrig_phase(2)+data.',sub{s}(1:end-1),'(8).Ntrig_phase(3);'])
eval(['ntig_pos(s)=data.',sub{s}(1:end),'(8).ntrig_pos;'])
eval(['select_pos(s)=data.',sub{s}(1:end),'(8).Ntrig_phase(5);'])
end

%bins-ch117
for s=1:5
eval(['ntig_117_1(s)=data.',sub{s}(1:end),'(8).Ntrig_phase(1);'])
eval(['ntig_117_2(s)=data.',sub{s}(1:end),'(8).Ntrig_phase(2);'])
eval(['ntig_117_3(s)=data.',sub{s}(1:end),'(8).Ntrig_phase(3);'])
eval(['ntig_117_4(s)=data.',sub{s}(1:end),'(8).Ntrig_phase(4);'])
eval(['ntig_117_5(s)=data.',sub{s}(1:end),'(8).Ntrig_phase(5);'])
eval(['ntig_117_6(s)=data.',sub{s}(1:end),'(8).Ntrig_phase(6);'])
eval(['ntig_117_pos(s)=data.',sub{s}(1:end),'(8).ntrig_pos;'])
end

%bins-group channels
for ch=1:length(ch_inc_ind)
    
    for s=1:length(sub)
        
        for i=1:6
        eval(['ntrig_inc_',num2str(i),'{ch}(s)=data.',sub{s}(1:end),'(ch_inc_ind(ch)).Ntrig_phase(',num2str(i),');'])
        eval(['ntrig_dec_',num2str(i),'{ch}(s)=data.',sub{s}(1:end),'(ch_dec_ind(ch)).Ntrig_phase(',num2str(i),');'])
        eval(['ntrig_inc_pos{ch}(s)=data.',sub{s}(1:end),'(ch_inc_ind(ch)).ntrig_pos;'])
        eval(['ntrig_dec_pos{ch}(s)=data.',sub{s}(1:end),'(ch_dec_ind(ch)).ntrig_pos;'])
        end
    end
end

% ??? ??????????? ?????? ???????? ?? ???? ??????? 
for ch=1:length(ch_inc_ind)
    
    for s=1:length(sub)
        
        for i=1:6
        eval(['ntrig_inc_',num2str(i),'{ch}(s)=data.',sub{s}(1:end),'(ch_inc_ind(ch)).Ntrig_phase(',num2str(i),');'])
        eval(['ntrig_inc_pos{ch}(s)=data.',sub{s}(1:end),'(ch_inc_ind(ch)).ntrig_pos;'])
        end
    end
end

for ch=1:length(ch_dec_ind)
    
    for s=1:length(sub)
        
        for i=1:6
        eval(['ntrig_dec_',num2str(i),'{ch}(s)=data.',sub{s}(1:end),'(ch_dec_ind(ch)).Ntrig_phase(',num2str(i),');'])
        eval(['ntrig_dec_pos{ch}(s)=data.',sub{s}(1:end),'(ch_dec_ind(ch)).ntrig_pos;'])
        end
    end
end


%
% for i=1:6
%    perc_29_allSubs_FH(i)=eval(['sum(ntig_29_',num2str(i),')/sum(ntig_29_pos);']);
% end

%
% x=ratio_abs_29_FH;
for ch=1:length(ch_inc_ind)
    for s=1:length(sub)
        x_inc{ch}(s)=ratio_abs_all_FH(s,ch_inc(ch));
        x_dec{ch}(s)=ratio_abs_all_FH(s,ch_dec(ch));
    end
end

% Mean ratios across group channels
for s=1:length(sub)
    x_inc_mean(s)=mean([x_inc{1}(s),x_inc{2}(s),x_inc{3}(s),x_inc{4}(s),x_inc{5}(s)]);
    x_dec_mean(s)=mean([x_dec{1}(s),x_dec{2}(s),x_dec{3}(s),x_dec{4}(s),x_dec{5}(s)]);
end

%
% for i=1:6
%     
%     eval(['y=ntig_29_',num2str(i),';'])
%     y=y./ntig_29_pos;
%     [R_29(i),p_29(i)]= corr(x',y','type','Spearman');
% end

for ch=1:length(ch_inc_ind)
    for i=1:6
        eval(['y_inc{ch}(i,:)=ntrig_inc_',num2str(i),'{ch};'])
        eval(['y_dec{ch}(i,:)=ntrig_dec_',num2str(i),'{ch};'])
        y_inc{ch}(i,:)=y_inc{ch}(i,:)./ntrig_inc_pos{ch};
        y_dec{ch}(i,:)=y_dec{ch}(i,:)./ntrig_dec_pos{ch};
        [R_inc_FH{ch}(i),p_inc_FH{ch}(i)]= corr(x_inc{ch}',y_inc{ch}(i,:)','type','Spearman');
        [R_dec_FH{ch}(i),p_dec_FH{ch}(i)]= corr(x_dec{ch}',y_dec{ch}(i,:)','type','Spearman');
    end
end

% Mean percentages across group channels

for i=1:6
    for s=1:length(sub)
        y_inc_mean(i,s)=mean([y_inc{1}(i,s),y_inc{2}(i,s),y_inc{3}(i,s),y_inc{4}(i,s),y_inc{5}(i,s)]);
        y_dec_mean(i,s)=mean([y_dec{1}(i,s),y_dec{2}(i,s),y_dec{3}(i,s),y_dec{4}(i,s),y_dec{5}(i,s)]);
    end
    [R_inc_mean(i),p_inc_mean(i)]= corr(x_inc_mean',y_inc_mean(i,:)','type','Spearman');
    [R_dec_mean(i),p_dec_mean(i)]= corr(x_dec_mean',y_dec_mean(i,:)','type','Spearman');
end


%% Plot correlations and R-Values

%
% figure
% for i=1:6
%     subplot(2,3,i)
%     plot(x,y(i,:),'*')
%     lsline
%     title(['Corr between power ratio and perc of trigs in phase-bin ',num2str(i)])
% end

% plot each channel separately
for ch=1:length(ch_inc_ind)
    figure(ch)
    for i=1:6
        subplot(2,3,i)
        plot(x_inc{ch},y_inc{ch}(i,:),'*')
        lsline
        title({['Channel ',num2str(StimCh(ch_inc_ind(ch)))];['Corr between power ratio and perc of trigs in phase-bin ',num2str(i)]})
    end
end

%plot all channs together
figure
ind=0;
for ch=1:length(ch_inc_ind)
    for i=1:6
        subplot(5,6,ind*6+i)
        plot(x_dec{ch},y_dec{ch}(i,:),'*')
        lsline
        if ch==1
            title({['phase-bin ',num2str(i)];'';['Channel ',num2str(StimCh(ch_dec_ind(ch)))]})
        else
            title(['Channel ',num2str(StimCh(ch_dec_ind(ch)))])
        end
    end
    ind=ind+1;
end

% plot mean groups of channels 
figure
for i=1:6
    subplot(2,3,i)
    plot(x_inc_mean,y_inc_mean(i,:),'*')
    lsline
    if i==2
        title({'Mean Values acros inc-channels ';'';['Corr between power ratio and perc of trigs in phase-bin ',num2str(i)]})
    else
        title(['Corr between power ratio and perc of trigs in phase-bin ',num2str(i)])
    end
end

%
% figure
% plot(R_29,'*')
% title('R-Values in each phase bin')
figure
ind=0;
for ch=1:length(ch_inc_ind)
    subplot(6,2,ch+ind)
    plot(R_inc_FH{ch},'b*')
    title(['Channel ',num2str(StimCh(ch_inc_ind(ch)))])
    subplot(6,2,ch+ind+1)
    plot(R_dec_FH{ch},'b*')
    title(['Channel ',num2str(StimCh(ch_dec_ind(ch)))])
    ind=ind+1;
end

% Mean R-values across group channels
figure
subplot(1,2,1)
plot(R_inc_mean,'b*')
title('R-values for correlations of means across inc-channels')
subplot(1,2,2)
plot(R_dec_mean,'b*')
title('R-values for correlations of means across dec-channels')


clear y x
%%
%x=rPower;
figure
x=ratio_abs_29;
y=ntig_poshalf./ntig_pos  %nphase_e5./ntrig_neg; %nTrig_all; %; %; %; %meanphase_pos; %select_pos./nTrig_all;  %ntrigpos_4./ntrig_neg; %MeanAmp_negTrig./Trig_neg; %Trig_neg; %MeanAmp_negTrig; %;
[R,p]= corr(x',y','type','Spearman')

close all
plot(x,y,'*')
lsline
%vline(1)
%title(['p =',num2str(p),'  R=',num2str(R), ' - positive half'])
title(['p =',num2str(p),'  R=',num2str(R), ' - negative half'])

figure
plot(R_29_FH,'*')
title('R-Values in each phase bin')
%hold on
figure
plot(R_117,'*')
title('R-Values in each phase bin')

% figure1=figure
% plot(x,y,'.k','MarkerSize',25)
% lsline
% box('off')
% lsline_ESRS
% %set(gca,'YTickLabel',{'' '10' '' '14' '' '18' ''})
% set(gca,'YTickLabel',{'' '30' '' '40' '' '50' '' '60'})
% set(gca,'XTickLabel',{'-30' '-20' '-10' '0' '+10' '+20' '+30' '+40'})
% 

%createfigure_ESRS_2016(rpower_ch', y)
% 

%%
clear R_all p_all psig
for ch=1:128
    if sum(~isnan(rPower_128(:,ch)))==size(rPower_128,1)      %% take only ch if there is no NAN
        [R,p]= corr(rPower_128(:,ch),y','type','Spearman');
         R_all(ch)=R; p_all(ch)=p;
        
         
    else
        R_all(ch)=NaN; p_all(ch)=NaN;
    end
    



    clear R p  ndxnan
end

clear p_sig_spearm_plot
p_sig=find(p_all<0.05)
ndxplot_p_sig_spearm=isfinite(R_all);
for i=1:length(p_sig)
    p_sig_spearm_plot(1,i)=sum(ndxplot_p_sig_spearm(1:p_sig(i)));
end



plotmim=max(abs(R_all));

figure
ndxfinit_R_spearm=isfinite(R_all);
matnet128(ndxfinit_R_spearm);
if exist('p_sig_spearm_plot')   
    topoplot_sf(R_all(ndxfinit_R_spearm),'test128.txt','maplimits',[-plotmim plotmim],'conv','on','intrad',0.5,'electrodes','on','emarkersize',4,'emarker2',{p_sig_spearm_plot,'o','w'});
else
     topoplot_sf(R_all(ndxfinit_R_spearm),'test128.txt','maplimits','maxmin','conv','on','intrad',0.5,'electrodes','on','emarkersize',4);
end
title(['Spearman Reg  sig Ch: ',num2str(p_sig)])
colorbar


    
%(ntrig_neg+ntrig_pos)-nTrig_all

   
%ntrig_neg-(nphase_e1+nphase_e2+nphase_e3+nphase_e4+nphase_e5+nphase_e6)    
    
mean(nphase_e1./ntrig_neg*100)
nansem((nphase_e6./ntrig_neg*100)')