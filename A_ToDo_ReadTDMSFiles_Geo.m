clear all; close all;

%% all subjects

Folder='D:\SWS_Chord_PN\data\LabView\';
sub={'SC01AG\','SC03DK\','SC04MS\','SC06BL\','SC07AZ\'};
Session={'down\'};

for s=1:length(sub)
    
    Folderpath=[Folder,sub{s},Session{1}];
    file_tdms=dir([Folder,sub{s},Session{1},'*.tdms']);
    filename=[Folderpath,file_tdms.name];
    
    my_tdms_struct = TDMS_getStruct(filename);
    [~,metaStruct] = TDMS_readTDMSFile(filename);
    
    save([filename(1:end-5),'_tdms.mat'], 'metaStruct', 'my_tdms_struct')
    clear filename metaStruct my_tdms_struct file_tdms
    
end

filename = 'D:\SWS_Chord_PN\data\LabView\SC01AG\session2\SC01AG_2.tdms';

my_tdms_struct = TDMS_getStruct(filename);
[~,metaStruct] = TDMS_readTDMSFile(filename);

save([filename(1:end-5),'_tdms.mat'], 'metaStruct', 'my_tdms_struct')
clear filename Subname metaStruct my_tdms_struct


%%
clear all; close all;

Folder='L:\Somnus-Data\Studies\SPN\data\LabView\SPN_012_1\';
file_tdms=dir([Folder,'*.tdms']);
filename=[Folder,file_tdms.name];

my_tdms_struct = TDMS_getStruct(filename);
[~,metaStruct] = TDMS_readTDMSFile(filename);

save([filename(1:end-5),'_tdms.mat'], 'metaStruct', 'my_tdms_struct')