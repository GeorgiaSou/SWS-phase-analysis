clear all; close all;

%% Save 'tPos_allCor' and 'sound_type_all' 

FolderTDMS='D:\SWS_Chord_PN\data\LabView\';
FolderFilt='D:\SWS_Chord_PN\data\Filtered_Data\down\';
sub={'SC01AG\','SC03DK\','SC04MS\','SC06BL\','SC07AZ\'};
Session={'up\','down\'};
gooddif=[-0.5 0 0.5];         %gooddif=[-9:0.5:9];

Mat_File=dir([FolderFilt,'*_FiltData_allnight.mat']);

for s=1:length(sub)  
    
    TDMS_File(s)=dir([FolderTDMS,sub{s},Session{2},'*tdms.mat']);
    
    load([FolderTDMS,sub{s},Session{2},TDMS_File(s).name])
    
    for c=0:length(metaStruct.numberDataPoints)-3
         eval(['AmpSamp = my_tdms_struct.g_1.c_',num2str(c),'.Props.AMP_sample',';'])
         eval(['sound_type = my_tdms_struct.g_1.c_',num2str(c),'.Props.sound_type',';']) %% ndx trig lv
         AmpSamp_al(c+1,:)=AmpSamp;
         sound_type_all(c+1,:)=sound_type;
         clear AmpSamp sound_type
    end
       
    load([FolderFilt,Mat_File(s).name],'tPos_all') 

    % Check for wrong flags and zeros 
    AmpSamp_al=double(AmpSamp_al);
    ndxzeros=find(AmpSamp_al==0);                      % indices of zeros
    AmpSamp_al(ndxzeros)=[];                           % remove zeros from AmpSamp_al
    sound_type_all(ndxzeros)=[];                       % remove same indices from sound_type_all
    nrAmpSamp_org=length(AmpSamp_al);
    [AmpSamp_al, ndxdoubel]=unique(AmpSamp_al);        % indices of unique samples
    doubel_stim=setdiff([1:nrAmpSamp_org],ndxdoubel);  % indices of double samples
    sound_type_all(doubel_stim)=[];                    % remove indices of double samples from sound_type_all
    nrWaveDif=length(tPos_all)-length(AmpSamp_al)
    AmpSamp_500=AmpSamp_al./2;
    endtPos_all=length(tPos_all);
    
    Diff_ampSamp=diff(AmpSamp_500);
    Diff_ampSamp=Diff_ampSamp';
    Diff_tPos=diff(tPos_all);
    ndx_badtrig=[];

    if length(tPos_all)>=length(AmpSamp_al)

        w=1;
        g=1;
        i=1;
        j=0;
        enddif=length(Diff_ampSamp);
        difdif=Diff_ampSamp(w:enddif)-Diff_tPos(g:enddif+g-w);
            
            while ~ismember(difdif(1),gooddif)
                
                g=g+1;
                    
                    if enddif+g-w>length(Diff_tPos)
                        w=w+1;
                        g=1;
                    end
                    difdif=Diff_ampSamp(w:enddif)-Diff_tPos(g:enddif+g-w);
            end
            
            if w>1
                sound_type_all(1:w-1)=[];
                AmpSamp_500(1:w-1)=[];
                clear Diff_ampSamp
                Diff_ampSamp=diff(AmpSamp_500);
                Diff_ampSamp=Diff_ampSamp';
                enddif=length(Diff_ampSamp);
            end
            
            if g>1
                ndx_badtrig=(1:g-1);
                tPos_all(1:g-1)=[];
                clear Diff_tPos
                Diff_tPos=diff(tPos_all);
            end

                clear difdif
                difdif=Diff_ampSamp-Diff_tPos(1:enddif);  
                
            
            while length(tPos_all)>length(AmpSamp_al)
                
                while ismember(difdif(i),gooddif)
                    i=i+1;

                    if i>length(difdif)
                        break
                    end

                end

                if i>length(difdif)
                    clear difdif Diff_tPos
                    if g>1
                        ndx_badtrig=[ndx_badtrig g+i+j:endtPos_all];
                    else
                        ndx_badtrig=[ndx_badtrig i+j+1:endtPos_all];
                    end
                    tPos_all(i+1:end)=[]; 
        
                    Diff_tPos=diff(tPos_all);
                    difdif=Diff_ampSamp-Diff_tPos;            
                else

                    clear difdif Diff_tPos
                    if g>1
                        ndx_badtrig=[ndx_badtrig g+i+j];
                    else
                        ndx_badtrig=[ndx_badtrig i+j+1];
                    end
                    j=j+1;
                    tPos_all(i+1)=[];
                
                    Diff_tPos=diff(tPos_all);
                    difdif=Diff_ampSamp-Diff_tPos(1:enddif);
                end
            end
            plot(difdif);
            tPos_allCor=tPos_all;
    else
       display('More flags in LV')
    end
   
        save([FolderFilt,Mat_File(s).name],'tPos_allCor','sound_type_all','ndx_badtrig','-append')
        
        clear tPos_all tPos_allCor sound_type_all ndx_badtrig AmpSamp_al AmpSamp_500... 
              c difdif Diff_ampSamp Diff_tPos enddif i j k nrWaveDif u
end