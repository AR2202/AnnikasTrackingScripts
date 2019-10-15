function find_genotype_Indices(genotypelist,genotype)
outputtable=readtable(genotypelist,'readvariablenames',false);
videos=cellfun(@(list)dir(char(strcat('*',list))),outputtable.Var1,'UniformOutput',false);

videonames=cellfun(@(struct)arrayfun(@(indiv) indiv.name(indiv.isdir==1,:),struct,'UniformOutput',false),videos,'UniformOutput',false);
currentdir=pwd;

for i=1:size(videonames,1)
    if (size(videonames{i})>0)
        cd(videonames{i}{1});
        cd('Results');


        strtofind=string(videonames{i}{1});
        disp(strtofind);
        datafile=dir(char(strcat('*',strtofind,'_Indices.csv')));
            if (size(datafile)>0)
                datafilename=datafile.name;
                disp(datafilename)
                outputtable2=readtable(datafilename,'readvariablenames',true);
                %disp(outputtable2);


                WingIndex=outputtable2.WingIndex(outputtable2.FlyId==outputtable.Var2(i));

                disp(WingIndex);

                if ismember(outputtable.Var2(i),outputtable2.FlyId)

                if (size(WingIndex)>0)

                data(i)=WingIndex;
                end

                end
            end
        end

        cd(currentdir);
    end
fullfigname=strcat(genotype,'_mean_WingIndex');
datafilename=strcat(fullfigname,'.mat');
save(datafilename,'data');