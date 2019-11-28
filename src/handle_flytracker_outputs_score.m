
function [wing_ext_frames_indexed]= handle_flytracker_outputs_score(filename,score,windowsize,cutofffrac)
% Annika Rings, April 2019
%
%HANDLE_FLYTRACKER_OUTPOUT_SCORE is a function that extracts frames that
%are positive for the specified score in JAABA
%the input arguments are:
%filename: name of the file that contains tracking data (-feat.mat file)
%score: name of the score from JAABA
%windowsize: size of the moving average window (in frames)
%cutofffrac: fraction of the frames that have to be positive for the event
%in the specified window

%these are the data in the -feat.mat file
%  vel=feat.data(:,:,1);
%  ang_vel=feat.data(:,:,2);
%  min_wing_ang=feat.data(:,:,3);
%  max_wing_ang=feat.data(:,:,4);
%  mean_wing_length=feat.data(:,:,5);
%  axis_ratio=feat.data(:,:,6);
%  fg_body_ratio=feat.data(:,:,7);
%  contrast=feat.data(:,:,8);
%  dist_to_wall=feat.data(:,:,9);
%  dist_to_other=feat.data(:,:,10);
%  angle_between=feat.data(:,:,11);
%  facing_angle=feat.data(:,:,12);
%  leg_dist=feat.data(:,:,13);

%these are the data in the scores file:
%allScores.postprocessed{1,index}
load(filename);
load(score);
%scoresflat = zeros(40,22500);
scores=allScores.postprocessed;
% for i=1:size(allScores.postprocessed,2)
%     scoresflat(i,1:size(allScores.postprocessed{i},2))=allScores.postprocessed{i};
% end

indices=transpose(1:size(feat.data,1));
featnumber = size(feat.data,3);
ind_data=arrayfun(@(x) concatenate_data(x,featnumber, feat),indices,'UniformOutput',false);
%moving_avg=cellfun(@(indiv) movmean(indiv(:,featnumber),windowsize),ind_data,'UniformOutput',false);
moving_avg=cellfun(@(indiv) movmean(indiv,windowsize),scores,'UniformOutput',false);

event=cellfun(@(avg) (avg>cutofffrac),moving_avg,'UniformOutput',false);
event=cellfun(@(above) [false above false],event,'uni',false);

edges = cellfun(@(ev) diff(ev),event,'UniformOutput',false);
rising = cellfun(@(edge) find(edge==1),edges,'UniformOutput',false);    %rising/falling edges
falling = cellfun(@(edge) find(edge==-1),edges,'UniformOutput',false);    %rising/falling edges


allInSpan = cellfun(@(starts,ends) arrayfun(@(x,y) (x:1:(y-1)), starts, ends, 'uni', false),rising,falling,'uni',false);  
catspans=cellfun(@(spans) [spans{:}], allInSpan,'uni',false);
catspansT= transpose(catspans);

pos_for_score=cellfun(@(indiv,catspan) indiv(catspan,:),ind_data,catspansT,'UniformOutput',false);
wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, pos_for_score,num2cell(indices),'UniformOutput',false);
