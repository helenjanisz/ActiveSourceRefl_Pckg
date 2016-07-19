% run_stagthr

% Script for running packagefor viewing active source station gathers
% and picking arrivals. 
% All functions that go with this package are *_stagthr.m
% Helen Janiszewski, 06/16
%%%%%%%%%%%%%%%%%%%%%
% Note: data must have been saved as matfiles with variables:
% nsamp - numer of time samples per trace 
% ntr - number of traces 
% deltas - vector of shot to station angle offsets (length:ntr)
% nsamps - vector with length of each record (length:nsamp)
% tt - time vector (length:nsamp)
% dat - nsamp x ntr matrix storing station record data
%%%%%%%%%%%%%%%%%%%%%
% Requires functions in the _stagthr folder

clear all; close all;

% DATA INPUT DIRECTORIES
data_path = '~/RESEARCH/DATA/RIDGE2TRENCH/STATIONGATHERS';
pickdir = '~/RESEARCH/DATA/RIDGE2TRENCH/PICKS';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist(pickdir)
    mkdir(pickdir)
end

addpath('function_stagthr');

disp('Welcome to run_stagthr. For help type "?" at any time.');

if exist('paramfiles_stagthr/lastparams_stagthr.mat','file')==2
    load('paramfiles_stagthr/lastparams_stagthr.mat')
    load(sprintf('%s',filename));
    time=[tw0:dt:tw1-dt]';
    disp('Your most recent station has been loaded. What would you like to do? ')
else
    disp('No previous parameters found. Please load data. ')
    sta=input('Station Name: ', 's');
    chan=input('Channel: ', 's');
    dbname=input('Line Number (###): ','s'); % MGL1211=seq008db MGL1211reshoot=seq012db MGL1212=seq020db
    dbname=sprintf('seq%sdb',dbname);
    filename=sprintf('%s/%s_%s_%s',data_path,sta,chan,dbname);
    load(sprintf('%s',filename));
    time=[tw0:dt:tw1-dt]';
    save('paramfiles_stagthr/lastparams_stagthr.mat','filename','sta','chan','dbname');
end

while 1
    in=input('','s');
    
    load('paramfiles_stagthr/lastproparams_stagthr.mat');
    load('paramfiles_stagthr/lastplparams_stagthr.mat');
    
    % HELP MENU
    if in=='?'; 
        disp(' ')
        disp('HELP MANUAL');
        disp('Quit: q');
        disp('Load new station: l');
        disp('Process: pr');
        disp('Plot: pl');
        disp('Start picking: pi');
        
    elseif isempty(in)==1
        disp('That is not a valid command. Type "?" for help.')
        
    % LOAD NEW STATION
    elseif in=='l'; %load new station
        sta=input('Station Name: ', 's');
        chan=input('Channel: ', 's');
        dbname=input('Line Number (###): ','s'); % MGL1211=seq008db MGL1211reshoot=seq012db MGL1212=seq020db
        dbname=sprintf('seq%sdb',dbname);
        filename=sprintf('%s/%s_%s_%s',data_path,sta,chan,dbname);
        load(sprintf('%s',filename));
        time=[tw0:dt:tw1-dt]';
        save('paramfiles_stagthr/lastparams_stagthr.mat','filename','sta','chan','dbname');
        
       
    % DATA PROCESSING   
    elseif in=='pr';
        flo=input('Low Pass Corner (Hz): ');
        if isempty(flo)
            flo = proparams(1);
        end
        fhi=input('High Pass Corner (Hz): ');
        if isempty(fhi)
            fhi = proparams(2);
        end
        idcm=input('Traces Selection Factor: ');
        if isempty(idcm)
            idcm = proparams(3);
        end
        nstdzero=input('Noise Factor Threshold: ');
        if isempty(nstdzero)
            nstdzero = proparams(4);
        end
        [datf,delkms,nsh]=filter_stagthr(flo,fhi,idcm,dt,ntr,nsamp,nsamps,dat,deltas,nstdzero);
        vr = input('Reduction Velocity (km/s): ');     % km/s reduction velocity
        if isempty(vr)
            vr = proparams(5);
        end
        [ttr] = reduce_stagthr(vr,datf,time,nsamp,dt,delkms,nsh,nsamps);
        proparams = [flo,fhi,idcm,nstdzero,vr];
        save('paramfiles_stagthr/lastproparams_stagthr.mat','proparams');
        
    % PLOTTING
    elseif in=='pl'
        time1 = input('Minimum Reduced Travel Time: ');
        if isempty(time1)
            time1 = plotparams(3);
        end
        time2 = input('Maximum Reduced Travel Time: ');
        if isempty(time2)
            time2 = plotparams(4);
        end
        dist1 = input('Minimum Offset: ');
        if isempty(dist1)
            dist1 = plotparams(1);
        end
        dist2 = input('Maximum Offset: ');
        if isempty(dist2)
            dist2 = plotparams(2);
        end
        scfac = input('Scale Factor: ');
        if isempty(scfac)
            scfac = plotparams(5);
        end
        plot_stagthr(datf,ttr,delkms,time1,time2,dist1,dist2,sta,chan,flo,fhi,dbname,idcm,vr,scfac);
        plotparams = [dist1,dist2,time1,time2,scfac];
        save('paramfiles_stagthr/lastplparams_stagthr.mat','plotparams');
       
    % PICKING
    elseif in=='pi'
        pick_stagthr(pickdir,vr,sta,chan,dbname);
        
    elseif in=='q'; %quit the package
        break
    else disp('That is not a valid command. Type "?" for help.')
    end
end
