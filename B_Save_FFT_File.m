clear; close all;

%% SWS_Chord_PN

Folder='D:\SWS_Chord_PN\data\EGI\BMS\';
sub={'BMS_001\','BMS_002\','BMS_004\','BMS_005\','BMS_008\','BMS_012\','BMS_022\','BMS_026\','BMS_028\','BMS_029\'...
    ,'BMS_031\','BMS_032\','BMS_033\','BMS_034\','BMS_035\','BMS_036\'};
Session={'bas\','down\'};

for s=4:length(sub)
  for l=1:length(Session)

%     if s<=9
%         SubSess=dir([Folder,sub{s},'session',Session{s},'*.mat']);
%         SubPath=[Folder,sub{s},'session',Session{s},SubSess(1).name];
%     else
%         SubSess=dir([Folder_Control,sub{s},'session',Session{s},'*.mat']);
%         SubPath=[Folder_Control,sub{s},'session',Session{s},SubSess(1).name];
%     end
    
        SubSess=dir([Folder,sub{s},Session{l},'*.mat']);
    
        SubPath=[Folder,sub{s},Session{l},SubSess(1).name];
        load(SubPath)
        long_MF=(SubPath);
        Name_longMatFile=long_MF(end-24:end-16);
        Savefolder=[Folder,sub{s},Session{l}];
        
        save([Savefolder,Name_longMatFile,'_FFT.mat'],'nch','numfile','ffttot','artndxn','fs',...
            'vissymb','reference','Name_longMatFile')

        clear VPNr Name_longMatFile artndxn ffttot fs nch numfile vissymb SubPath long_MF reference session SubSess
     
  end
end
