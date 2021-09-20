%Annika Rings, August 2018
%this function reads in a .csv file containing a list of experiments
%belonging to a genotype
%it then finds all the data of the experiments and averages them
%the arguments are:
%genotyplist = the .csv file containing the experiments
%path=path to the subdirectory that contains the pdfdata - directory that
%must contain .mat files with structures called pdfdata in them
%expname=name of the field in the structure that contains the desired data
%genotype=genotype of the flies - is only used for labelling the figure(and
%naming the output file)
%csv file must have the following columns
%videoname,fly-id,deliminator(in file name)

function find_genotype_correl(genotypelist, path, genotype)
outputtable = readtable(genotypelist, 'readvariablenames', false);
%disp(outputtable.Var1);
videos = cellfun(@(list)dir(char(strcat('*', list))), outputtable.Var1, 'UniformOutput', false);

videonames = cellfun(@(struct)arrayfun(@(indiv) indiv.name(indiv.isdir == 1, :), struct, 'UniformOutput', false), videos, 'UniformOutput', false);
currentdir = pwd;
%fieldname=char(strcat('F.','correlation'));
for i = 1:size(videonames, 1)
    if (size(videonames{i}) > 0)
        cd(videonames{i}{1});
        cd(videonames{i}{1});
        cd(path);


        strtofind = strcat(string(videonames{i}{1}), string(outputtable.Var3(i)), string(outputtable.Var2(i)), string(outputtable.Var3(i)));
        disp(strtofind);
        datafile = dir(char(strcat('*', strtofind, '*', '.mat')));
        if (size(datafile) > 0)
            datafilename = datafile.name;
            disp(datafilename);

            load(datafilename);
            data(i, :) = arrayfun(@(F)F.correlation, pdfdata, 'UniformOutput', false);
        end
        cd(currentdir);
    end
end

matdata = cell2mat(data(:, 1));
meandata = mean(matdata);
dataSEM = std(matdata) / sqrt(size(matdata, 1));
data_n = size(matdata, 1);
figuredata.mean = meandata;
figuredata.SEM = dataSEM;
figuredata.n = data_n;
figuredata.data = data;
fullfigname = strcat(genotype, '_mean_correlation_coeff');
datafilename = strcat(fullfigname, '.mat');
fignew = figure('Name', fullfigname);
boxplot(matdata, 'colors', [1, 0, 1], 'Symbol', 'o', 'Widths', 0.1);

saveas(fignew, fullfigname, 'epsc');
save(datafilename, 'figuredata');
