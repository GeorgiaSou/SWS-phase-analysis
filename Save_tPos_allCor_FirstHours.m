%% Save tPos_allCor, data etc. for Filt Data for the first hours where tones occured

clear all; close all;

Folder='D:\SWS_Chord_PN\data\Filtered_Data\up\';
sub={'SC01AG\','SC03DK\','SC04MS\','SC06BL\','SC07AZ\'};

excludedchannels=[43 48 63 68 73 81 88 94 99 107 113 119 120 125 126 127 128];                                                        

%FiltData=dir([Folder,'*_FiltData_allnight.mat']);
FiltFiltData=dir([Folder,'*_FiltFiltData_allnight.mat']);
FiltData_FH=dir([Folder,'*_FiltData_FH.mat']);
%FiltFiltData_FH=dir([Folder,'*_FiltFiltData_FH.mat']);

% Number of triggers for each subject, where tone was actually played (manually written in the big folder)
trig=[726 996 2360 2422 989];
% trig=[954 1495 2515 2445 956];

for s=1:length(sub)
    
    load([Folder,FiltData_FH(s).name],'tPos_allCor','fs')
    load([Folder,FiltFiltData(s).name],'data_SW','sos_SW','g_SW','StimCh')
    
%     clear tPos_all ndx_badtrig
    
%     if length(tPos_allCor)>trig(s)
%         tPos_allCor(trig(s)+1:end)=[];
%         sound_type_all(trig(s)+1:end)=[]; 
%     end
    
%     tPos_allCor_goodndx(tPos_allCor_goodndx>length(tPos_allCor))=[];
%     data(:,max(tPos_allCor)+3*fs:end)=[]; 
    data_SW(:,max(tPos_allCor)+3*fs:end)=[];
    
    
%     for i=1:length(StimCh)
%         eval(['trigger_offline.ch',num2str(i),'(trigger_offline.ch',num2str(i),'>max(tPos_allCor))=[];'])
%         eval(['trigger_offline.ch',num2str(i),'_LVStim(trigger_offline.ch',num2str(i),'_LVStim>max(tPos_allCor))=[];'])
%         eval(['trigger_offline.ch',num2str(i),'_LVSamp(trigger_offline.ch',num2str(i),'_LVSamp>max(tPos_allCor))=[];'])
%     end
    
%     save([Folder,FiltData(s).name(1:17),'_FH.mat'],'fs','refCh','Hd_but1','StimCh','data','tPos_allCor','tPos_allCor_goodndx','trigger_offline','sound_type_all','-v7.3')
%     save([Folder,FiltFiltData(s).name(1:21),'_FH.mat'],'data_SW','sos_SW','g_SW','StimCh','refCh','fs','-v7.3')
    save([Folder,FiltFiltData(s).name(1:21),'_FH.mat'],'data_SW','StimCh','-append','-v7.3')
    clear data fs Hd_but1 refCh sound_type_all StimCh tPos_allCor tPos_allCor_goodndx trigger_offline data_SW sos_SW g_SW
end




