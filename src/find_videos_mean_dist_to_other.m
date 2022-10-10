%Annika Rings July 2019
%FIND_VIDEOS_MEAN_Dist_TO_OTHER(genotypelist,genotype)
%
%averages the mean_dist_toother data for the flies specified in
%genotypelist
%genotype is just the label for the outputdatafile
%both arguments are of type string
%optional argument olddataformat (bool): whether old or new tracking format was
%used; if omitted, it is assumed to be true
function find_videos_mean_dist_to_other(genotypelist, genotype, olddataformat)
switch nargin
    case 3
        olddataformat = olddataformat;
        
    otherwise
        olddataformat = true;
end


expname = 'distance_to_other';
[outputtable, outputdir] = load_input_Indices(genotypelist, olddataformat);

fullfigname = strcat(genotype, '_mean_', expname);
find_dist_to_other(outputtable, outputdir, fullfigname, expname, olddataformat);

