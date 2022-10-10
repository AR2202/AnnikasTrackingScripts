%Annika Rings, 2022
%RUN_MEAN_DIST_TO_OTHER()

%optional argument: specificframes (Bool, default: false)
%specificframes: if true, it expects a .csv file that contains the start
%and end frames of the frame ranges that should be analyzed. Several frame ranges can be
%specified, starting from column 3 in the .csv file. Each pair of 2 columns
%has to be a pair of start and endframes for the desired range.
%The flyID needs to be in column 2
%The file has to be located in
%the video directory and be called '<videoname>_frames.csv' where videoname

function run_mean_dist_to_other(varargin)

options = struct('specificframes', false, 'fromscores', false);

%# read the acceptable names
optionNames = fieldnames(options);

%# count arguments - throw exception if the number is not divisible by 2
nArgs = length(varargin);
if round(nArgs/2) ~= nArgs / 2
    error('run_mean_velocity called with wrong number of arguments: expected Name/Value pair arguments')
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
fromscores = options.fromscores; %not yet supported
if specificframes %not yet supported
    run_any('mean_dist_to_other_errors.log', 'mean_dist_to_other_frames')
else
run_any('mean_dist_to_other_errors.log', 'mean_dist_to_other')
end