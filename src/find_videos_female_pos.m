%Annika Rings, Nov 2018
%this function reads in a .xlsx file containing a list of experiments
%belonging to a genotype
%it then finds all the data of the experiments and averages them
%the arguments are:
%genotyplist = the .xlsx file containing the experiments
%path=path to the subdirectory that contains the female_pos - directory that
%must contain .mat files with structures called female_pos in them
%expname=name of the field in the structure that contains the desired data
%genotype=genotype of the flies - is only used for labelling the figure(and
%naming the output file)
%xlsx file must have the following columns
%videoname,fly-id,delimitor(in file name, usually '_')

function find_videos_female_pos(genotypelist, genotype)
outputtable = readtable(genotypelist, 'readvariablenames', false);
outputvar2 = arrayfun(@(input) input, outputtable.Var2, 'UniformOutput', false);

startdir = pwd;
data = {};
data_male = {};
dirs = dir();
path = 'female_pos';
expname = 'data';
fieldname = char(strcat('F.', expname));

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
                    datafile = dir(char(strcat('*', strtofind, '*', 'female_pos.mat')));
                    datafile_male = dir(char(strcat('*', strtofind, 'male_pos.mat')));
                    if (size(datafile) > 0)
                        datafilename = datafile.name;
                        disp(datafilename);

                        load(datafilename);
                        data(end+1, :) = arrayfun(@(F)eval(fieldname), female_pos, 'UniformOutput', false);
                    end
                    if (size(datafile_male) > 0)
                        datafilename_male = datafile_male.name;
                        disp(datafilename_male);

                        load(datafilename_male);
                        data_male(end+1, :) = arrayfun(@(F)eval(fieldname), male_pos, 'UniformOutput', false);
                    end
                end
            end
            cd(startdir);
            cd(dirname);
        end
    end
    cd(startdir);


end
matdata = cell2mat(data(:, 2));
meandata = mean(matdata);
x = cell2mat(data(:, 1));
xmean = mean(x);
dataSEM = std(matdata) / sqrt(size(matdata, 1));
data_n = size(matdata, 1);
figuredata.x = x;
figuredata.mean = meandata;
figuredata.SEM = dataSEM;
figuredata.n = data_n;
figuredata.y = matdata;
fullfigname = strcat(genotype, '_female_pos');
datafilename = strcat(fullfigname, '.mat');
save(datafilename, 'figuredata');

%maledata
matdata_male = cell2mat(data_male(:, 2));
meandata_male = mean(matdata_male);
x_male = cell2mat(data_male(:, 1));
xmean_male = mean(x_male);
dataSEM_male = std(matdata_male) / sqrt(size(matdata_male, 1));
data_n_male = size(matdata_male, 1);
figuredata.x = x_male;
figuredata.mean = meandata_male;
figuredata.SEM = dataSEM_male;
figuredata.n = data_n_male;
figuredata.y = matdata_male;
fullfigname = strcat(genotype, '_male_pos');
datafilename = strcat(fullfigname, '.mat');
save(datafilename, 'figuredata');
