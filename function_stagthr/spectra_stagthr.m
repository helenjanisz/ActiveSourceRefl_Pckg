function [c_stack,c_up,c_down,c_std,f] = spectra_stagthr(dat,npts,dt,ntr,taxis,tap,specdir,sta,suff)
% dat - data matrix. Each column is a different time series with shot time
% origin

% filename = sprintf('%s/%s_%sspectra.mat',specdir,sta,suff);
% if exist(filename) == 2
%     load(filename);
% else
fr = 1/dt;
for itra = 1:ntr
    amp_dat = dat(:,itra);
    amp_dat  = detrend(amp_dat,0);
    [power,freq] = pmtm(amp_dat,[],[0:fr/npts:fr/2],fr,'adapt');
    spectrum_dat(:,itra) = power(2:length(power));
    f = freq(2:length(freq));
end
c_stack = mean(spectrum_dat,2);
c_up = prctile(spectrum_dat,75,2);
c_down = prctile(spectrum_dat,25,2);
c_std = prctile((spectrum_dat,25,2);

filename = sprintf('%s/%s_%sspectra',specdir,sta,suff);
save(filename,'c_stack','c_up','c_down','c_std','f');
    
% end
return