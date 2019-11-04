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

function find_videos_Indices_other(genotypelist,genotype)
outputtable=readtable(genotypelist,'readvariablenames',false);
outputvar2=arrayfun(@(input) input,outputtable.Var2);
Var4=arrayfun(@(var2)var2-(~isOdd(var2))+(isOdd(var2)),outputvar2);
cellVar4=arrayfun(@(var2)var2-(~isOdd(var2))+(isOdd(var2)),outputvar2,'uni',false);
outputtable.Var4=Var4;
startdir=pwd;
data=[];
data_approach=[];
data_CI=[];
data_init=[];
data_cop=[];
dirs = dir();


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
    videos=cellfun(@(list)dir(char(strcat('*',list))),unique(outputtable.Var1),'UniformOutput',false);
    
    videonames=cellfun(@(struct)arrayfun(@(indiv) indiv.name(indiv.isdir==1,:),struct,'UniformOutput',false),videos,'UniformOutput',false);
    %filenames=cellfun(@(videoname,var3,var2) strcat(string(videoname),string(var3),string(var2),string(var3)),videonames,outputtable.Var3,cellVar4,'UniformOutput',false);
    videonames=videonames(~cellfun(@isempty,videonames));
    %filenames=filenames(~cellfun(@isempty,filenames));
    
    if size(videonames,2)>0
        for q = 1:size(videonames,1)
            if exist (string(videonames{q}{1}),'dir')
                disp(videonames{q}{1});
                cd(videonames{q}{1});
                cd('Results');
                variablename_video=regexprep(videonames{q}{1},'(\w+)-(\w+)_Courtship-','');
                disp(variablename_video);
                %newtable = outputtable(strcmp(variablename_video,outputtable.Var1), : ); 
                newtable2=outputtable(cellfun(@(x) contains(videonames{q}{1},x), outputtable.Var1),:);
                %newtable3=vertcat(newtable,newtable2);
                newtable3=newtable2;
                disp(newtable3);
                
                
                
                strtofind=videonames{q}{1};
                disp(strtofind);
                datafile=dir(char(strcat('*',strtofind,'_Indices.csv')));
                
                
                if (size(datafile)>0)
                    datafilename=datafile.name;
                    disp(datafilename)
                    outputtable2=readtable(datafilename,'readvariablenames',true);
                    %disp(outputtable2);
                     for r=1:height(newtable3)
                    disp('Index in newtable3');    
                    disp(r);
                    disp('Fly ID');
                    disp(newtable3.Var4(r));
                    
 if isnumeric(outputtable2.WingIndex(outputtable2.FlyId==newtable3.Var4(r)))
                        WingIndex=outputtable2.WingIndex(outputtable2.FlyId==newtable3.Var4(r));
                    else
                       WingIndex=str2double(outputtable2.WingIndex(outputtable2.FlyId==newtable3.Var4(r))); 
                    end
                    disp('Wing Index:');
                    disp(WingIndex);
                    
                    if ismember(newtable3.Var4(r),outputtable2.FlyId)
                        
                        if (size(WingIndex)>0)
                            
                            data=[data,WingIndex];
                        end
                        
                    end
                    if isnumeric(outputtable2.ApproachingIndex(outputtable2.FlyId==newtable3.Var4(r)))
                        ApproachingIndex=outputtable2.ApproachingIndex(outputtable2.FlyId==newtable3.Var4(r));
                    else
                        ApproachingIndex=str2double(outputtable2.ApproachingIndex(outputtable2.FlyId==newtable3.Var4(r)));
                    end
                    disp('Approaching Index:');
                    disp(ApproachingIndex);
                    
                    if ismember(newtable3.Var4(r),outputtable2.FlyId)
                        
                        if (size(ApproachingIndex)>0)
                            
                            data_approach=[data_approach,ApproachingIndex];
                        end
                        
                    end
                    if isnumeric(outputtable2.CourtshipIndex(outputtable2.FlyId==newtable3.Var4(r)))
                        CourtshipIndex=outputtable2.CourtshipIndex(outputtable2.FlyId==newtable3.Var4(r));
                    else
                       CourtshipIndex=str2double(outputtable2.CourtshipIndex(outputtable2.FlyId==newtable3.Var4(r))); 
                    end
                    disp('Courtship Index:');
                    disp(CourtshipIndex);
                    
                    if ismember(newtable3.Var4(r),outputtable2.FlyId)
                        
                        if (size(CourtshipIndex)>0)
                            
                            data_CI=[data_CI,CourtshipIndex];
                        end
                        
                    end
                    if isnumeric(outputtable2.CourtshipInitiation(outputtable2.FlyId==newtable3.Var4(r)))
                        CourtshipInit=outputtable2.CourtshipInitiation(outputtable2.FlyId==newtable3.Var4(r));
                    else
                        CourtshipInit=str2double(outputtable2.CourtshipInitiation(outputtable2.FlyId==newtable3.Var4(r)));
                    end
                    disp('Courtship Initiation:');
                    disp(CourtshipInit);
                    
                    if ismember(newtable3.Var4(r),outputtable2.FlyId)
                        
                        if (size(CourtshipInit)>0)
                            
                            data_init=[data_init,CourtshipInit];
                        end
                        
                    end
                    if isnumeric(outputtable2.CourtshipTermination(outputtable2.FlyId==newtable3.Var4(r)))
                        CourtshipTermination=outputtable2.CourtshipTermination(outputtable2.FlyId==newtable3.Var4(r));
                    
                    else
                        CourtshipTermination=str2double(outputtable2.CourtshipTermination(outputtable2.FlyId==newtable3.Var4(r)));
                    end
                    disp('Courtship Termination:');
                    disp(CourtshipTermination);
                    if isnumeric(outputtable2.CourtshipDuration(outputtable2.FlyId==newtable3.Var4(r)))
                         CourtshipDuration=outputtable2.CourtshipDuration(outputtable2.FlyId==newtable3.Var4(r));
                    
                    else
                    CourtshipDuration=str2double(outputtable2.CourtshipDuration(outputtable2.FlyId==newtable3.Var4(r)));
                    end
                    disp('Courtship Duration:');
                    disp(CourtshipDuration);
                    
                    
                    if ismember(newtable3.Var4(r),outputtable2.FlyId)
                        
                        if (size(CourtshipTermination)>0)
                            
                            if CourtshipTermination>=900&&CourtshipDuration>=600
                                timeToCop=NaN;
                            else
                                
                                timeToCop=CourtshipTermination;
                            end
                        else
                            timeToCop=NaN;
                        end
                        data_cop=[data_cop,timeToCop];
                        
                        
                    end
                end
                end
            end
             cd(startdir);
            cd(dirname);
        end
        
    end
    cd(startdir);
end
fullfigname=strcat(genotype,'_mean_WingIndex_other_fly');
datafilename=strcat(fullfigname,'.mat');
save(datafilename,'data');
fullfigname_approach=strcat(genotype,'_mean_ApproachingIndex_other_fly');
datafilename=strcat(fullfigname_approach,'.mat');
save(datafilename,'data_approach');
fullfigname_CI=strcat(genotype,'_mean_CI_other_fly');
datafilename=strcat(fullfigname_CI,'.mat');
save(datafilename,'data_CI');
fullfigname_init=strcat(genotype,'_courtshipInitiation_other_fly');
datafilename=strcat(fullfigname_init,'.mat');
save(datafilename,'data_init');
fullfigname_cop=strcat(genotype,'_timeToCop_other_fly');
datafilename=strcat(fullfigname_cop,'.mat');
save(datafilename,'data_cop');




