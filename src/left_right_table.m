function left_right_table(inputdir)
inputdir_JAABA=strcat(inputdir,'_JAABA');
outputpath=fullfile(inputdir,'Results',strcat(inputdir,'left-right.csv'));
inputpath=fullfile(inputdir,inputdir,inputdir_JAABA,'trx_id_corrected.mat');
load(inputpath);

id=arrayfun(@(i) i.id, trx);
startpos=arrayfun(@(pos) pos.startpos, trx);
id=transpose(id);
startpos=transpose(startpos);
Toutput=table(id,startpos);

writetable(Toutput,outputpath,'WriteVariableNames',true); 
       