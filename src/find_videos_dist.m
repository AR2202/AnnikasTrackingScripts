%Annika Rings July 2019
%FIND_VIDEOS_DIST(genotypelist,genotype)
%
%averages the distance_travelled data for the flies specified in
%genotypelist
%genotype is just the label for the outputdatafile
%both arguments are of type string
%optional argument olddataformat (bool): whether old or new tracking format was
%used; if omitted, it is assumed to be true
function find_videos_dist(genotypelist, genotype, olddataformat)
switch nargin
    case 3
        olddataformat = olddataformat;
        
    otherwise
        olddataformat = true;
end


expname = 'dist';
[outputtable, outputdir] = load_input_Indices(genotypelist, olddataformat);

fullfigname = strcat(genotype, '_mean_', expname);
find_dist(outputtable, outputdir, fullfigname, expname, olddataformat);

