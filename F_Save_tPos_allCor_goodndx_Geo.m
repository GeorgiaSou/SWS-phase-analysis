clear all; close all;

Folder='D:\SWS_Chord_PN\data\Filtered_Data\down\';
Folder_FFT='D:\SWS_Chord_PN\data\EGI\';
sub={'SC01AG\','SC03DK\','SC04MS\','SC06BL\','SC07AZ\'};
Session={'down\'};

excludedchannels=[43 48 63 68 73 81 88 94 99 107 113 119 120 125 126 127 128];                                                        

for l=1:length(sub)
     Folderpath=[Folder_FFT,sub{l},Session{1}];
     SubSess(l)=dir([Folderpath,'*FFT.mat']);
end

SubFilt=dir([Folder,'*_FiltData_allnight.mat']);
     
for s=1:length(SubSess)
    
    display(s)
          load([Folder_FFT,sub{s},Session{1},SubSess(s).name],'vissymb','art*')
          load([Folder,SubFilt(s).name],'tPos_allCor')
          
          if exist('artndxn_cor')
                    clear artndxn
                    artndxn=artndxn_cor;
                    clear artndxn_cor
          end
                
               indexnr=find(vissymb=='2' | vissymb=='3' | vissymb=='4')';

           
                artndxn(excludedchannels,:)=0;

                ndxgoodch=find(sum(artndxn')>0);
                nchgood=length(ndxgoodch);

                artndxx=find(sum(artndxn(ndxgoodch,:))==nchgood);               %%%%artefacts rejection in all channel same
                channelndx=intersect(artndxx,indexnr);

                NREMSec=[];
                
                for ii=1:length(channelndx)
                    NREMSec=[NREMSec ((channelndx(ii)-1)*20)+1:1:channelndx(ii)*20];
                end
                
                tPos_allSec=round(tPos_allCor/500);
                
                [tPos_goodSec, tPos_allCor_goodndx]=intersect(tPos_allSec,NREMSec);
                
                save([Folder,SubFilt(s).name],'tPos_allCor_goodndx','-append')
                clear t* a* n* vissymb index* channelndx NREMSec i ii j
end

