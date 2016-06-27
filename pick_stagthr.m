function pick_stagthr(pickdir,vr)


disp('Left click to pick arrivals. Type "d" when finished picking to save.');
disp('Type "o" if you want to open existing picks. Type "?" for help.');

PICKS = [];
j=1;

while 1
    figure(1)
    [offset,time,button]=ginput(1);
    if button=='d'
        yn=input('Would you like to save your picks? (y/n) ','s');
        if yn=='y'
            label=input('Please add a label to this arrival. ', 's');
            disp('Saving picks...');
            if vr==0
                save(sprintf('%s/%s_%s_%s_%s_picks',pickdir,sta,chan,dbname,label),'PICKS');
            else
                PICKS(:,2)=PICKS(:,2)+PICKS(:,1)./vr;
                save(sprintf('%s/%s_%s_%s_%s_picks',pickdir,sta,chan,dbname,label),'PICKS');
            end
            disp('Picks have been saved.');
            break
        elseif yn=='n'
            break
        end
    elseif button=='?'
        disp('')
        disp('PICKING HELP')
        disp('Use the left mouse button to select picks.')
        disp('Finish picking: d')
        disp('Save picks: s')
        disp('Load picks: o')
        
    elseif button=='o'
        label=input('Please specify which arrival you wish to load. ','s');
        load(sprintf('%s/%s_%s_%s_%s_picks',pickdir,sta,chan,dbname,label));
        if vr==0
            plot(PICKS(:,1),PICKS(:,2),'+b','MarkerSize',10)
        else
            reducedt=PICKS(:,2)-PICKS(:,1)./vr;
            plot(PICKS(:,1),reducedt,'+b','MarkerSize',10)
        end
        pickop=input('Do you wish to continue picking this arrival? (y/n) ', 's');
        if pickop=='y'
            j=length(PICKS);
        elseif pickop=='n'
            PICKS=[];
        end
    elseif button==1;
        figure(1); plot(offset,time,'+r','MarkerSize',10);
        PICKS(j,1)=offset;
        PICKS(j,2)=time;
        j=j+1;

    else disp('That is not a valid command. Type "?" for help.')
    end
end
return