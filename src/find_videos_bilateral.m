%Annika Rings, Jan 2019
%this function reads in a .xlsx file containing a list of experiments
%belonging to a genotype
%it then finds all the data of the experiments and saves them to a .mat
%file
%the arguments are:
%genotyplist = the .xlsx file containing the experiments

%genotype=genotype of the flies - is only used for labelling the figure(and
%naming the output file)
%xlsx file must have the following columns
%videoname,fly-id,delimitor(in file name, usually '_')
%must be run inside the directory that contains the folders named
%xxx_Courtship which contain the video folders
%olddataformat(bool, optional):whether old tracking format was used
%if not specified, it is assumed to be true

function find_videos_bilateral(genotypelist, genotype, olddataformat)
switch nargin
    case 3
        olddataformat = olddataformat;
        
    otherwise
        olddataformat = true;
end

[outputtable, outputdir] = load_input_Indices(genotypelist, olddataformat);
disp(outputtable);
outputvar2 = arrayfun(@(input) input, outputtable.Var2, 'UniformOutput', false);

startdir = pwd;
data = [];

dirs = dir();
dirnames = {};

for p = 1:numel(dirs)
    if ~dirs(p).isdir
        continue;
    end
    dirname = dirs(p).name;
    if ismember(dirname, {'.', '..'})
        continue;
    end
if olddataformat
      dirnames{end+1} =  dirname;
    else
        subdirs = dir(dirname);
        tracked_subdirs= subdirs(~strcmp({subdirs.name}, '.')&[subdirs.isdir]==1&contains({subdirs.name},'Tracked'));
        %convert to table for sorting
        T = struct2table(tracked_subdirs);
        %sort by tracking date, newest first (based on name of directory)
        sortedT = sortrows(T, 'name', 'descend');
        sortedSubdirs = table2struct(sortedT);
        if numel(sortedSubdirs) >= 1
            % this will use the newest tracking only. 
            %If this behaviour is not intended, it needs to be changed
            subdirname = sortedSubdirs(1).name;
            dirname_full = fullfile(dirname,subdirname);
            dirnames{end+1} =  dirname_full;
        end
        
       
    end
end
for p = 1:numel(dirnames)
    dirname = dirnames{p};
    disp(['Now looking in: ', dirname]);
    cd(dirname);
    videos = cellfun(@(list)dir(char(strcat('*', list))), unique(outputtable.Var1), 'UniformOutput', false);

    videonames = cellfun(@(struct)arrayfun(@(indiv) indiv.name(indiv.isdir == 1, :), struct, 'UniformOutput', false), videos, 'UniformOutput', false);
    %filenames=cellfun(@(videoname,var3,var2) strcat(string(videoname),string(var3),string(var2),string(var3)),videonames,outputtable.Var3,outputvar2,'UniformOutput',false);
    videonames = videonames(~cellfun(@isempty, videonames));
    %filenames=filenames(~cellfun(@isempty,filenames));

    if size(videonames, 2) > 0
        disp(videonames);
        for q = 1:size(videonames, 1)

            if exist(string(videonames{q}{1}), 'dir')
                disp(videonames{q}{1});
                cd(videonames{q}{1});
                cd(videonames{q}{1});
                variablename_video = regexprep(videonames{q}{1}, '(\w+)-(\w+)_Courtship-', '');
                disp(variablename_video);

                % newtable = outputtable(strcmp(variablename_video,outputtable.Var1), : );
                newtable2 = outputtable(cellfun(@(x) contains(videonames{q}{1}, x), outputtable.Var1), :);
                %newtable3=vertcat(newtable,newtable2);
                newtable3 = newtable2;
                disp(newtable3);


                for r = 1:height(newtable3)
                    disp('Index in newtable3');
                    disp(r);
                    disp('Fly ID');
                    disp(newtable3.Var2(r));
                    flyid = newtable3.Var2(r);
                    bilateral_index = bilateral_wing_index(videonames{q}{1}, flyid);
                    data = [bilateral_index, data];


                end
            end
            cd(startdir);
            cd(dirname);
        end
        cd(startdir);
        cd(dirname);


    end
    cd(startdir);
end
datafilename = strcat(genotype, '_bilateral_WingIndex.mat');
datapath = fullfile(outputdir, datafilename);

save(datapath, 'data');
