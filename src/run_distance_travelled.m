%Annika Rings, July 2019
%RUN_DISTANCE_TRAVELLED(dur)
%dur: period of time to calculate the distance travelled,
%(in s)
%runs the distance_travelled function for all directories ending in
%'Courtship'
%optional argument: specificframes (Bool, default: false)
%specificframes: if true, it expects a .csv file that contains the start
%and end frames of the frame ranges that should be analyzed. Several frame ranges can be
%specified, starting from column 3 in the .csv file. Each pair of 2 columns
%has to be a pair of start and endframes for the desired range.
%The flyID needs to be in column 2
%The file has to be located in
%the video directory and be called '<videoname>_frames.csv' where videoname

function run_distance_travelled(dur, varargin)

options = struct('specificframes', false, 'fromscores', false);

%# read the acceptable names
optionNames = fieldnames(options);

%# count arguments - throw exception if the number is not divisible by 2
nArgs = length(varargin);
if round(nArgs/2) ~= nArgs / 2
    error('pdfplot_any called with wrong number of arguments: expected Name/Value pair arguments')
end

for pair = reshape(varargin, 2, []) %# pair is {propName;propValue}
    inpName = lower(pair{1}); %# make case insensitive
    %check if the entered key is a valid key
    %check if the entered key is a valid key. If yes, replace the default by
    %the caller specified value. Otherwise, throw and exception
    if any(strcmp(inpName, optionNames))

        options.(inpName) = pair{2};
    else
        error('%s is not a recognized parameter name', inpName)
    end
end
%this block gets all the values from the optional function arguments
%for all arguments that were not specified, the default is used
specificframes = options.specificframes;
fromscores = options.fromscores;
if specificframes
    run_any('distance_travelled_errors.log', 'distance_travelled_frames',  dur)
else
run_any('distance_travelled_errors.log', 'distance_travelled',    dur)
end