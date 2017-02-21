%% Create structure for separate electrode phase triggers

clear all;
close all;

datapath='D:\SWS_Chord_PN\data\Filtered_Data\up\';
savefolder='D:\SWS_Chord_PN\data\Ratios\up\';

swData=dir([datapath,'*FiltFiltData_FH.mat']);
tPosData=dir([datapath,'*_FiltData_FH.mat']);

phase_ep_st=[90 120 150 180 210 240];
phase_ep_end=[119 149 179 209 239 269];

sub={'SC01AG','SC03DK','SC04MS','SC06BL','SC07AZ'};
fields={'name','channel','Ntrig_phase','mphase','nTrig_all','ntrig_pos','ntrig_neg'};

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
    
    data=struct([]);
    data=struct('name',[],'channel',[],'Ntrig_phase',[],'mphase',[],'nTrig_all',[],'ntrig_pos',[],'ntrig_neg',[]);
    data.name=sub{s};
    data.nTrig_all=nTrig_all;
    
    for i=1:size(data_SW,1)
        trig_neg=0;
        Nep_1=0; Nep_2=0; Nep_3=0; Nep_4=0; Nep_5=0; Nep_6=0;
        ep_1=[]; ep_2=[]; ep_3=[]; ep_4=[]; ep_5=[]; ep_6=[];
        
        for t=1:length(tPos_allCor)
        
            if sigphase_degree(tPos_allCor(t),i)>=180 && sigphase_degree(tPos_allCor(t),i)<=269 || sigphase_degree(tPos_allCor(t),i)>=90 ...
                && sigphase_degree(tPos_allCor(t),i)<=179 %data_SW(tPos_allCor(t))>0  
                currentphase=round(sigphase_degree(tPos_allCor(t),i));
                
                for e=1:length(phase_ep_st)
                    
                    if ismember(currentphase,(phase_ep_st(e):phase_ep_end(e)));
                    eval(['Nep_',num2str(e),'=Nep_',num2str(e),'+1;'])
                    eval(['ep_',num2str(e),'=[ep_',num2str(e),' currentphase];'])                   
                    end
                end
            else
            trig_neg=trig_neg+1;
            end
        end
        ntrig_pos=length(tPos_allCor)-trig_neg;
        ntrig_neg=trig_neg;
        
        for n=1:length(phase_ep_st)
            eval(['Ntrig_phase(n)=Nep_',num2str(n),';'])
            eval(['mphase(n)=mean(ep_',num2str(n),');'])
        end     
        data.channel(i)=StimCh(i);
        data.Ntrig_phase{i,1}=Ntrig_phase;
        data.mphase{i,1}=mphase;
        data.ntrig_pos(i)=ntrig_pos;
        data.ntrig_neg(i)=ntrig_neg;
        
        clear ntrig* Ntrig* mphase 
    end
    eval([num2str(sub{s}),'=data;'])
    
    clear nTrig_all tPos_allCor* sigphase* hilb data_SW Sub* 
end
Phase_trigs_allSubs_FH=([SC01AG SC03DK SC04MS SC06BL SC07AZ]);

clear e* i n N* phase* SC* swData tPosData s 

save([savefolder,'Phase_trigs_allSubs_FH_new.mat'],'Phase_trigs_allSubs_FH','-v7.3');

%% Percentage of triggers in phase bins

data=Phase_trigs_allSubs_FH;
for s=1:length(sub)
    
   for i=1:length(data(1).channel)
       data(s).perc_pos_trig(i)=data(s).ntrig_pos(i)/data(s).nTrig_all*100;
       data(s).perc_neg_trig(i)=data(s).ntrig_neg(i)/data(s).nTrig_all*100;
       
       for j=1:6
           data(s).perc_trig_phase{i,1}(j)=data(s).Ntrig_phase{i}(j)/data(s).ntrig_pos(i)*100;
           data(s).round_perc{i,1}(j)=round(data(s).perc_trig_phase{i}(j));
       end
   end
end
Phase_trigs_allSubs_FH=data;
save([savefolder,'Phase_trigs_allSubs_FH_new.mat'],'Phase_trigs_allSubs_FH','-v7.3');

