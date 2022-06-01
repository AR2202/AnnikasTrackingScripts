function find_videos_pausing(genotypelist, genotype, olddataformat)
switch nargin
    case 3
        olddataformat = olddataformat;
        
    otherwise
        olddataformat = true;
end
[outputtable, outputdir] = load_input_Indices(genotypelist, olddataformat);
datafilename = strcat(genotype, '_Indices.mat');
outputname = fullfile(outputdir,datafilename);
%FIND_VIEDEOS_PAUSING averages pausing data for the flies in genotypelist
find_videos_fraction(genotypelist, 'fraction', 'pausing', genotype, olddataformat)