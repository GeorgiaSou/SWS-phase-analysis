%%%
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
% StimCh=[13 15 20 27 28 29 104 117 118 122 123 124];

sub={'SC01AG\','SC03DK\','SC04MS\','SC06BL\','SC07AZ\'};
Session={'bas\','up\','down\'};

saveFolder='D:\SWS_Chord_PN\data\Filtered_Data\';
Datafolder='L:\Somnus-Data\Manuela\Daten_Manuela\EGI\';

for s=1:length(sub)
    display(s)
    
    for j=1:length(Session)
    display(j)    
    
    if j==1
        StimCh=[13 15 19 20 23 24 27 28 29 30 104 112 117 118 122 123 124];
        
    elseif j==2
        StimCh=[13 15 20 27 28 29 30 104 112 117 118 122 123 124];
        
    elseif j==3
        StimCh=[13 15 19 20 23 24 27 28 29 30 104 117 118 122 123 124];
    end
        
    Rawname=dir([Datafolder,sub{s},Session{j},'*.raw']);              
    numfile=length(Rawname);

    data_SW=[]; 
    
        for i=1:numfile
        display(i)
        filenameraw=[Datafolder,sub{s},Session{j},Rawname(i).name];

        data_ref1 = loadEGIBigRaw(filenameraw,49);
        data_ref2 = loadEGIBigRaw(filenameraw,56);
          
        data_SW_ch=[];
          
          for ch=1:length(StimCh)
              
          data_ch = loadEGIBigRaw(filenameraw,StimCh(ch)); 
          data_ref=data_ch-((data_ref1+data_ref2)/2);
          data_ref_fil=filtfilt(sos_SW,g_SW,data_ref);
          clear data_ch data_ref

          data_SW_ch=vertcat(data_SW_ch, data_ref_fil);
          clear data_ref_fil 
          
          end
          data_SW=horzcat(data_SW, data_SW_ch);
       
          clear data_ref1 data_ref2 filenameraw data_SW_ch         
       end
       save([saveFolder,Session{j},Rawname(1).name(4:11),'_FiltFiltData_allnight.mat'],'data_SW','StimCh','fs','refCh','sos_SW','g_SW')
       clear Rawname data_SW
    end  
end










