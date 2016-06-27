function plot_stagthr(dat,tt,delkms,clow,chigh,time1,time2,sta,chan,flo,fhi,dbname,idcm,vr)

% Plotting station gathers
% INPUT
% dat - data
% tt - time vector
% delkms - shot to station offset vector
% clow, chigh, time1, time2 - color and y axis parameters
% sta, chan, flo, fhi, dbname, idcm, vr - title information
% haj 06/2016

figure(1);
clf;
imagesc(delkms,tt(:,1),dat); hold on
caxis([clow chigh])
ylim([time1 time2]);
colormap(bone)
ylabel('reduced travel time, s'); xlabel('offset, km')
axis xy
title(sprintf('Sta  %s  Chan %s  Filter %.3f - %.3f Hz data %s decim %d Vr %.2f km/s Stack %d',...
    sta,chan,flo,fhi, dbname,idcm, vr,stknum));


return