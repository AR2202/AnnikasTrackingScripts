
function [frames_indexed]= handle_flytracker_output_frame(filename, framefilename)

load(filename);
frametable=readtable(framefilename);
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
ind_data=arrayfun(@(x) horzcat(transpose(feat.data(x,:,1)),transpose(feat.data(x,:,2)),transpose(feat.data(x,:,3)),transpose(feat.data(x,:,4)),transpose(feat.data(x,:,5)),transpose(feat.data(x,:,6)),transpose(feat.data(x,:,7)),transpose(feat.data(x,:,8)),transpose(feat.data(x,:,9)),transpose(feat.data(x,:,10)),transpose(feat.data(x,:,11)),transpose(feat.data(x,:,12)),transpose(feat.data(x,:,13))),indices,'UniformOutput',false);
starts=cell(40,1);
ends=cell(40,1);
for i=1:height(frametable)
    starts{frametable.Var2(i)}=frametable.Var3(i);
    ends{frametable.Var2(i)}=frametable.Var4(i);
end

frames=cellfun(@(indiv,start,endframe) indiv(start:endframe,:),ind_data,starts,ends,'UniformOutput',false);
frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, frames,num2cell(indices),'UniformOutput',false);
