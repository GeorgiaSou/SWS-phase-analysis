
%%% Daten von Trigger Kanal neu referenzieren (links und rechts ohr) und
%%% als zusammenhängende Variable abspeichern


%% SWS_Chord_PN

clear all;close all 
fs=500;
refCh=[49 56];
trigch=130;

%%% Filter
Fc1=[0.319825 3.12648]/(fs/2); %fs=500
N1=3;
[z1,p1,k1] = butter(N1, Fc1);
[sos_var1,g1] = zp2sos(z1, p1, k1);
Hd_but1 = dfilt.df2sos(sos_var1, g1);
StimCh=[13 15 20 27 28 29 104 117 118 122 123 124]; %%% adapt to the channel which was selected for stim
ch=104;                   %% channel(s) I want to add to data

saveFolder='D:\SWS_Chord_PN\data\Filtered_Data\up\';

Folder='L:\Somnus-Data\Manuela\Daten_Manuela\EGI\';
sub={'SC01AG\','SC03DK\','SC04MS\','SC06BL\','SC07AZ\'};
Session={'up\'};
FiltData=dir([saveFolder,'*_FiltData_allnight.mat']);

for s=1:length(sub)
    
    display(s)
    Datafolder=[Folder,sub{s},Session{1}];
    Rawname=dir([Datafolder,'*.raw']);              
    numfile=length(Rawname);
    load([saveFolder,FiltData(s).name],'data');

    data_ref_fil_all=[];
    
    for i=1:numfile

        display(i)
        filenameraw=[Datafolder,Rawname(i).name];

        data_ref1 = loadEGIBigRaw(filenameraw,49);
        data_ref2 = loadEGIBigRaw(filenameraw,56);
                
        data_ch = loadEGIBigRaw(filenameraw,ch);
        
        data_ref=data_ch-((data_ref1+data_ref2)/2);
        data_ref_fil=filter(Hd_but1,data_ref);    
           
        clear data_ch data_ref

        data_ref_fil_all=horzcat(data_ref_fil_all, data_ref_fil);
        
        clear data_ref_fil data_ref1 data_ref2 filenameraw 
 
    end
    
    data(1:6,:)=data(1:6,:);
    tp=data(7:end,:);
    data(7,:)=data_ref_fil_all;
    data(8:end+1,:)=tp;
    
    save([saveFolder,Rawname(1).name(4:11),'_FiltData_allnight.mat'],'data','StimCh')
    
    clear Rawname numfile tp

end


