
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
[z1,p1,k1] = butter(N1, Fc1);  %bandpass (0.5-2)Hz
[sos_var1,g1] = zp2sos(z1, p1, k1);
Hd_but1 = dfilt.df2sos(sos_var1, g1);
StimCh=[13 15 20 27 28 29 104 117 118 122 123 124]; %%% adapt to the channel which was selected for stim

saveFolder='D:\SWS_Chord_PN\data\Filtered_Data\';  %% !!!! %%

Folder='L:\Somnus-Data\Manuela\Daten_Manuela\EGI\';
sub={'SC01AG\','SC03DK\','SC04MS\','SC06BL\','SC07AZ\'};
Session={'bas\','up\','down\'};

for s=1:length(sub)
    display(s)   
    
    for l=1:length(Session)
    display(l)
    Datafolder=[Folder,sub{s},Session{l}];
    Rawname=dir([Datafolder,'*.raw']);              
    numfile=length(Rawname);
   
    samp=0;  data=[]; tPos_all=[];  

        for i=1:numfile
        display(i)
        filenameraw=[Datafolder,Rawname(i).name];

        data_ref1 = loadEGIBigRaw(filenameraw,49);
        data_ref2 = loadEGIBigRaw(filenameraw,56);
        currentsamp=length(data_ref1);

            for ch=1:length(StimCh)        
            data_ch(ch,:) = loadEGIBigRaw(filenameraw,StimCh(ch));  
            data_ref(ch,:)=data_ch(ch,:)-((data_ref1+data_ref2)/2);
            data_ref_fil(ch,:)=filter(Hd_but1,data_ref(ch,:));    
            end
    
            clear data_ch data_ref

            data=[data data_ref_fil];
            clear data_ref_fil

            eval('tPos=egiGetTriggersCorr(filenameraw,trigch);','tPos=[]') 
            tPos_row=tPos+samp;
            tPos_all=[tPos_all,tPos_row]; % all samples where stimulation occured
            samp=samp+currentsamp;  
            clear tPos tPos_row
    
            clear data_ref1 data_ref2 filenameraw currentsamp
        end
    
        if ~isempty(tPos_all)
        save([saveFolder,Session{l},Rawname(1).name(4:11),'_FiltData_allnight.mat'],'data','StimCh','fs','refCh','Hd_but1','tPos_all')
        else
        save([saveFolder,Session{l},Rawname(1).name(4:11),'_FiltData_allnight.mat'],'data','StimCh','fs','refCh','Hd_but1')
        end
        clear Rawname numfile
    end
end


