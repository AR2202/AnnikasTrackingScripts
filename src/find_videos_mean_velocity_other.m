%Annika Rings 2022
%FIND_VIDEOS_MEAN_VELOCITY_OTHER(genotypelist,genotype)
%
%averages the mean_velocity data for the flies paired with the flies
%specified in genotypelist
%i.e. the flies in the same chamber as the flies in genotypelist
%genotype is just the label for the outputdatafile
%both arguments are of type string
%optional argument olddataformat (bool): whether old or new tracking format was
%used; if omitted, it is assumed to be true
function find_videos_mean_velocity_other(genotypelist, genotype, olddataformat)
switch nargin
    case 3
        olddataformat = olddataformat;
        
    otherwise
        olddataformat = true;
end


expname = 'vel';
[outputtable, outputdir] = load_input_Indices(genotypelist, olddataformat);
outputvar2 = arrayfun(@(input) input, outputtable.Var2);
Var4 = arrayfun(@(var2)var2-(~isOdd(var2))+(isOdd(var2)), outputvar2);
outputtable.Var2 = Var4;
fullfigname = strcat(genotype, '_mean_', expname, '_other');
find_mean_velocity(outputtable, outputdir, fullfigname, expname, 'velocity', olddataformat);

