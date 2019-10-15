
function [wing_ext_frames_indexed]= handle_flytracker_outputs(filename)
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
load(filename);
indices=transpose(1:size(feat.data,1));
ind_data=arrayfun(@(x) horzcat(transpose(feat.data(x,:,1)),transpose(feat.data(x,:,2)),transpose(feat.data(x,:,3)),transpose(feat.data(x,:,4)),transpose(feat.data(x,:,5)),transpose(feat.data(x,:,6)),transpose(feat.data(x,:,7)),transpose(feat.data(x,:,8)),transpose(feat.data(x,:,9)),transpose(feat.data(x,:,10)),transpose(feat.data(x,:,11)),transpose(feat.data(x,:,12)),transpose(feat.data(x,:,13))),indices,'UniformOutput',false);
wing_ext_frames_all=cellfun(@(indiv) indiv(indiv(:,4)>pi/6,:),ind_data,'UniformOutput',false);
aboveThreshold=cellfun(@(indiv) (indiv(:,4)>pi/6),ind_data,'UniformOutput',false);
aboveThreshold=cellfun(@(above) [false;above;false],aboveThreshold,'uni',false);
edges = cellfun(@(above) diff(above),aboveThreshold,'UniformOutput',false);
rising = cellfun(@(edge) find(edge==1),edges,'UniformOutput',false);    %rising/falling edges
falling = cellfun(@(edge) find(edge==-1),edges,'UniformOutput',false);    %rising/falling edges
spanWidth = cellfun(@(rise,fall) fall-rise,rising,falling,'UniformOutput',false);  %width of span of 1's (above threshold)
wideEnough = cellfun(@(span) span >= 13,spanWidth,'UniformOutput',false);    
startPos = cellfun(@(rise,wideenough) transpose(rise(wideenough)),rising,wideEnough,'UniformOutput',false);    %start of each span
endPos = cellfun(@(fall,wideenough) transpose(fall(wideenough)-1),falling,wideEnough,'UniformOutput',false);  %end of each span
allInSpan = cellfun(@(starts,ends) arrayfun(@(x,y) (x:1:y), starts, ends, 'uni', false),startPos,endPos,'uni',false);  
catspans=cellfun(@(spans) [spans{:}], allInSpan,'uni',false);
wing_ext_frames_13frames=cellfun(@(indiv,catspan) indiv(catspan,:),ind_data,catspans,'UniformOutput',false);
contact_frames=cellfun(@(indiv) indiv(indiv(:,10)<2.5,:),ind_data,'UniformOutput',false);
contact=cellfun(@(indiv) (indiv(:,10)<2.5),ind_data,'UniformOutput',false);
contact=cellfun(@(above) [false;above;false],contact,'uni',false);
edges_contact = cellfun(@(above) diff(above),contact,'UniformOutput',false);
rising_contact = cellfun(@(edge) find(edge==1),edges_contact,'UniformOutput',false);    %rising/falling edges
falling_contact = cellfun(@(edge) find(edge==-1),edges_contact,'UniformOutput',false);    %rising/falling edges
spanWidth_contact = cellfun(@(rise,fall) fall-rise,rising_contact,falling_contact,'UniformOutput',false);  %width of span of 1's (above threshold)
wideEnough_contact = cellfun(@(span) span >= 1500,spanWidth_contact,'UniformOutput',false);    
startPos_contact = cellfun(@(rise,wideenough) transpose(rise(wideenough)),rising_contact,wideEnough_contact,'UniformOutput',false);    %start of each span
tf = cellfun('isempty',startPos_contact); % true for empty cells
startPos_contact(tf) = {15000} ; 
catspans_no_cop=cellfun(@(catspan,startPos_c) catspan(catspan<startPos_c(1)),catspans,startPos_contact,'uni',false);
removed_copulation=cellfun(@(indiv,catspan) indiv(catspan,:),ind_data,catspans_no_cop,'UniformOutput',false);
wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, removed_copulation,num2cell(indices),'UniformOutput',false);
