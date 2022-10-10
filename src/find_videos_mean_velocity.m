%Annika Rings July 2019
%FIND_VIDEOS_MEAN_VELOCITY(genotypelist,genotype)
%
%averages the mean_velocity data for the flies specified in
%genotypelist
%genotype is just the label for the outputdatafile
%both arguments are of type string
%optional argument olddataformat (bool): whether old or new tracking format was
%used; if omitted, it is assumed to be true
function find_videos_mean_velocity(genotypelist, genotype, olddataformat)
switch nargin
    case 3
        olddataformat = olddataformat;
        
    otherwise
        olddataformat = true;
end


expname = 'velocity';
[outputtable, outputdir] = load_input_Indices(genotypelist, olddataformat);

fullfigname = strcat(genotype, '_mean_', expname);
find_mean_velocity(outputtable, outputdir, fullfigname, expname, olddataformat);

