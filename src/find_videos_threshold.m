%Annika Rings July 2019
%FIND_VIDEOS_THRESHOLD(genotypelist,genotype)
%
%averages the mean_dist_toother data for the flies specified in
%genotypelist
%genotype is just the label for the outputdatafile
%both arguments are of type string
%optional argument olddataformat (bool): whether old or new tracking format was
%used; if omitted, it is assumed to be true
function find_videos_threshold(genotypelist, genotype, inputdir,olddataformat)
switch nargin
    case 4
        olddataformat = olddataformat;
        
    otherwise
        olddataformat = true;
end


expname = 'threshold';
[outputtable, outputdir] = load_input_Indices(genotypelist, olddataformat);

fullfigname = strcat(genotype, '_mean_', inputdir);
find_threshold(outputtable, outputdir, fullfigname, expname, inputdir, olddataformat);

