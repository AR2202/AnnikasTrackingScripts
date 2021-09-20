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

options = struct('specificframes', false);

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
%select all directories that end in the string 'Courtship'
dirs = dir('*Courtship');

for p = 1:numel(dirs)
    if ~dirs(p).isdir
        continue;
    end
    dirname = dirs(p).name;
    if ismember(dirname, {'.', '..'})
        continue;
    end
    startdir = pwd;
    cd(dirname);
    %get all subdirectories of the Courtship directory - these are the
    %video directories
    subdirs = dir();
    for q = 1:numel(subdirs)
        if ~subdirs(q).isdir
            continue;
        end
        subdirname = subdirs(q).name;
        if ismember(subdirname, {'.', '..'})
            continue;
        end
        %go into the video directory
        cd(subdirname);
        disp(['Now calculating distance travelled for:', subdirname]);
        %go into the second directory level (also named the same as the
        %video directory)
        cd(subdirname);
        %test which options are set and call the pdfplot_any function with
        %the respective parameters. The function is called wrapped in the
        %error_handling_wrapper, which catches any errors and writes them
        %to a file called 'pdfplot_errors.log'
        if specificframes
            inputfilename_frames = strcat('../', subdirname, '_frames.csv');
            error_handling_wrapper('distance_travelled_errors.log', 'distance_travelled_frame', subdirname, dur, inputfilename_frames);
        else

            error_handling_wrapper('distance_travelled_errors.log', 'distance_travelled', subdirname, dur);
        end
        %go back to the courtship directory and continue with the next
        %video
        cd(startdir);
        cd(dirname);
    end
    %go back to the start directory and continue with the next courtship
    %directory
    cd(startdir);
end
