%Annika Rings, July 2019
%RUN_DISTANCE_TRAVELLED(dur)
%dur: period of time to calculate the distance travelled,
%(in s) 
%runs the distance_travelled function for all directories ending in
%'Courtship'

function run_distance_travelled(dur)


%select all directories that end in the string 'Courtship'
dirs = dir('*Courtship');

for p = 1:numel(dirs)
    if ~dirs(p).isdir
        continue;
    end
    dirname = dirs(p).name;
    if ismember(dirname,{'.','..'})
        continue;
    end
    startdir = pwd;
    cd(dirname);
    %get all subdirectories of the Courtship directory - these are the
    %video directories
    subdirs=dir();
    for q = 1:numel(subdirs)
        if ~subdirs(q).isdir
            continue;
        end
        subdirname=subdirs(q).name;
        if ismember(subdirname,{'.','..'})
            continue;
        end
        %go into the video directory
        cd(subdirname);
        disp(['Now calculating distance travelled for:' subdirname]);
        %go into the second directory level (also named the same as the
        %video directory)
        cd(subdirname);
        %test which options are set and call the pdfplot_any function with
        %the respective parameters. The function is called wrapped in the
        %error_handling_wrapper, which catches any errors and writes them
        %to a file called 'pdfplot_errors.log'
        
            error_handling_wrapper('distance_travelled_errors.log','distance_travelled',subdirname,dur);
        
        %go back to the courtship directory and continue with the next
        %video
        cd (startdir);
        cd(dirname);
    end
    %go back to the start directory and continue with the next courtship
    %directory
    cd (startdir);
end


