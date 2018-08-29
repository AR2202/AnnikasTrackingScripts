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

function find_genotype(genotypelist,path,expname,genotype)
outputtable=readtable(genotypelist);
videos=cellfun(@(list)dir(char(strcat('*',list,'*'))),outputtable.Var1,'UniformOutput',false);
videonames=cellfun(@(struct)arrayfun(@(indiv) indiv.name(indiv.isdir==1,:),struct,'UniformOutput',false),videos,'UniformOutput',false);
currentdir=pwd;
fieldname=strcat('F.',expname);
for i=1:height(outputtable)
cd(videonames{i}{1});
cd(videonames{i}{1});
cd(path);


strtofind=strcat(string(videonames{i}{1}),string(outputtable.Var3(i)),string(outputtable.Var2(i)));
disp(strtofind);
datafile=dir(char(strcat('*',strtofind,'*','.mat')));
datafilename=datafile.name;
disp(datafilename);
load(datafilename);
data(i,:) = arrayfun(@(F)eval(fieldname),pdfdata,'UniformOutput',false);

cd(currentdir);
end
matdata=cell2mat(data(:,2));
meandata=mean(matdata);
x=cell2mat(data(1,1));
dataSEM=std(matdata)/sqrt(size(matdata,1));
figuredata.x=x;
figuredata.mean=meandata;
figuredata.SEM=dataSEM;
fullfigname=strcat(genotype,'_mean_',expname);
datafilename=strcat(fullfigname,'.mat');
 fignew=figure('Name',fullfigname);
 %plot the mean with a shaded area showing the SEM
 h=boundedline(x,meandata, dataSEM,'m');
 saveas(fignew,fullfigname,'epsc');
 save(datafilename,'figuredata');
