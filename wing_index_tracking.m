function WI=wing_index_tracking(filename)
inputfilename_full=strcat(filename,'-feat.mat');
outputdir='wingindex';
wing_ext_frames_indexed=handle_flytracker_outputs(inputfilename_full);
frames_no_cop=remove_copulation(inputfilename_full);
WI=cellfun(@(wingext,all) size(wingext{1,1},1)/size(all,1), wing_ext_frames_indexed,frames_no_cop,'uni',false);
cellfun(@(data,index)saveWI(outputdir,strcat(filename,'_',num2str(index{1,2}),'_WI.mat'),data),WI,wing_ext_frames_indexed,'UniformOutput',false);

function saveWI(outputdir,filename,WI)
currentdir=pwd;
 if ~exist(outputdir,'dir')
     mkdir (outputdir);
 end
 cd(outputdir);
 save(filename,'WI');
 cd(currentdir);
