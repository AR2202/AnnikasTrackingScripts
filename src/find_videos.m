%Annika Rings, Nov 2018
%this function reads in a .xlsx file containing a list of experiments
%belonging to a genotype
%it then finds all the data of the experiments and averages them
%the arguments are:
%genotyplist = the .xlsx file containing the experiments
%path=path to the subdirectory that contains the pdfdata - directory that
%must contain .mat files with structures called pdfdata in them
%expname=name of the field in the structure that contains the desired data
%genotype=genotype of the flies - is only used for labelling the figure(and
%naming the output file)
%xlsx file must have the following columns
%videoname,fly-id,delimitor(in file name, usually '_')

function find_videos(genotypelist, path, expname, genotype)
outputtable = readtable(genotypelist, 'readvariablenames', false);
outputvar2 = arrayfun(@(input) input, outputtable.Var2, 'UniformOutput', false);

startdir = pwd;
data = {};
dirs = dir();
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
            if exist(string(videonames{q}{1}), 'dir')
                disp(videonames{q}{1});
                cd(videonames{q}{1});
                cd(videonames{q}{1});
                cd(path);


                strtofind = filenames{q};
                disp(strtofind);
                datafile = dir(char(strcat('*', strtofind, '*', '.mat')));
                if (size(datafile) > 0)
                    datafilename = datafile.name;
                    disp(datafilename);

                    load(datafilename);
                    data(end+1, :) = arrayfun(@(F)eval(fieldname), pdfdata, 'UniformOutput', false);
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
figuredata.x = xmean;
figuredata.mean = meandata;
figuredata.SEM = dataSEM;
figuredata.n = data_n;
figuredata.data = matdata;
fullfigname = strcat(genotype, '_mean_', expname);
datafilename = strcat(fullfigname, '.mat');
fignew = figure('Name', fullfigname);
% plot the mean with a shaded area showing the SEM
h = boundedline(xmean, meandata, dataSEM, 'm');
saveas(fignew, fullfigname, 'epsc');
save(datafilename, 'figuredata');
