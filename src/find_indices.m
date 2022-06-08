function find_indices(outputtable, outputname, olddataformat) 

startdir = pwd;
data.wing = [];
data.approach = [];
data.CIwF = [];
data.contact = [];
data.circling = [];
data.facing = [];
data.turning = [];
data.CI = [];
data.init = [];
data.cop = [];
dirs = dir();
dirnames = {};
for p = 1:numel(dirs)
    if ~dirs(p).isdir
        continue;
    end
    dirname = dirs(p).name;
    if ismember(dirname, {'.', '..'})
        continue;
    end

    
    
    if olddataformat
      dirnames{end+1} =  dirname;
    else
        subdirs = dir(dirname);
        tracked_subdirs= subdirs(~strcmp({subdirs.name}, '.')&[subdirs.isdir]==1&contains({subdirs.name},'Tracked'));
        %convert to table for sorting
        T = struct2table(tracked_subdirs);
        %sort by tracking date, newest first (based on name of directory)
        sortedT = sortrows(T, 'name', 'descend');
        sortedSubdirs = table2struct(sortedT);
        if numel(sortedSubdirs) >= 1
            % this will use the newest tracking only. 
            %If this behaviour is not intended, it needs to be changed
            subdirname = sortedSubdirs(1).name;
            dirname_full = fullfile(dirname,subdirname);
            dirnames{end+1} =  dirname_full;
        end
        
       
    end
end
for p = 1:numel(dirnames)
    dirname = dirnames{p};
disp(['Now looking in: ', dirname]);
    cd(dirname);
    videos = cellfun(@(list)dir(char(strcat('*', list))), unique(outputtable.Var1), 'UniformOutput', false);

    videonames = cellfun(@(struct)arrayfun(@(indiv) indiv.name(indiv.isdir == 1, :), struct, 'UniformOutput', false), videos, 'UniformOutput', false);

    videonames = videonames(~cellfun(@isempty, videonames));


    if size(videonames, 2) > 0
        disp(videonames);
        for q = 1:size(videonames, 1)
            if exist(string(videonames{q}{1}), 'dir')
                disp(videonames{q}{1});
                cd(videonames{q}{1});
                if exist('Results','dir')
                cd('Results');
                variablename_video = regexprep(videonames{q}{1}, '(\w+)-(\w+)_Courtship-', '');
                disp(variablename_video);
               
                newtable2 = outputtable(cellfun(@(x) contains(videonames{q}{1}, x), outputtable.Var1), :);
               
                newtable3 = newtable2;
                disp(newtable3);

                strtofind = videonames{q}{1};
                disp(strtofind);
                datafile = dir(char(strcat('*', strtofind, '_Indices.csv')));


                if (size(datafile) > 0)
                    datafilename = datafile.name;
                    disp(datafilename)
                    outputtable2 = readtable(datafilename, 'readvariablenames', true);

                    for r = 1:height(newtable3)
                        disp('Index in newtable3');
                        disp(r);
                        disp('Fly ID');
                        disp(newtable3.Var2(r));
                        disp(outputtable2);
                        datanames = {'wing','approach','CI','CIwF','contact','circling','facing','turning'};
                        if olddataformat
                            indices_names = {'WingIndex','ApproachingIndex','CourtshipIndex','CourtshipIndexWithFacing','ContactIndex','EncirclingIndex','FacingIndex','TurningIndex'};
                        else
                            indices_names ={'wing', 'approaching','CI','CIwF','contact','circling','facing','turning'};
                        end
                            for index_num = 1: length(indices_names)
                                index = indices_names{index_num};
                                dataname = datanames{index_num};
                                

                       
                       if isnumeric(outputtable2.(index)(outputtable2.FlyId == newtable3.Var2(r)))
                          CurrIndex = outputtable2.(index)(outputtable2.FlyId == newtable3.Var2(r));
                       else
                            CurrIndex = str2double(outputtable2.(index)(outputtable2.FlyId == newtable3.Var2(r)));
                        end
                        disp(index);
                        disp(CurrIndex);
                            
                        if ismember(newtable3.Var2(r), outputtable2.FlyId)

                            if (size(CurrIndex) > 0)

                                data.(dataname) = [data.(dataname), CurrIndex];
                            end
                             
                        end

                            end
                         if ismember('time_to_init',outputtable2.Properties.VariableNames)  
                        if isnumeric(outputtable2.time_to_init(outputtable2.FlyId == newtable3.Var2(r)))
                          CurrIndex = outputtable2.time_to_init(outputtable2.FlyId == newtable3.Var2(r));
                       else
                            CurrIndex = str2double(outputtable2.(index)(outputtable2.FlyId == newtable3.Var2(r)));
                        end
                        disp(index);
                        disp(CurrIndex);
                            
                        if ismember(newtable3.Var2(r), outputtable2.FlyId)

                            if (size(CurrIndex) > 0)

                                data.init = [data.init, CurrIndex];
                            end
                             
                        end
                           end
%                         if isnumeric(outputtable2.ApproachingIndex(outputtable2.FlyId == newtable3.Var2(r)))
%                             ApproachingIndex = outputtable2.ApproachingIndex(outputtable2.FlyId == newtable3.Var2(r));
%                         else
%                             ApproachingIndex = str2double(outputtable2.ApproachingIndex(outputtable2.FlyId == newtable3.Var2(r)));
%                         end
%                         disp('Approaching Index:');
%                         disp(ApproachingIndex);
% 
%                         if ismember(newtable3.Var2(r), outputtable2.FlyId)
% 
%                             if (size(ApproachingIndex) > 0)
% 
%                                 data_approach = [data_approach, ApproachingIndex];
%                             end
% 
%                         end
%                         if isnumeric(outputtable2.CourtshipIndex(outputtable2.FlyId == newtable3.Var2(r)))
%                             CourtshipIndex = outputtable2.CourtshipIndex(outputtable2.FlyId == newtable3.Var2(r));
%                         else
%                             CourtshipIndex = str2double(outputtable2.CourtshipIndex(outputtable2.FlyId == newtable3.Var2(r)));
%                         end
%                         disp('Courtship Index:');
%                         disp(CourtshipIndex);
% 
%                         if ismember(newtable3.Var2(r), outputtable2.FlyId)
% 
%                             if (size(CourtshipIndex) > 0)
% 
%                                 data_CI = [data_CI, CourtshipIndex];
%                             end
% 
%                         end
%                         if isnumeric(outputtable2.CourtshipInitiation(outputtable2.FlyId == newtable3.Var2(r)))
%                             CourtshipInit = outputtable2.CourtshipInitiation(outputtable2.FlyId == newtable3.Var2(r));
%                         else
%                             CourtshipInit = str2double(outputtable2.CourtshipInitiation(outputtable2.FlyId == newtable3.Var2(r)));
%                         end
%                         disp('Courtship Initiation:');
%                         disp(CourtshipInit);
% 
%                         if ismember(newtable3.Var2(r), outputtable2.FlyId)
% 
%                             if (size(CourtshipInit) > 0)
% 
% 
%                                 init = CourtshipInit;
%                             else
%                                 init = NaN;
%                             end
%                             data_init = [data_init, init];
%                         end
% 
% 
%                         if isnumeric(outputtable2.CourtshipTermination(outputtable2.FlyId == newtable3.Var2(r)))
%                             CourtshipTermination = outputtable2.CourtshipTermination(outputtable2.FlyId == newtable3.Var2(r));
% 
%                         else
%                             CourtshipTermination = str2double(outputtable2.CourtshipTermination(outputtable2.FlyId == newtable3.Var2(r)));
%                         end
%                         disp('Courtship Termination:');
%                         disp(CourtshipTermination);
%                         if isnumeric(outputtable2.CourtshipDuration(outputtable2.FlyId == newtable3.Var2(r)))
%                             CourtshipDuration = outputtable2.CourtshipDuration(outputtable2.FlyId == newtable3.Var2(r));
% 
%                         else
%                             CourtshipDuration = str2double(outputtable2.CourtshipDuration(outputtable2.FlyId == newtable3.Var2(r)));
%                         end
%                         disp('Courtship Duration:');
%                         disp(CourtshipDuration);
% 
% 
%                         if ismember(newtable3.Var2(r), outputtable2.FlyId)
% 
%                             if (size(CourtshipTermination) > 0)
% 
%                                 if CourtshipTermination >= 900 && CourtshipDuration >= 600
%                                     timeToCop = NaN;
%                                 else
% 
%                                     timeToCop = CourtshipTermination;
%                                 end
%                             else
%                                 timeToCop = NaN;
%                             end
%                             data_cop = [data_cop, timeToCop];


                        %end
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


save(outputname, 'data');

