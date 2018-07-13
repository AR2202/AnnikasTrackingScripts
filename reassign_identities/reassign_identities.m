function reassign_identities(inputdir)
JAABAfolder=strcat(inputdir,'_JAABA');
JAABAfolder_path=fullfile(inputdir,JAABAfolder);
id_path=fullfile(inputdir,'ids.mat');
assign_chambers(inputdir);
assign_score_identities(JAABAfolder_path,id_path);
end