%Annika Rings, Feb 2019
%this function reads in a .xlsx file containing a list of experiments
%belonging to a genotype
%it then finds all the data of the experiments and averages them
%the arguments are:
%genotyplist = the .xlsx file containing the experiments

%genotype=genotype of the flies - is only used for 
%naming the output file
%xlsx file must have the following columns
%videoname,fly-id,delimitor(in file name, usually '_')

function find_videos_wingindex(genotypelist,genotype)
    outputtable=readtable(genotypelist,'readvariablenames',false);
    outputvar2=arrayfun(@(input) input,outputtable.Var2,'UniformOutput',false);

    startdir=pwd;
    wingindex=[];
    dirs = dir();
    path = 'wingindex';
   % expname = 'WI';
    %fieldname=char(strcat('F.',expname));

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
                if exist (path,'dir')
                cd(path);
                

         
           strtofind=filenames{q};
          disp(strtofind);
          datafile=dir(char(strcat('*',strtofind,'*','.mat')));
        if (size(datafile)>0)
            datafilename=datafile.name;
            disp(datafilename);
        
            load(datafilename);
            wingindex = [wingindex,WI];
        end
               
                end
            end
            cd(startdir);
            cd(dirname);
        end
    end
    cd(startdir);
   
   
end

datafilename=strcat(genotype,'_wingindex_tracker.mat');

 
 save(datafilename,'wingindex');

