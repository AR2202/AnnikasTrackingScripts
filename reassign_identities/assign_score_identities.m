function assign_score_identities(scoresdir,idsfile)
startdir=pwd;
load(idsfile);
cd (scoresdir);

scoresfiles=dir('scores*.mat');
scoresfilenames=arrayfun(@(f) f.name,scoresfiles,'UniformOutput',false);
outputfilenames=cellfun(@(f) strrep(f,'.mat','_id_corrected.mat'),scoresfilenames,'UniformOutput',false);
cellfun(@(scoresfilename,outputfilename) id_correct_scorefile(scoresfilename,outputfilename,ids),scoresfilenames,outputfilenames);

cd(startdir);
clear all;
end
function id_correct_scorefile(scoresfilename,outputfilename,ids)
load(scoresfilename);
scores=allScores.scores;
postprocessed=allScores.postprocessed;
id_new = ids.id_new;
id_old = ids.id_old;
for i=1:numel(id_old)
postprocessed_new{1,id_new(i)}=postprocessed{1,id_old(i)};
scores_new{1,id_new(i)}=scores{1,id_old(i)};
end

allScores.scores=deal(scores_new);
allScores.postprocessed=deal(postprocessed_new);
save(outputfilename,'allScores');
end