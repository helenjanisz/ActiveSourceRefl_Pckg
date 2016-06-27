function [dat2, delkms, nsh] = filter_stagthr(flo,fhi,idcm,dt,ntr,nsamp,nsamps,dat,deltas,nstdzero)
% Filtering for stagthr routine.
%%%%%%%%%%%%%%%%%%%%
% INPUT
% flo - low corner for bandpass filter in Hz
% fhi - high corner for bandpass filter in Hz
% dt - time interval per sample
% ntr - number of traces in station gather
% nsamp - number of samples in each trace
% nsamps - ?
% dat - station gather data
% deltas - shot to station distance in degrees
% nstdzero - noise threshold for zeroing traces

% OUTPUT
% dat2 - filtered ad decimated station gather data
% delkms - shot to station offset vector
% nsh - number of shots (nsh = ntr if idcm = 1)
%%%%%%%%%%%%%%%%%%%%
% HAJ - June 2016

disp('Filtering data...')
if flo==0 && fhi==0 %no filter applied
    dat2=dat; nsh=ntr;
    j=0;
    for k=1:1:nsh
        j=j+1;
        delkms(j)=deltas(k).*111.19;
    end
else
    fnyq=0.5/dt;
    [b,a]=butter(4,[flo fhi]/fnyq);
    nsh=length(1:idcm:ntr);
    dat2=zeros(nsamp,nsh);
    delkms=zeros(1,nsh);
    j=0;
    for k=1:idcm:ntr
        j=j+1;
        dd=zeros(nsamp,1);
        dd(1:nsamps(k))=filtfilt(b,a,detrend(dat(1:nsamps(k),k)));
        dd=dd./std(dd(1:100,:));
        dat2(:,j)=dd;
        delkms(j)=deltas(k).*111.19;
    end
end
% ZERO BAD DATA TRACES
    stddat=std(dat2);
    indx=find(abs(stddat)>nstdzero*mean(abs(stddat)));
    dat2(:,indx)=0; %removes entire noisy traces
disp('Data has been filtered.')
end