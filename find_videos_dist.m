
%Annika Rings July 2019
%FIND_VIDEOS_DIST(genotypelist,genotype)
%
%averages the distance_travelled data for the flies specified in
%genotypelist
%genotype is just the label for the outputdatafile
%both arguments are of type string
function find_videos_dist(genotypelist,genotype)

path = 'distance_travelled';
structname = 'data';
expname = 'dist';
outputtable=readtable(genotypelist,'readvariablenames',false);

outputvar2=arrayfun(@(input) input,outputtable.Var2,'UniformOutput',false);

startdir=pwd;
dat=[];
dirs = dir();
fieldname=char(strcat('F.',expname));

for p = 1:numel(dirs)
    if ~dirs(p).isdir
        continue;
    end
    dirname = dirs(p).name;
    if ismember(dirname,{'.','..'})
        continue;
    end
    
    disp(['Now looking in: ' dirname]);
    cd(dirname);
    videos=cellfun(@(list)dir(char(strcat('*',list))),outputtable.Var1,'UniformOutput',false);
    
    
    videonames=cellfun(@(struct)arrayfun(@(indiv) indiv.name(indiv.isdir==1,:),struct,'UniformOutput',false),videos,'UniformOutput',false);
    
    filenames=cellfun(@(videoname,var3,var2) strcat(string(videoname),string(var3),string(var2),string(var3)),videonames,outputtable.Var3,outputvar2,'UniformOutput',false);
    videonames=videonames(~cellfun(@isempty,videonames));
    filenames=filenames(~cellfun(@isempty,filenames));
    
    if size(videonames,2)>0
        for q = 1:size(videonames,1)
            if exist (videonames{q}{1},'dir')
                disp(videonames{q}{1});
                cd(videonames{q}{1});
                cd(videonames{q}{1});
                cd(path);
                
                
                
                strtofind=filenames{q};
                disp(strtofind);
                datafile=dir(char(strcat('*',strtofind,'distance_travelled.mat')));
                if (size(datafile)>0)
                    datafilename=datafile.name;
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

meandata=mean(dat);
dataSEM=std(dat)/sqrt(size(dat,1));
data_n=size(dat,1);

figuredata.mean=meandata;
figuredata.SEM=dataSEM;
figuredata.n=data_n;
figuredata.data=dat;
fullfigname=strcat(genotype,'_mean_',expname);
datafilename=strcat(fullfigname,'.mat');
fignew=figure('Name',fullfigname);

bar(1,meandata,0.1,'m');
hold on;
errorbar(1,meandata,dataSEM, 'r');
hold off;
saveas(fignew,fullfigname,'epsc');
save(datafilename,'figuredata');

