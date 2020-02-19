clear all
clc
[FILENAME,PATHNAME] = uigetfile('*.sig');
FULLFILENAME = [PATHNAME FILENAME];
BASEFILENAME = strrep(FILENAME,'.SIG','');
[NumRecs, NumSamps, NumSecs] = mGetFileLength(FULLFILENAME);
length = NumSamps;

speclength = 10; %desired length of FFT spectrum in min

%Prompts for appropriate information about file of interest
prompt = 'What is the start time? (As a 1 x 3 matrix [hh mm ss])';
x1 = input(prompt);

prompt = 'What is the beginning of the continuous period? (As a 1 x 3 matrix)';
x2 = input(prompt);

prompt = 'What is the end of the continuous period? (As a 1 x 3 matrix)';
x3 = input(prompt);

prompt = 'Continuous Period: 1 for dark 0 for light?';
x5 = input(prompt);

if x5 == 1
    x5 = 'dark';
	x6 = 'light';
else
    x5 = 'light';
	x6 = 'dark';
end

cages = ['Cage1';'Cage2';'Cage3';'Cage4'];

%% CONTINUOUS PERIOD
cagenum = 1;
for cagenum = 1:4
    cage = cages(cagenum,:);
    relativebegin = x2 - x1;
    relativeend = x3 - x1;

    relativebeginpoint = relativebegin(1,1)*60*60*200 + relativebegin(1,2)*60*200 + relativebegin(1,3)*200;
    relativeendpoint = relativeend(1,1)*60*60*200 + relativeend(1,2)*60*200 + relativeend(1,3)*200;

    integerlimit = relativeendpoint-relativebeginpoint-30*60*200;
    
    %calculates ten spectra for continuous period
    begin1 = relativebeginpoint + randi(integerlimit);
    begin2 = relativebeginpoint + randi(integerlimit);
    begin3 = relativebeginpoint + randi(integerlimit);
    begin4 = relativebeginpoint + randi(integerlimit);
    begin5 = relativebeginpoint + randi(integerlimit);
    begin6 = relativebeginpoint + randi(integerlimit);
    begin7 = relativebeginpoint + randi(integerlimit);
    begin8 = relativebeginpoint + randi(integerlimit);
    begin9 = relativebeginpoint + randi(integerlimit);
    begin10 = relativebeginpoint + randi(integerlimit);
    
    lengthcont = speclength*60*200;
    
    seg1 = mGetDataSamp(FULLFILENAME,begin1,lengthcont,cage);
    seg2 = mGetDataSamp(FULLFILENAME,begin2,lengthcont,cage);
    seg3 = mGetDataSamp(FULLFILENAME,begin3,lengthcont,cage);
    seg4 = mGetDataSamp(FULLFILENAME,begin4,lengthcont,cage);
    seg5 = mGetDataSamp(FULLFILENAME,begin5,lengthcont,cage);
    seg6 = mGetDataSamp(FULLFILENAME,begin6,lengthcont,cage);
    seg7 = mGetDataSamp(FULLFILENAME,begin7,lengthcont,cage);
    seg8 = mGetDataSamp(FULLFILENAME,begin8,lengthcont,cage);
    seg9 = mGetDataSamp(FULLFILENAME,begin9,lengthcont,cage);
    seg10 = mGetDataSamp(FULLFILENAME,begin10,lengthcont,cage);
    cancan = 3; % THIS IS THE CHANNEL TO CALCULATE FROM
    [pxx1,f1] = periodogram(seg1(:,cancan),[],[],200);
    [pxx2,f2] = periodogram(seg2(:,cancan),[],[],200);
    [pxx3,f3] = periodogram(seg3(:,cancan),[],[],200);
    [pxx4,f4] = periodogram(seg4(:,cancan),[],[],200);
    [pxx5,f5] = periodogram(seg5(:,cancan),[],[],200);
    [pxx6,f6] = periodogram(seg6(:,cancan),[],[],200);
    [pxx7,f7] = periodogram(seg7(:,cancan),[],[],200);
    [pxx8,f8] = periodogram(seg8(:,cancan),[],[],200);
    [pxx9,f9] = periodogram(seg9(:,cancan),[],[],200);
    [pxx10,f10] = periodogram(seg10(:,cancan),[],[],200);
    
    %stores continuous spectra and writes as .csv
    continuousspectrogram = [f1 pxx1 pxx2 pxx3 pxx4 pxx5 pxx6 pxx7 pxx8 pxx9 pxx10];

    continuousname = [PATHNAME BASEFILENAME '_' cage '_' x5 'spectrum.csv'];
    csvwrite(continuousname,continuousspectrogram);

    %% DISCONTINUOUS PERIOD

    limit1 = relativebeginpoint - 30*60*200;
    limit2 = NumSamps - relativeendpoint - 30*60*200;

    if limit1 <= 30*60*200
        ratio1 = 0;
    else 
        if limit1 <= 30*60*200
            ratio1 = 1;
        else
        ratio1 = relativebeginpoint/(relativebeginpoint + NumSamps - relativeendpoint);
        end
    end
    
    %calculates ten spectra from discontinuous period
    idx4qq = 1;
    for idx4qq = 1:10
        gg = rand;
        if gg <= ratio1
            begin = 1 + randi(limit1);
            i_was_chosen = mGetDataSamp(FULLFILENAME,begin,lengthcont,cage);
        else
            starting = relativeendpoint + randi(limit2);
            i_was_chosen = mGetDataSamp(FULLFILENAME,starting,lengthcont,cage);
        end
        [pxx,f_new] = periodogram(i_was_chosen(:,cancan),[],[],200);
        powerspecs(:,idx4qq) = pxx;
        idx4qq = idx4qq + 1;
    end

    % stores discontinuous period spectra and writes as .csv
    discontinuousspectrogram = [f_new powerspecs];
    discontinuousname = [PATHNAME BASEFILENAME '_' cage '_' x6 'spectrum.csv'];
    csvwrite(discontinuousname,discontinuousspectrogram);
    cagenum = cagenum + 1;
end
disp('Done')
