% run_stagthr

% Script for running packagefor viewing active source station gathers
% and picking arrivals. 
% All functions that go with this package are *_stagthr.m
% Helen Janiszewski, 06/16
%%%%%%%%%%%%%%%%%%%%%
% Note: data must have been saved as matfiles with format
% create_recsec.m makes these matfiles for data stored in antelope
% database.
%%%%%%%%%%%%%%%%%%%%%
% Required scripts and functions: filter_stagthr, reduce_stagthr,
% plot_stagthr, pick_stagthr, save_stagthr, load_stagthr

clear all; close all;

data_path = '~/RESEARCH/DATA/RIDGE2TRENCH/STATIONGATHERS';
pickdir = '~/RESEARCH/DATA/RIDGE2TRENCH/PICKS';

if ~exist(pickdir)
    mkdir(pickdir)
end

disp('Welcome to run_stagthr. For help type "?" at any time.');

if exist('lastparams_stagthr.mat','file')==2
    load('lastparams_stagthr.mat')
    load(sprintf('%s',filename));
    disp('Your most recent station has been loaded. What would you like to do? ')
else
    disp('No previous parameters found. Please load data. ')
    sta=input('Station Name: ', 's');
    chan=input('Channel: ', 's');
    dbname=input('Line Number (###): ','s'); % MGL1211=seq008db MGL1211reshoot=seq012db MGL1212=seq020db
    dbname=sprintf('seq%sdb',dbname);
    filename=sprintf('%s/%s_%s_%s',data_path,sta,chan,dbname);
    load(sprintf('%s',filename));
    save('lastparams_stagthr.mat','filename','sta','chan','dbname');
end

while 1
    in=input('','s');
    
    % HELP MENU
    if in=='?'; 
        disp(' ')
        disp('HELP MANUAL');
        disp('Quit: q');
        disp('Load new station: l');
        disp('Process: pr');
        disp('Plot: pl');
        disp('Start picking: pi');
        
    % LOAD NEW STATION
    elseif in=='l'; %load new station
        sta=input('Station Name: ', 's');
        chan=input('Channel: ', 's');
        dbname=input('Line Number (###): ','s'); % MGL1211=seq008db MGL1211reshoot=seq012db MGL1212=seq020db
        dbname=sprintf('seq%sdb',dbname);
        filename=sprintf('%s/%s_%s_%s',data_path,sta,chan,dbname);
        load(sprintf('%s',filename));
        save('lastparams_stagthr.mat','filename','sta','chan','dbname');
        
       
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
        [datr,ttr] = reduce_stagthr(vr,datf,tt,nsamp,dt,delkms,nsh,nsamps);
        proparams = [flo,fhi,idcm,nstdzero,vr];
        
    % PLOTTING
    elseif in=='pl'
        plty = input('Which data do you want to plot (1 for filtered + reduced, 2 for filtered only)? ');
        if isempty(plty)
            plty = plotparams(5);
        end
        if plty == 1;
            datpl = datr;
            vrpl = vr;
        elseif plty == 2
            datpl = datf;
            vrpl=0;
        end
        clow = input('Low Color Value: ');
        if isempty(clow)
            clow = plotparams(1);
        end
        chigh = input('High Color Value: ');
        if isempty(chigh)
            chigh = plotparams(2);
        end
        time1 = input('Minimum Reduced Travel Time: ');
        if isempty(time1)
            time1 = plotparams(3);
        end
        time2 = input('Maximum Reduced Travel Time: ');
        if isempty(time2)
            time2 = plotparams(4);
        end
        plot_stagthr(datpl,ttr,delkms,clow,chigh,time1,time2,sta,chan,flo,fhi,dbname,idcm,vrpl);
        plotparams = [clow,chigh,time1,time2,plty];
       
    % PICKING
    elseif in=='pi'
        pick_stagthr(pickdir,vr);
        
    elseif in=='q'; %quit the package
        break
    else disp('That is not a valid command. Type "?" for help.')
    end
end
