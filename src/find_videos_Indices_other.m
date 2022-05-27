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

function find_videos_Indices_other(genotypelist, genotype, olddataformat)
switch nargin
    case 3
        olddataformat = olddataformat;
        
    otherwise
        olddataformat = true;
end
[outputtable, outputdir] = load_input_Indices(genotypelist, olddataformat);
outputvar2 = arrayfun(@(input) input, outputtable.Var2);
Var4 = arrayfun(@(var2)var2-(~isOdd(var2))+(isOdd(var2)), outputvar2);
outputtable.Var2 = Var4;
datafilename = strcat(genotype, '_Indices_other.mat');
outputname = fullfile(outputdir,datafilename);
find_indices(outputtable, outputname, olddataformat) 


