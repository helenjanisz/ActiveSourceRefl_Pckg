function [datr, ttr] = reduce_stagthr(vr,dat,tt,nsamp,dt,delkms,ntr,nsamps)
% Apply reducing travel time. 
%%%%%%%%%%%%%%%%%%%%
% INPUT
% vr - velocity for travel time reduction. Use 0 for no reduction.
% dat - data
% tt - time vector
% nsamp - number of samples in trace
% dt - time interval per sample
% delkms - shot station offset vector
% ntr - number of traces
% nsamps - ?

% OUTPUT
% datr - reduced travel time station data
% ttr - reduced travel time vector
%%%%%%%%%%%%%%%%%%%%
%   HAJ June 2016


% Currently applying a reduction velocity limits the max time of all traces
% to max time of farthest trace. May want to fix.

disp('Applying reduction...')
if vr==0
    datr=dat;
    t0r=min(min(tt));
    t1r=nsamp*dt+max(min(tt));
    ttr=(t0r:dt:t1r)';
    nsampr=length(ttr);
else
    t0r=min(min(tt)) - min(delkms)/vr;
    t1r=nsamp*dt+max(min(tt)) - (max(delkms))/vr;
    ttr=(t0r:dt:t1r)';
    nsampr=length(ttr);
    datr=zeros(nsampr,ntr);
    j=0;
    for k=1:ntr
        j=j+1;
        datr(:,j)=interp1((tt(1,k):dt:(nsamps(k)*dt))'-delkms(j)/vr,dat(1:nsamps(k),j),ttr );
    end
    % fill holes
    knan = find(isnan(datr));
    datr(knan)=0;
end
disp('Reduction has been applied.')
end