
function [filtered_frames_ind]= all_frames_ind_filtered(filename,filterby,cutoffval,above)

load(filename);
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
indices=transpose(1:size(feat.data,1));
featnumber = size(feat.data,3);
ind_data=arrayfun(@(x) concatenate_data(x,featnumber, feat),indices,'UniformOutput',false);
    if above
        filtered_frames=cellfun(@(indiv) indiv(indiv(:,filterby)>cutoffval,:),ind_data,'UniformOutput',false);
    else
        filtered_frames=cellfun(@(indiv) indiv(indiv(:,filterby)<cutoffval,:),ind_data,'UniformOutput',false);
        
    end
    

filtered_frames_ind=cellfun(@(cell1,cell2) {cell1,cell2}, filtered_frames,num2cell(indices),'UniformOutput',false);
