clear all;clc 
[FILENAME,PATHNAME] = uigetfile('*.sig'); %retrieves .SIG file of interest

%% 24 hour band power analysis
cagenumber = 1; %index for 'for' loop
cage = ['Cage1';'Cage2';'Cage3';'Cage4']; 
chunksize = 5; % 5 minute chunk size for power calculations

for cagenumber = 1:4
    cagexx = cage(cagenumber,:); %calls cage of interest
    
    %calculates normalized bandpowers in chunks specified by 'chunksize'
	[power_matrix,FINALFILENAME] = give_me_power_HarmonieEEG(FILENAME,PATHNAME,cagexx,chunksize);
    
	csvwrite(FINALFILENAME,power_matrix) %writes the 24 hour bandpower matrix to a .CSV
	clear power_matrix FINALFILENAME %clears variables
	cagenumber = cagenumber + 1;
end
