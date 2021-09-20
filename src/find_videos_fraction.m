%Annika Rings Jan 2021
%FIND_VIDEOS_FRACTIONn(genotypelist,path,expname,genotype)
%
%averages the phototaxis data for the flies specified in
%genotypelist
%genotype is just the label for the outputdatafile
%both arguments are of type string
function find_videos_fraction(genotypelist, path, expname, genotype)


outputtable = readtable(genotypelist, 'readvariablenames', false);

outputvar2 = arrayfun(@(input) input, outputtable.Var2, 'UniformOutput', false);

startdir = pwd;
frac = [];
dirs = dir();


for p = 1:numel(dirs)
    if ~dirs(p).isdir
        continue;
    end
    dirname = dirs(p).name;
    if ismember(dirname, {'.', '..'})
        continue;
    end

    disp(['Now looking in: ', dirname]);
    cd(dirname);
    videos = cellfun(@(list)dir(char(strcat('*', list))), outputtable.Var1, 'UniformOutput', false);


    videonames = cellfun(@(struct)arrayfun(@(indiv) indiv.name(indiv.isdir == 1, :), struct, 'UniformOutput', false), videos, 'UniformOutput', false);

    filenames = cellfun(@(videoname, var3, var2) strcat(string(videoname), string(var3), string(var2), string(var3)), videonames, outputtable.Var3, outputvar2, 'UniformOutput', false);
    videonames = videonames(~cellfun(@isempty, videonames));
    filenames = filenames(~cellfun(@isempty, filenames));

    if size(videonames, 2) > 0
        for q = 1:size(videonames, 1)
            if exist(videonames{q}{1}, 'dir')
                disp(videonames{q}{1});
                cd(videonames{q}{1});
                cd(videonames{q}{1});
                if exist(path, 'dir')
                    cd(path);


                    strtofind = filenames{q};
                    disp(strtofind);
                    datafile = dir(char(strcat('*', strtofind, expname, '_', 'fraction', '.mat')));
                    if (size(datafile) > 0)
                        datafilename = datafile.name;
                        disp(datafilename);

                        load(datafilename);
                        frac(end+1) = data{1};
                    end
                end

            end
            cd(startdir);
            cd(dirname);
        end
    end
    cd(startdir);


end
%disp(frac);
meanfrac = mean(frac);
fracSEM = std(frac) / sqrt(size(frac, 2));
fullfigname = strcat(genotype, '_', expname, '_mean_fraction_frames');
datafilename = strcat(fullfigname, '.mat');
fignew = figure('Name', fullfigname);

bar(1, meanfrac, 0.1, 'm');
hold on;
er = errorbar(1, meanfrac, fracSEM, fracSEM);
er.Color = [0, 0, 0];
er.LineStyle = 'none';
hold off;
saveas(fignew, fullfigname, 'epsc');
save(datafilename, 'frac', 'meanfrac', 'fracSEM');
