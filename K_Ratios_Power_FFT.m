% -------------------------------------------------------------------------
% Power ratios stim/bas
% -------------------------------------------------------------------------
clear all; close all;

study={'BMS'};
stim={'down'};
lfreq=[0.5 2 3 0.5];
ufreq=[2 3 4 4];
power='rel'; 
SWS=0;  % 0: hours from the entire night
        % 1: hours only from SWS 
        % 2: hours after stimulation
             
% ------------------------------------------------------------------------- 
for st=1:length(stim)

    for fr=1:length(lfreq)

lowerbin=4*lfreq(fr)+1;    % frequency = (bin-1)/4
upperbin=4*ufreq(fr)+1;
Fs=500;
ep=20;
nch=128;
time=100;    
Folder='D:\SWS_Chord_PN\data\EGI\BMS\';
%FolderFilt=(['D:\SWS_Chord_PN\data\Filtered_data\',stim{st},'\']);
Session={'bas\' [stim{st},'\']};
sub={'BMS_001\','BMS_002\','BMS_004\','BMS_005\','BMS_008\','BMS_012\','BMS_022\','BMS_026\','BMS_028\','BMS_029\'...
    ,'BMS_031\','BMS_032\','BMS_033\','BMS_034\','BMS_035\','BMS_036\'};
Path_Tamplate='D:\SWS_Chord_PN\Interpolation_Angelina\';

% -------------------------------------------------------------------------
for l=1:length(Session)
    
    for s=1:length(sub)
        Folderpath=[Folder,sub{s},Session{l}];
        Sess(l,s)=dir([Folderpath,'*FFT.mat']);
    end
end

%SubFilt=dir([FolderFilt,'*_FiltData_FH.mat']);

% -------------------------------------------------------------------------
for l=1:length(Session)
    display(l)
    
    for s=1:length(sub)
        display(s)
        
%         load([FolderFilt,SubFilt(s).name],'data')
%         time=round(length(data)/Fs/ep/180*10)/10;         % time in hours (FH)
%         %time=round(length(data)/Fs/ep/180*10)/10:90;     % interval of time in hours
%         clear data
       
         if sum(Sess(l,s).name(1:7) == sub{s}(1:end-1))==7
            nPower(s,:)=powerindi128time_noVis_interpol_Geo(SWS,[Folder,sub{s},Session{l},Sess(l,s).name],lowerbin,upperbin,nch,time,power,Path_Tamplate);%% N3=1 nur N3
         end         
     end
     eval(['nPower_',Session{l}(1:end-1),' = nPower',';'])
     clear nPower
end

% -------------------------------------------------------------------------
for s=1:length(sub)
    ratio_abs_29(s)=eval(['nPower_',stim{st},'(s,29)/nPower_bas(s,29)']);       
    ratio_abs_117(s)=eval(['nPower_',stim{st},'(s,117)/nPower_bas(s,117)']);
end


ratio_abs_all=eval(['nPower_',stim{st},'./nPower_bas']);       

savefolder=['D:\SWS_Chord_PN\data\Ratios\',study{1},'\',stim{st},'\',num2str(lfreq(fr)),'-',num2str(ufreq(fr)),' Hz\',power,'\'];
mkdir(['D:\SWS_Chord_PN\data\Ratios\',study{1},'\',stim{st},'\',num2str(lfreq(fr)),'-',num2str(ufreq(fr)),' Hz\',power,'\']);

save([savefolder,'ratios'],'ratio_abs_29','ratio_abs_117','ratio_abs_all','nPower_bas',['nPower_',stim{st}]);
clear nPower* Session Folderpath savefolder ratio_abs_29 ratio_abs_117 ratio_abs_all nPower_bas ['nPower_',stim{st}]

    end
end

