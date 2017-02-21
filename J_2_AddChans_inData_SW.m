

%% ------------------------------------ADD A ROW OF A CHANNEL IN THE data_SW MATRIX----------------------------------------------------

%%% the data of the stim channel will be rereferenced to the mean value of
%%% the channels of both earlobs and filtered with filtfilt -> correct for
%%% phaseshifting
%%
clear all;close all;
fs=500;
refCh=[49 56];
trigch=130;

%%% Filter SW
Fc1=[0.319825 3.12648]/(fs/2); %fs=500
N1=3;
[z1,p1,k1] = butter(N1, Fc1);
[sos_SW,g_SW] = zp2sos(z1, p1, k1);

sub={'SC01AG\','SC03DK\','SC04MS\','SC06BL\','SC07AZ\'};
Session={'up\' 'down\'};

saveFolder='D:\SWS_Chord_PN\data\Filtered_Data\';
Datafolder='L:\Somnus-Data\Manuela\Daten_Manuela\EGI\';

for s=1:length(sub)
    
    for j=1:length(Session)
        
        if j==1
            chan_add=[30 112];
            
        elseif j==2
            chan_add=[19 23 24 30];
        end
        
       Rawname=dir([Datafolder,sub{s},Session{j},'*.raw']);              
       numfile=length(Rawname);
       load([saveFolder,Session{j},Rawname(1).name(4:11),'_FiltFiltData_allnight.mat'],'StimCh','data_SW')
       
       StimCh_new=sort([StimCh chan_add]);
       clear StimCh
       StimCh=StimCh_new;
       indx=find(ismember(StimCh,chan_add));
       
       for ch=1:length(chan_add)
           display(ch)
           
           data_SW_ch=[];
           
           for i=1:numfile
               display(i)
            
               filenameraw=[Datafolder,sub{s},Session{j},Rawname(i).name];

               data_ref1 = loadEGIBigRaw(filenameraw,49);
               data_ref2 = loadEGIBigRaw(filenameraw,56);     
               data_ch = loadEGIBigRaw(filenameraw,chan_add(ch));
               data_ref = data_ch-((data_ref1+data_ref2)/2);
               data_ref_fil = filtfilt(sos_SW,g_SW,data_ref);
            
               clear data_ch data_ref

               data_SW_ch=horzcat(data_SW_ch, data_ref_fil);
            
               clear data_ref_fil data_ref1 data_ref2 filenameraw 
           end
                                   
       data_SW(1:indx(ch)-1,:)=data_SW(1:indx(ch)-1,:);
       tp=data_SW(indx(ch):end,:);
       data_SW(indx(ch),:)=data_SW_ch;
       data_SW(indx(ch)+1:end+1,:)=tp;
       
       clear tp data_SW_ch
       end
       
       save([saveFolder,Session{j},Rawname(1).name(4:11),'_FiltFiltData_allnight.mat'],'data_SW','StimCh','-append','-v7.3')    
       clear Rawname data_SW
    end  
end










