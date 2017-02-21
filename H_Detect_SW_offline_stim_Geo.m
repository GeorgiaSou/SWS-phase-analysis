
clear; close all

%% Neue Studie Korrektet für Detektion (nur ein 30)

Folder_FFT='D:\SWS_Chord_PN\data\EGI\';
Folder_Filt='D:\SWS_Chord_PN\data\Filtered_Data\up\';
sub={'SC01AG\','SC03DK\','SC04MS\','SC06BL\','SC07AZ\'};
Session={'up\'};

excludedchannels=[43 48 63 68 73 81 88 94 99 107 113 119 120 125 126 127 128];

for l=1:length(sub)
     Folderpath=[Folder_FFT,sub{l},Session{1}];
     SubSess(l)=dir([Folderpath,'*FFT.mat']);
end

SubData=dir([Folder_Filt,'*_FiltData_allnight.mat']);
     
for s=1:length(SubSess)
    
    display(s)
    if sum([SubSess(s).name(1:6),'\'] == sub{s})==7 && sum([SubData(s).name(1:6),'\'] == sub{s})==7

        load([Folder_FFT,sub{s},Session{1},SubSess(s).name],'vissymb','art*')
        load([Folder_Filt,SubData(s).name],'data','tPos_allCor','StimCh','fs')
     
        indexnr=find(vissymb=='2' | vissymb=='3' | vissymb=='4')';
           
        artndxn(excludedchannels,:)=0;

        ndxgoodch=find(sum(artndxn,2)>0);
        nchgood=length(ndxgoodch);

        artndxx=find(sum(artndxn(ndxgoodch,:))==nchgood);               %%%%artefacts rejection in all channel same
        channelndx=intersect(artndxx,indexnr);

        NREMgoodSampch=[];
        for ii=1:length(channelndx)
            NREMgoodSampch=[NREMgoodSampch [((channelndx(ii)-1)*20*fs)+1:1:channelndx(ii)*20*fs]];
        end
        
        for ch=1:length(StimCh)
                 
            datach=data(ch,:);
            pos_index=zeros(length(datach),1);
            zero_index=zeros(length(datach),1);
            pos_index(datach>30)=1; %index of all points larger than +30
            zero_index(datach>0)=1; %index of all points larger than 0
                 
            difference=diff(pos_index);
            difference_zero=diff(zero_index);
                
            poscross=find(difference==1)+1; %% signal goes above +30 
            poscross_zero=find(difference_zero==1)+1; %% signal goes above 0
                 
            good_poscross=poscross(ismember(poscross,NREMgoodSampch)); %sampe where signal goes above +30 and is during good N2/N3
                 
            m=1;
            n=1;
            for k=1:length(good_poscross);
                threshsamp=good_poscross(k);
                zerocross_good=poscross_zero(poscross_zero<threshsamp);
                [c, index] = min(abs(zerocross_good-threshsamp));
                uptime=(zerocross_good(index):threshsamp); %% time from zerocross to next positive (+30) cross
                rem_good_poscross=good_poscross;
                rem_good_poscross(k)=[]; %% remaining good pos cross (sig above +30) without the current one
                
                zerocrossNext_good=poscross_zero(poscross_zero>threshsamp);
                [c_Next, indexNext] = min(zerocrossNext_good-threshsamp);
                zerotozero=(zerocross_good(index):zerocrossNext_good(indexNext));
                     
                if c<=fs/2 && sum(ismember(rem_good_poscross,uptime))==0 %% frequency must be ok && no previous +30
                    eval(['trigger_offline.ch',num2str(ch),'(m)=threshsamp;'])
                    if sum(ismember(tPos_allCor,zerotozero))==1 %% sample von allen Trigger die auch in LV detektiert wurden
                        eval(['trigger_offline.ch',num2str(ch),'_LVStim(n)=threshsamp;'])
                        eval(['trigger_offline.ch',num2str(ch),'_LVSamp(n)=tPos_allCor(find(ismember(tPos_allCor,zerotozero)==1));'])
                        n=n+1;
                    end
                    m=m+1;
                end
                clear c index zerocross_good threshsamp rem_good_poscross uptime
             end
             clear datach pos_index zero_index  pos_index  difference* poscross* good_poscross zerocross_good threshsamp
         end
         clear  NREMgoodSampch artndxx channelndx ndxgoodch nchgood  artndxn* indexnr vissymb datach data
     end
     trigger_offline.chlabel=StimCh;
         
     save([Folder_Filt,SubData(s).name],'trigger_offline*','-append')
     clear trigger_offline* StimCh
end

%% Neue Studie Korrektet für Detektion (nur ein -30)

clear; close all

Folder_FFT='D:\SWS_Chord_PN\data\EGI\';
Folder_Filt='D:\SWS_Chord_PN\data\Filtered_Data\down\';
sub={'SC01AG\','SC03DK\','SC04MS\','SC06BL\','SC07AZ\'};
Session={'down\'};

excludedchannels=[43 48 63 68 73 81 88 94 99 107 113 119 120 125 126 127 128];

for l=1:length(sub)
     Folderpath=[Folder_FFT,sub{l},Session{1}];
     SubSess(l)=dir([Folderpath,'*FFT.mat']);
end

SubData=dir([Folder_Filt,'*_FiltData_allnight.mat']);
     
for s=1:length(SubSess)
    
    display(s)
    if sum([SubSess(s).name(1:6),'\'] == sub{s})==7 && sum([SubData(s).name(1:6),'\'] == sub{s})==7

        load([Folder_FFT,sub{s},Session{1},SubSess(s).name],'vissymb','art*')
        load([Folder_Filt,SubData(s).name],'data','tPos_allCor','StimCh','fs')
     
        indexnr=find(vissymb=='2' | vissymb=='3' | vissymb=='4')';
           
        artndxn(excludedchannels,:)=0;

        ndxgoodch=find(sum(artndxn,2)>0);
        nchgood=length(ndxgoodch);

        artndxx=find(sum(artndxn(ndxgoodch,:))==nchgood);               %%%%artefacts rejection in all channel same
        channelndx=intersect(artndxx,indexnr);

        NREMgoodSampch=[];
        for ii=1:length(channelndx)
            NREMgoodSampch=[NREMgoodSampch [((channelndx(ii)-1)*20*fs)+1:1:channelndx(ii)*20*fs]];
        end
        
        for ch=1:length(StimCh)
                 
            datach=data(ch,:);
            pos_index=zeros(length(datach),1);
            zero_index=zeros(length(datach),1);
            pos_index(datach>-30)=1; %index of all points larger than -30
            zero_index(datach>0)=1; %index of all points larger than 0
                 
            difference=diff(pos_index);
            difference_zero=diff(zero_index);
                
            negcross=find(difference==-1); %% signal goes under -30 
            negcross_zero=find(difference_zero==-1); %% signal goes under -0
                 
            good_negcross=negcross(ismember(negcross,NREMgoodSampch)); %sampe where signal goes under -30 and is during good N2/N3
                 
            m=1;
            n=1;
            for k=1:length(good_negcross);
                threshsamp=good_negcross(k);
                zerocross_good=negcross_zero(negcross_zero<threshsamp);
                [c, index] = min(abs(zerocross_good-threshsamp));
                downtime=(zerocross_good(index):threshsamp); %% time from neg cross (-30) zerocross to previous zerocrossing
                rem_good_negcross=good_negcross;
                rem_good_negcross(k)=[]; %% remaining good neg cross (sig under -30) without the current one
                
                zerocrossNext_good=negcross_zero(negcross_zero>threshsamp);
                [c_Next, indexNext] = min(zerocrossNext_good-threshsamp);
                zerotozero=(zerocross_good(index):zerocrossNext_good(indexNext));
                     
                if c<=fs/2 && sum(ismember(rem_good_negcross,downtime))==0 %% frequency must be ok && no previous -30
                    eval(['trigger_offline.ch',num2str(ch),'(m)=threshsamp;'])
                    if sum(ismember(tPos_allCor,zerotozero))==1 %% sample von allen Trigger die auch in LV detektiert wurden
                        eval(['trigger_offline.ch',num2str(ch),'_LVStim(n)=threshsamp;'])
                        eval(['trigger_offline.ch',num2str(ch),'_LVSamp(n)=tPos_allCor(find(ismember(tPos_allCor,zerotozero)==1));'])
                        n=n+1;
                    end
                    m=m+1;
                end
                clear c index zerocross_good threshsamp rem_good_negcross uptime
             end
             clear datach pos_index zero_index difference* negcross* good_negcross zerocross_good threshsamp
         end
         clear  NREMgoodSampch artndxx channelndx ndxgoodch nchgood  artndxn* indexnr vissymb datach data
     end
     trigger_offline.chlabel=StimCh;
         
     save([Folder_Filt,SubData(s).name],'trigger_offline*','-append')
     clear trigger_offline* StimCh
end

    