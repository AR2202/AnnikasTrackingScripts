%Annika Rings 2022
%FIND_VIDEOS_THRESHOLD_DELAY(genotypelist,genotype, inputdir, olddataformat)
%
%finds both male and female data for time to threshold 
% and returns their difference
%for the flies specified in
%genotypelist
%genotype is just the label for the outputdatafile
%both arguments are of type string
%optional argument olddataformat (bool): whether old or new tracking format was
%used; if omitted, it is assumed to be true
function find_videos_threshold_delay(genotypelist, genotype, inputdir,olddataformat)
switch nargin
    case 4
        olddataformat = olddataformat;
        
    otherwise
        olddataformat = true;
end


expname = 'threshold';
[outputtable, outputdir] = load_input_Indices(genotypelist, olddataformat);
outputvar2 = arrayfun(@(input) input, outputtable.Var2);
Var4 = arrayfun(@(var2)var2-(~isOdd(var2))+(isOdd(var2)), outputvar2);
outputtable.Var4 = Var4;
fullfigname = strcat(genotype, '_mean_difference_', inputdir);
find_threshold_delay(outputtable, outputdir, fullfigname, expname, inputdir, olddataformat);

