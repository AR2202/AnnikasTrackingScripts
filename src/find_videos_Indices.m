%Annika Rings, Jan 2019
%this function reads in a .xlsx file containing a list of experiments
%belonging to a genotype
%it then finds all the data of the experiments and saves them to a .mat
%file
%the arguments are:
%genotyplist = the .xlsx file containing the experiments

%genotype=genotype of the flies - is only used for labelling the figure(and
%naming the output file)
%xlsx file must have the following columns
%videoname,fly-id,delimitor(in file name, usually '_')
%must be run inside the directory that contains the folders named
%xxx_Courtship which contain the video folders
%olddataformat: whether old recording setup was used

function find_videos_Indices(genotypelist, genotype, olddataformat)
switch nargin
    case 3
        olddataformat = olddataformat;
        
    otherwise
        olddataformat = true;
end
[outputtable, outputdir] = load_input_Indices(genotypelist, olddataformat);
datafilename = strcat(genotype, '_Indices.mat');
outputname = fullfile(outputdir,datafilename);
find_indices(outputtable, outputname, olddataformat) 

