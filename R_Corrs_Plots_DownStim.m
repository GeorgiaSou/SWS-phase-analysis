%% Rs and Corrs - DOWN-STATE STIMULATION

clear all; close all;

StimCh=[13 15 19 20 23 24 27 28 29 30 104 112 117 118 122 123 124];

ch_inc=[13 19 20 23 24 27 28 29 30];
ch_dec=[117 118];

ch_inc_ind=find(ismember(StimCh,ch_inc));
ch_dec_ind=find(ismember(StimCh,ch_dec));

sub={'SC01AG','SC03DK','SC04MS','SC06BL','SC07AZ'};

cd('D:\SWS_Chord_PN\data\Ratios\down\')
load('Phase_trigs_allSubs_FH')

cd('D:\SWS_Chord_PN\data\Ratios\down\0.5-2 Hz')
load('ratios_FH')

data=Phase_trigs_allSubs_FH;

%% Number of triggers in each phase-bin for a separate channel

%channel 29
for s=1:5
eval(['ntig_neghalf(s)=data.',sub{s}(1:end),'(6).Ntrig_phase(4)+data.',sub{s}(1:end),'(6).Ntrig_phase(5)+data.',sub{s}(1:end),'(6).Ntrig_phase(6);'])
eval(['ntig_poshalf(s)=data.',sub{s}(1:end),'(6).Ntrig_phase(1)+data.',sub{s}(1:end),'(6).Ntrig_phase(2)+data.',sub{s}(1:end),'(6).Ntrig_phase(3);'])
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
eval(['ntig_neghalf(s)=data.',sub{s}(1:end),'(8).Ntrig_phase(4)+data.',sub{s}(1:end),'(8).Ntrig_phase(5)+data.',sub{s}(1:end),'(8).Ntrig_phase(6);'])
eval(['ntig_poshalf(s)=data.',sub{s}(1:end),'(8).Ntrig_phase(1)+data.',sub{s}(1:end),'(8).Ntrig_phase(2)+data.',sub{s}(1:end),'(8).Ntrig_phase(3);'])
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

%% Number of triggers in each phase-bin for clusters/groups of increasing- and decreasing-power channels

% inc-channels 
for ch=1:length(ch_inc_ind)
    for s=1:length(sub)
        for i=1:6
        eval(['ntrig_inc_',num2str(i),'{ch}(s)=data.',sub{s}(1:end),'(ch_inc_ind(ch)).Ntrig_phase(',num2str(i),');'])
        eval(['ntrig_inc_pos{ch}(s)=data.',sub{s}(1:end),'(ch_inc_ind(ch)).ntrig_pos;'])
        end
    end
end

% dec-channels 
for ch=1:length(ch_dec_ind)
    for s=1:length(sub)
        for i=1:6
        eval(['ntrig_dec_',num2str(i),'{ch}(s)=data.',sub{s}(1:end),'(ch_dec_ind(ch)).Ntrig_phase(',num2str(i),');'])
        eval(['ntrig_dec_pos{ch}(s)=data.',sub{s}(1:end),'(ch_dec_ind(ch)).ntrig_pos;'])
        end
    end
end

%%  Power ratios (Stim/Bas)

% inc-channels
for ch=1:length(ch_inc_ind)
    for s=1:length(sub)
        x_inc{ch}(s)=ratio_abs_all_FH(s,ch_inc(ch));
    end
end

% dec-channels
for ch=1:length(ch_dec_ind)
    for s=1:length(sub)
        x_dec{ch}(s)=ratio_abs_all_FH(s,ch_dec(ch));
    end
end

% Mean ratios across group inc-channels for each subject
for s=1:length(sub)
    for ch=1:length(ch_inc_ind)
        x_inc_sub(ch)=x_inc{ch}(s);
    end
    x_inc_mean(s)=mean(x_inc_sub);
    clear x_inc_sub
end

% Mean ratios across group dec-channels for each subject
for s=1:length(sub)
    for ch=1:length(ch_dec_ind)
        x_dec_sub(ch)=x_dec{ch}(s);
    end
    x_dec_mean(s)=mean(x_dec_sub);
    clear x_dec_sub
end

%% Percentage of triggers in each phase bin and R values between ratio and percentage

% inc-channels
for ch=1:length(ch_inc_ind)
    for i=1:6
        eval(['y_inc{ch}(i,:)=ntrig_inc_',num2str(i),'{ch};'])
        y_inc{ch}(i,:)=y_inc{ch}(i,:)./ntrig_inc_pos{ch};
        [R_inc_FH{ch}(i),p_inc_FH{ch}(i)]= corr(x_inc{ch}',y_inc{ch}(i,:)','type','Spearman');
    end
end

% dec-channels
for ch=1:length(ch_dec_ind)
    for i=1:6
        eval(['y_dec{ch}(i,:)=ntrig_dec_',num2str(i),'{ch};'])
        y_dec{ch}(i,:)=y_dec{ch}(i,:)./ntrig_dec_pos{ch};
        [R_dec_FH{ch}(i),p_dec_FH{ch}(i)]= corr(x_dec{ch}',y_dec{ch}(i,:)','type','Spearman');
    end
end

% Mean percentages and Rs across group channels
% inc-channels
for i=1:6
    for s=1:length(sub)
        for ch=1:length(ch_inc_ind)
            y_inc_sub(ch)=y_inc{ch}(i,s);
        end
        y_inc_mean(i,s)=mean(y_inc_sub);
        clear y_inc_sub
    end
    [R_inc_mean(i),p_inc_mean(i)]= corr(x_inc_mean',y_inc_mean(i,:)','type','Spearman');
end

% inc-channels
for i=1:6
    for s=1:length(sub)
        for ch=1:length(ch_dec_ind)
            y_dec_sub(ch)=y_dec{ch}(i,s);
        end
        y_dec_mean(i,s)=mean(y_dec_sub);
        clear y_dec_sub
    end
    [R_dec_mean(i),p_dec_mean(i)]= corr(x_dec_mean',y_dec_mean(i,:)','type','Spearman');
end

%% Plot correlations 

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

%\\\\\\ plot all channels together \\\\\\

% inc-channels
figure
ind=0;
for ch=1:length(ch_inc_ind)
    for i=1:6
        subplot(length(ch_inc_ind),6,ind*6+i)
        plot(x_inc{ch},y_inc{ch}(i,:),'*')
        lsline
        if ch==1
            title({['phase-bin ',num2str(i)];'';['Channel ',num2str(StimCh(ch_inc_ind(ch)))]})
        else
            title(['Channel ',num2str(StimCh(ch_inc_ind(ch)))])
        end
    end
    ind=ind+1;
end

% dec-channels
figure
ind=0;
for ch=1:length(ch_dec_ind)
    for i=1:6
        subplot(length(ch_dec_ind),6,ind*6+i)
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

%\\\\\\ plot mean groups of channels \\\\\\

% inc-channels
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

% dec-channels
figure
for i=1:6
    subplot(2,3,i)
    plot(x_dec_mean,y_dec_mean(i,:),'*')
    lsline
    if i==2
        title({'Mean Values acros dec-channels ';'';['Corr between power ratio and perc of trigs in phase-bin ',num2str(i)]})
    else
        title(['Corr between power ratio and perc of trigs in phase-bin ',num2str(i)])
    end
end

%% Plot R values

% inc-channels
figure
for ch=1:length(ch_inc_ind)
    subplot(round(length(ch_inc_ind)/2),2,ch)
    plot(R_inc_FH{ch},'b*')
    title(['Channel ',num2str(StimCh(ch_inc_ind(ch)))])
end

% inc-channels
figure
for ch=1:length(ch_dec_ind)
    subplot(round(length(ch_dec_ind)/2),2,ch)
    plot(R_dec_FH{ch},'b*')
    title(['Channel ',num2str(StimCh(ch_dec_ind(ch)))])
end

% Mean R-values across group channels
figure
subplot(1,2,1)
plot(R_inc_mean,'b*')
title('R-values for correlations of means across inc-channels')
subplot(1,2,2)
plot(R_dec_mean,'b*')
title('R-values for correlations of means across dec-channels')

