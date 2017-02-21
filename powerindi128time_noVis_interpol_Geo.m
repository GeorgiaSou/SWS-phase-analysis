
function [npower,ndxfinite]=powerindi128time_noVis_interpol_Geo(SWS,Foldername,lowerbin,upperbin,nch,time,power,Path_Tamplate,varargin)

% Optional Input:                       
%
%   'hh'           - '1','2','3','4','5' : Gives power of 1st, 2nd, etc. half
%                                      hour of SWS
%
%

trk=1;

load(Foldername)


if exist('ffttot_n')
    clear ffttot
    ffttot=ffttot_n;
   % artndxn(26,:)=0;
    
end

if exist('artndxn_cor')
    clear artndxn
    artndxn=artndxn_cor;
    clear artndxn_cor 
end


ffttot=shiftdim(ffttot,2);

%[vistrack,vissymb,offset]=readtrac(Visname,trk);

if exist('N3')
    indexnr=find(vissymb=='3')';
else
    indexnr=find(vissymb=='2' | vissymb=='3' | vissymb=='4')';
end
    
% indexnr=find(vissymb=='3' | vissymb=='4')';

excludedchannels=[43 48 49 56 63 68 73 81 88 94 99 107 113 119 120 125 126 127 128];
artndxn(excludedchannels,:)=0;

ndxgoodch=find(sum(artndxn')>0);
nchgood=length(ndxgoodch);


artndxx=find(sum(artndxn(ndxgoodch,:))==nchgood);               %%%%artefacts rejection in all channel same
channelndx=intersect(artndxx,indexnr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FH, LH, allNight

% Only SWS
if SWS==1

    if time==100        % allnight of SWS
        channelndx=channelndx;
    elseif time==200
        if length(channelndx) > 180     % last hour of SWS
          channelndx=channelndx(end-180:end);
        end
    end

    if length(time)==1 && time~=100 && time~=200 
        timelength=time*180;            % first X hours of SWS
        if channelndx > timelength               
            channelndx=channelndx(1:timelength);
        else
            error (['sleep duration shorter than ',num2str(time),' hours'])
        end
    elseif length(time) > 1               % specific interval of SWS
        timelength=time*180;
        if channelndx > max(timelength)
            channelndx=channelndx(min(timelength):max(timelength));
        else
            error (['sleep duration shorter than ',num2str(time),' hours'])
        end
    end

% Total sleep time
elseif SWS==0       
    
    if time==100
        channelndx=channelndx;
    end
    
    if length(time)==1 && time~=100        % the first X hours of total sleep                 
        timelength=time*180;
        channelndx=channelndx(channelndx<=timelength);
        
        if nargin > 8
        
        if strcmp(varargin{2},'1')
            if length(channelndx) >= 90
                channelndx=channelndx(1:90);
            else 
                channelndx=channelndx(1:end);
                warning('Less than half hour of remaining SWS')
            end
        end
        
        if strcmp(varargin{2},'2')
            if length(channelndx) >= 180
                channelndx=channelndx(91:180);
            elseif length(channelndx) >= 91 && length(channelndx) < 180
                channelndx=channelndx(91:end);
                warning('Less than half an hour of SWS')
            elseif length(channelndx) < 91
                error('Less than half an hour of remaining SWS')
            end
        end
        
        if strcmp(varargin{2},'3')
            if length(channelndx) >= 270
                channelndx=channelndx(181:270);
            elseif length(channelndx) >= 181 && length(channelndx) < 270
                channelndx=channelndx(181:end);
                warning('Less than half an hour of SWS')
            elseif length(channelndx) < 181
                error('Less than one hour of remaining SWS')
            end
        end
        
        if strcmp(varargin{2},'4')
            if length(channelndx) >= 360
                channelndx=channelndx(271:360);
            elseif length(channelndx) >= 271 && length(channelndx) < 360
                channelndx=channelndx(271:end);
                warning('Less than half an hour of SWS')
            elseif length(channelndx) < 271
                error('Less than one hour and a half of remaining SWS')
            end
        end
        
        if strcmp(varargin{2},'5')
            if length(channelndx) >= 450
                channelndx=channelndx(361:450);
            elseif length(channelndx) >= 361 && length(channelndx) < 450
                channelndx=channelndx(361:end);
                warning('Less than half an hour of SWS')
            elseif length(channelndx) < 361
                error('Less than two hours of remaining SWS')
            end
        end
        
        if strcmp(varargin{2},'6')
            if length(channelndx) >= 540
                channelndx=channelndx(451:540);
            elseif length(channelndx) >= 451 && length(channelndx) < 540
                channelndx=channelndx(451:end);
                warning('Less than half an hour of SWS')
            elseif length(channelndx) < 451
                error('Less than two hours and a half of remaining SWS')
            end
        end
        end
    
    elseif length(time)>1     % specific interval of total sleep time 
        timelength=time*180;
        start_ep=channelndx(channelndx>min(timelength));
        end_ep=channelndx(channelndx<=max(timelength));
        channelndx=intersect(start_ep,end_ep);
    end

% for SWS after stimulation
elseif SWS==2 
    
    timelength=time*180;
    if timelength>max(channelndx)
        error('Only Stimulation during SWS')
    else
        channelndx=channelndx(channelndx>timelength);
    end
    
    if nargin > 8
        
        if strcmp(varargin{2},'1')
            if length(channelndx) >= 90
                channelndx=channelndx(1:90);
            else 
                channelndx=channelndx(1:end);
                warning('Less than half hour of remaining SWS')
            end
        end
        
        if strcmp(varargin{2},'2')
            if length(channelndx) >= 180
                channelndx=channelndx(91:180);
            elseif length(channelndx) >= 91 && length(channelndx) < 180
                channelndx=channelndx(91:end);
                warning('Less than half an hour of SWS')
            elseif length(channelndx) < 91
                error('Less than half an hour of remaining SWS')
            end
        end
        
        if strcmp(varargin{2},'3')
            if length(channelndx) >= 270
                channelndx=channelndx(181:270);
            elseif length(channelndx) >= 181 && length(channelndx) < 270
                channelndx=channelndx(181:end);
                warning('Less than half an hour of SWS')
            elseif length(channelndx) < 181
                error('Less than one hour of remaining SWS')
            end
        end
        
        if strcmp(varargin{2},'4')
            if length(channelndx) >= 360
                channelndx=channelndx(271:360);
            elseif length(channelndx) >= 271 && length(channelndx) < 360
                channelndx=channelndx(271:end);
                warning('Less than half an hour of SWS')
            elseif length(channelndx) < 271
                error('Less than one hour and a half of remaining SWS')
            end
        end
        
        if strcmp(varargin{2},'5')
            if length(channelndx) >= 450
                channelndx=channelndx(361:450);
            elseif length(channelndx) >= 361 && length(channelndx) < 450
                channelndx=channelndx(361:end);
                warning('Less than half an hour of SWS')
            elseif length(channelndx) < 361
                error('Less than two hours of remaining SWS')
            end
        end
        
        if strcmp(varargin{2},'6')
            if length(channelndx) >= 540
                channelndx=channelndx(451:540);
            elseif length(channelndx) >= 451 && length(channelndx) < 540
                channelndx=channelndx(451:end);
                warning('Less than half an hour of SWS')
            elseif length(channelndx) < 451
                error('Less than two hours and a half of remaining SWS')
            end
        end
    end
end
%ffttot=shiftdim(ffttot,1);
mfft=[];
for channel=1:nch
    if sum(ismember(ndxgoodch,channel))==1
        fft=squeeze(ffttot(channel,:,:));
        chbfft=mean(fft(lowerbin:upperbin,channelndx));
        mchfft=mean(chbfft);
    else
        mchfft=NaN;
    end
    mfft=[mfft;mchfft];
end
ipower=mfft;

ndxfinite=isfinite(ipower);

%l=length(channelndx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% interpolieren
load([Path_Tamplate,'EEG_template_TFCE_eeglab.mat'])

ndxbadch=find(isnan(ipower));

%%%%%%%%%%%%%%%%%%%%%%%% interpol alt
% EEG.times = [];
% EEG.times = 1;
% EEG.nbchan = 128;
% EEG.pnts = 1;
% EEG.xmax = 0;
% EEG.chanlocs(129) = [];
% 
% %%% interpolation
% EEG.data = [];
% EEG.data = ipower;
% badelectrodes = badch;
% EEG = eeg_interp(EEG, badelectrodes,'spherical');
% ipower_interpol= EEG.data;
     

%%%%%%%%%%%%%%%%%%%%%%%% interpol Angelina
EEG.specdata=[];
EEG.icachansind=[];
EEG.specicaact=[];
EEG.reject=[];
EEG.stats=[];

sr=1;
% EEG.srate=sr;
method='spherical';
EEG.chanlocs(129) = [];
% EEGOUT = eeg_interp_SS(EEG, bad_elec, method);
% 
EEG.times = [];
EEG.times = 1;
% EEG.nbchan = 128;
% EEG.pnts = 1;
% EEG.xmax = 0;
% EEG.chanlocs(129) = [];

EEG.data = [];    
EEG.data = ipower;
EEG.nbchan=size(EEG.data,1);
% EEG.data=data;
EEG.pnts=size(EEG.data,2)

method='spherical';

EEGOUT = eeg_interp_SS(EEG, ndxbadch, method);
ipower_interpol= EEGOUT.data;
clear EEGOUT EEG

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if sum (power=='rel')==3
    npower=ipower_interpol/nanmean(ipower_interpol); 
elseif sum (power=='abs')==3
    npower=ipower_interpol; 

end