function [power_matrix,FINALFILENAME] = give_me_power_HarmonieEEG(FILENAME,PATHNAME,CAGE,CHUNKSIZE_MIN)

FULLFILENAME = [PATHNAME FILENAME]; %determines full filename
fs = 200; %200 Hz sampling rate
unit_chunklength = CHUNKSIZE_MIN*60*fs; %number of rows in a chunk
k = 0;

[NumRecs, NumSamps, NumSecs] = mGetFileLength(FULLFILENAME); %retrieves information about .SIG file
size_of_the_thing = NumSamps; %size of entire trace
powermatrix = zeros(round(size_of_the_thing/unit_chunklength),21); %creates matrix that will store bandpower values

n = 1;
i1 = 1;

while k == 0
    %set length of particular segment
    i2 = i1 + unit_chunklength;
    if i2 > size_of_the_thing
        i2 = size_of_the_thing;
    end
    doop = i2 - i1;
    segmentofinterest = mGetDataSamp(FULLFILENAME,i1,doop,CAGE);
    %calculate fractional powers
    [bands1] = spectral(segmentofinterest(:,1), fs);
    [bands2] = spectral(segmentofinterest(:,2), fs);
    [bands3] = spectral(segmentofinterest(:,3), fs);
    [bands4] = spectral(segmentofinterest(:,4), fs);
    powers1 = bands1';
    powers2 = bands2';
    powers3 = bands3';
    powers4 = bands4';
    %store fractional powers
    power_matrix(n,:) = [i1 powers1 powers2 powers3 powers4];
    if i2 == size_of_the_thing
        k = 1;
    end
    n = n + 1;
    i1 = i2;
end
BASEFILENAME = strrep(FILENAME,'.SIG','');
FINALFILENAME = [PATHNAME BASEFILENAME '_' CAGE '_24hrbpanalysis.csv'];

end

