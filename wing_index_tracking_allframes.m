%Annika Rings, September 2019
%this function calculates the wingextensionindex based on the tracking data
%in all frames of the tracking period (not removing copulation frames or
%filtering by duration of wing extension
%wing extension is defined as >30 deg wing angle
function WI=wing_index_tracking_allframes(filename)
inputfilename_full=strcat(filename,'-feat.mat');
outputdir='wingindex';
%load data
load(inputfilename_full);
indices=transpose(1:size(feat.data,1));
%concatenate all the data into a cell array with the right structure
ind_data=arrayfun(@(x) horzcat(transpose(feat.data(x,:,1)),transpose(feat.data(x,:,2)),transpose(feat.data(x,:,3)),transpose(feat.data(x,:,4))),indices,'UniformOutput',false);


    
%select only the wingextension frames
wing_ext_frames_all=cellfun(@(indiv) indiv(indiv(:,4)>pi/6,:),ind_data,'UniformOutput',false);
wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, wing_ext_frames_all,num2cell(indices),'UniformOutput',false);



%calculate WI
 WI=cellfun(@(wingext,all) size(wingext{1},1)/size(all,1), wing_ext_frames_indexed,ind_data,'uni',false);
 %save the files
 cellfun(@(data,index)saveWI(outputdir,strcat(filename,'_',num2str(index{2}),'_WI_allframes.mat'),data),WI,wing_ext_frames_indexed,'UniformOutput',false);

function saveWI(outputdir,filename,WI)
currentdir=pwd;
 if ~exist(outputdir,'dir')
     mkdir (outputdir);
 end
 cd(outputdir);
 save(filename,'WI');
 cd(currentdir);
