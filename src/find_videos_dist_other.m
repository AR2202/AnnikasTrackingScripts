%Annika Rings July 2019
%FIND_VIDEOS_DIST_OTHER(genotypelist,genotype)
%
%averages the distance_travelled data for the flies paired with the flies
%specified in genotypelist
%i.e. the flies in the same chamber as the flies in genotypelist
%genotype is just the label for the outputdatafile
%both arguments are of type string
%optional argument olddataformat (bool): whether old or new tracking format was
%used; if omitted, it is assumed to be true
function find_videos_dist_other(genotypelist, genotype, olddataformat)
switch nargin
    case 3
        olddataformat = olddataformat;
        
    otherwise
        olddataformat = true;
end


expname = 'dist';
[outputtable, outputdir] = load_input_Indices(genotypelist, olddataformat);
outputvar2 = arrayfun(@(input) input, outputtable.Var2);
Var4 = arrayfun(@(var2)var2-(~isOdd(var2))+(isOdd(var2)), outputvar2);
outputtable.Var2 = Var4;
fullfigname = strcat(genotype, '_mean_', expname, '_other');
find_dist(outputtable, outputdir, fullfigname, expname, olddataformat);

