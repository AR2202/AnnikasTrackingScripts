
function find_dist_to_other(outputtable, ...
    outputdir, fullfigname, expname, olddataformat)


path = 'distance_to_other';
structname = 'data';





outputvar2 = arrayfun(@(input) input, outputtable.Var2, 'UniformOutput', false);

startdir = pwd;
dat = [];
dirs = dir();
fieldname = char(strcat('F.', expname));
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
    videos = cellfun(@(list)dir(char(strcat('*', list))), ...
        outputtable.Var1, 'UniformOutput', false);


    videonames = cellfun(@(struct)arrayfun(@(indiv) indiv.name(indiv.isdir == 1, :), ...
        struct, 'UniformOutput', false), videos, 'UniformOutput', false);

    filenames = cellfun(@(videoname, var3, var2) strcat(string(videoname), ...
        string(var3), string(var2), string(var3)), videonames, ...
        outputtable.Var3, outputvar2, 'UniformOutput', false);
    videonames = videonames(~cellfun(@isempty, videonames));
    filenames = filenames(~cellfun(@isempty, filenames));

    if size(videonames, 2) > 0
        for q = 1:size(videonames, 1)
            if exist(videonames{q}{1}, 'dir')
                disp(videonames{q}{1});
                cd(videonames{q}{1});
                cd(videonames{q}{1});
                cd(path);


                strtofind = filenames{q};
                disp(strtofind);
                datafile = dir(char(strcat('*', strtofind, 'mean_distance_to_other.mat')));
                if (size(datafile) > 0)
                    datafilename = datafile.name;
                    disp(datafilename);

                    load(datafilename);
                    dat(end+1) = data.dist;
                end

            end
            cd(startdir);
            cd(dirname);
        end
    end
    cd(startdir);


end

meandata = mean(dat);
dataSEM = std(dat) / sqrt(size(dat, 2));
disp(dataSEM);
data_n = size(dat, 2);
disp(data_n);

figuredata.mean = meandata;
figuredata.SEM = dataSEM;
figuredata.n = data_n;
figuredata.data = dat;

datafilename = strcat(fullfigname, '.mat');
outputpath = fullfile(outputdir, datafilename);
figurepath = fullfile(outputdir, fullfigname);
fignew = figure('Name', fullfigname);

bar(1, meandata, 0.1, 'm');
hold on;
errorbar(1, meandata, dataSEM, 'r');
hold off;
saveas(fignew, figurepath, 'epsc');
save(outputpath, 'figuredata');
