%Annika Rings, Jan 2019
%this function reads in a .xlsx file containing a list of experiments
%belonging to a genotype
%it then finds all the data of the experiments and saves them to a .mat
%file
%the arguments are:
%genotyplist = the .xlsx file containing the experiments
%genotype=genotype of the flies - is only used for naming the output file
%score: the name of the JAABA classifier as it appears in the name of the
%scores file
%windowsize: size of the moving average window (in frames)
%cutofffrac: fraction of the frames that have to be positive for the event
%in the specified window
%
%xlsx file must have the following columns
%videoname,fly-id,delimitor(in file name, usually '_')
%must be run inside the directory that contains the folders named
%xxx_Courtship which contain the video folders

function find_videos_scores(genotypelist,genotype,score,windowsize,cutofffrac)
outputtable=readtable(genotypelist,'readvariablenames',false);
disp(outputtable);
outputvar2=arrayfun(@(input) input,outputtable.Var2,'UniformOutput',false);

startdir=pwd;
mean=[];
events={};
scorename=strcat('scores_',score,'_id_corrected.mat');

dirs = dir('*Courtship');

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
    
    videonames=videonames(~cellfun(@isempty,videonames));
    
   
    if size(videonames,2)>0
        disp(videonames);
        for q = 1:size(videonames,1)
            if exist (string(videonames{q}{1}),'dir')
                disp(videonames{q}{1});
                JAABAname=char(strcat(string(videonames{q}{1}),'_JAABA'));
                cd(videonames{q}{1});
                cd(videonames{q}{1});
                cd(JAABAname);
                variablename_video=regexprep(videonames{q}{1},'(\w+)-(\w+)_Courtship-','');
                variablename_video1=regexprep(videonames{q}{1},'(\w+)-(\w+)_Courtship-','$2_Courtship-');
                disp(variablename_video);
                disp(variablename_video1);
                newtable = outputtable(strcmp(variablename_video,outputtable.Var1), : ); 
                newtable1 = outputtable(strcmp(variablename_video1,outputtable.Var1), : ); 
                newtable2=outputtable(strcmp(videonames{q}{1},outputtable.Var1),:);
                newtable3=vertcat(newtable,newtable1,newtable2);
                disp(newtable3);
                
               
                
                
                    for r=1:height(newtable3)
                    disp('Index in newtable3');    
                    disp(r);
                    disp('Fly ID');
                    disp(newtable3.Var2(r));
                    flyid=newtable3.Var2(r);
                    [eventduration,spanW]=eventdur(scorename,flyid,windowsize,cutofffrac);
                    mean=[eventduration,mean];
                    events=vertcat(spanW,events);
                    
                    
                    
                        
                    
                    
                   
                        
                   
                        
                    
                   
                        
                    
                end
                end
            
             cd(startdir);
            cd(dirname);
       
       end 
    end
    cd(startdir);
end
datafilename=strcat(genotype,'_eventdur_',score,'.mat');

save(datafilename,'mean','events');




