%% Create structure for separate electrode phase triggers

clear all;
close all;

datapath='D:\SWS_Chord_PN\data\Filtered_Data\down\';
savefolder='D:\SWS_Chord_PN\data\Ratios\down\';

swData=dir([datapath,'*FiltFiltData_FH.mat']);
tPosData=dir([datapath,'*_FiltData_FH.mat']);

phase_ep_st=[270 300 330 0 30 60];
phase_ep_end=[299 329 359 29 59 89];

sub={'SC01AG','SC03DK','SC04MS','SC06BL','SC07AZ'};
fields={'Name','channel','Ntrig_phase','mphase','nTrig_all','ntrig_neg','ntrig_pos'};
SC01AG=struct([]);SC03DK=struct([]);SC04MS=struct([]);SC06BL=struct([]);SC07AZ=struct([]);

for s=1:length(sub)
    display(s)
    
    load([datapath,swData(s).name],'data_SW','StimCh')
    load([datapath,tPosData(s).name],'tPos_allCor','tPos_allCor_goodndx')
         
    hilb = hilbert(data_SW');
    %X=fft(hilb(:,1));
    sigphase = angle(hilb);
    sigphase_degree=(sigphase+pi)./pi.*180;
    
    tPos_allCor=tPos_allCor(tPos_allCor_goodndx)+9; % delay of EEG data inherent in the anti-alias filters of EGI amplifiers
    nTrig_all=length(tPos_allCor);
    
    for i=1:size(data_SW,1)
        trig_pos=0;
        Nep_1=0; Nep_2=0; Nep_3=0; Nep_4=0; Nep_5=0; Nep_6=0;
        ep_1=[]; ep_2=[]; ep_3=[]; ep_4=[]; ep_5=[]; ep_6=[];
        
        for t=1:length(tPos_allCor)
        
            if sigphase_degree(tPos_allCor(t),i)>=0 && sigphase_degree(tPos_allCor(t),i)<=89 || sigphase_degree(tPos_allCor(t),i)>=270 ...
                && sigphase_degree(tPos_allCor(t),i)<=360 %data_SW(tPos_allCor(t))<0 
            
                if round(sigphase_degree(tPos_allCor(t)))==360
                    currentphase=0;
                else
                    currentphase=round(sigphase_degree(tPos_allCor(t),i));
                end
                
                for e=1:length(phase_ep_st)
                    
                    if ismember(currentphase,(phase_ep_st(e):phase_ep_end(e)));
                    eval(['Nep_',num2str(e),'=Nep_',num2str(e),'+1;'])
                    eval(['ep_',num2str(e),'=[ep_',num2str(e),' currentphase];'])                   
                    end
                end
            else
            trig_pos=trig_pos+1;
            end
        end
        ntrig_neg=length(tPos_allCor)-trig_pos;
        ntrig_pos=trig_pos;
        
        for n=1:length(phase_ep_st)
            eval(['Ntrig_phase(n)=Nep_',num2str(n),';'])
            eval(['mphase(n)=mean(ep_',num2str(n),');'])
        end
        eval(['Sub_',num2str(s),'=struct(fields{1},sub{s},fields{2},StimCh(i),fields{3},Ntrig_phase,fields{4},mphase,fields{5},nTrig_all,fields{6},ntrig_neg,fields{7},ntrig_pos);'])
        eval([sub{s},'=struct([',sub{s},' Sub_',num2str(s),']);']) 
        
        clear ntrig* Ntrig* mphase
    end
    clear nTrig_all tPos_allCor* sigphase* hilb data_SW Sub* 
end
Phase_trigs_allSubs_FH=struct('SC01AG',SC01AG,'SC03DK',SC03DK,'SC04MS',SC04MS,'SC06BL',SC06BL,'SC07AZ',SC07AZ);

clear e* i n N* phase* SC* swData tPosData s 

save([savefolder,'Phase_trigs_allSubs_FH.mat'],'Phase_trigs_allSubs_FH','-v7.3');

%% Percentage of triggers in phase bins

for s=1:length(sub)
    eval(['data=Phase_trigs_allSubs_FH.',sub{s},';']) 
   
   for i=1:length(data)
       data(i).perc_pos_trig=data(i).ntrig_pos/data(i).nTrig_all*100;
       data(i).perc_neg_trig=data(i).ntrig_neg/data(i).nTrig_all*100;
       
       for j=1:6
           data(i).perc_trig_phase(j)=data(i).Ntrig_phase(j)/data(i).ntrig_pos*100;
           data(i).round_perc(j)=round(data(i).perc_trig_phase(j));
       end
   end
   eval(['Phase_trigs_allSubs_FH.',sub{s},'=data;'])
end
save([savefolder,'Phase_trigs_allSubs_FH.mat'],'Phase_trigs_allSubs_FH','-v7.3');

