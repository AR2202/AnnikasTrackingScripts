%Annika Rings, May 2022
%RUN_ANY(errorlogfile, functionname, varargin)
% calls specified function for all the tracking data directories. 
% writes any erros to <errorlogfile>
%currently tested only for distance_travelled

function run_any(errorlogfile, functionname, specificframes, fromscores, varargin)



%select all directories that end in the string 'Courtship'
dirs = dir();
startdir = pwd;
courtshipdirs = regexpi({dirs.name},'\d*-\d*-\d*-Recorded|\d*-\d*-Tracked|\w*Courtship','match');
courtshipdirs= [courtshipdirs{:}];
courtshipdirs2 = courtshipdirs;
for p = 1:numel(courtshipdirs)
    dirname = courtshipdirs{p};
    
   
    if contains(dirname, 'Recorded')
        
        subdirs = dir(dirname);
        trackdirs = regexpi({subdirs.name},'\d*-\d*-Tracked','match');
        trackdirs = [trackdirs{:}];
        additional_dirs = {fullfile(dirname, trackdirs)};
        %replace the cirectory name ending in 'Recorded' with all its
        %tracked
        %subdirectories
        courtshipdirs2(:,p) = [];
        for q = 1:numel(additional_dirs)
            additional = additional_dirs{q};
        courtshipdirs2 = [courtshipdirs2,additional];
        end
    end
end
for p = 1:numel(courtshipdirs2)
    dirname = courtshipdirs2{p};
    if ~exist(dirname, 'dir')
            continue;
        end
        
    
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
        %to a file called <errorlogfile>
        
        inputfilename_frames = strcat('../', subdirname, '_frames.csv');
        varargin = [varargin; inputfilename_frames];
        if specificframes
            
            functionname = strcat(functionname, '_frame');
           
        else

            error_handling_wrapper(errorlogfile, functionname, subdirname, varargin{:});
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
