
function [right_wing_ext_frames_indexed, left_wing_ext_frames_indexed]= handle_track_outputs(inputfilename)
featfilename=strcat(inputfilename,'-feat.mat');
trackfilename=strcat(inputfilename,'-track.mat');

load(featfilename);
load(trackfilename);
%  pos x=trk.data(:,:,1);
%  pos y=trk.data(:,:,2);
%ori = trk.data(:,:,3);

% right_wing_ang=trk.data(:,:,16);
%  left_wing_ang=trk.data(:,:,14);
 %dist_to_other=feat.data(:,:,10);
 %facing_angle=feat.data(:,:,12);
%all DATA
indices=transpose(1:size(trk.data,1));
ind2=arrayfun(@(ind)ind-(~isOdd(ind))+(isOdd(ind)),indices);
ind_data=arrayfun(@(x,x2) horzcat(transpose(trk.data(x,:,1)),transpose(trk.data(x,:,2)),transpose(trk.data(x,:,3)),transpose(trk.data(x2,:,1)),transpose(trk.data(x2,:,2)),transpose(feat.data(x,:,4)),transpose(trk.data(x,:,7)),transpose(trk.data(x,:,8)),transpose(trk.data(x,:,9)),transpose(feat.data(x,:,10)),transpose(trk.data(x,:,11)),transpose(feat.data(x,:,12)),transpose(trk.data(x,:,13)),transpose(trk.data(x,:,14)),transpose(trk.data(x,:,15)),transpose(trk.data(x,:,16))),indices,ind2,'UniformOutput',false);
%ind_data contains:
    %  pos x=ind_data(:,:,1);
    %  pos y=ind_data(:,:,2);
    %ori = ind_data(:,:,3);
    %  pos x of target fly=ind_data(:,:,4);
    %  pos y of target fly=ind_data(:,:,5);
 % max_wing_angle=ind_data(:,:,6);

    %dist_to_other=ind_data(:,:,10);
    %facing_angle=ind_data(:,:,12);
    
    % left_wing_ang=ind_data(:,:,14);
    % right_wing_ang=ind_data(:,:,16);
 %right wing extension
 wing_ext_frames_right=cellfun(@(indiv) indiv(indiv(:,16)>pi/16,:),ind_data,'UniformOutput',false);
 aboveThreshold_r=cellfun(@(indiv) (indiv(:,6)>pi/6),ind_data,'UniformOutput',false);
 aboveThreshold_r=cellfun(@(above) [false;above;false],aboveThreshold_r,'uni',false);
 edges_r = cellfun(@(above) diff(above),aboveThreshold_r,'UniformOutput',false);
 rising_r = cellfun(@(edge) find(edge==1),edges_r,'UniformOutput',false);    %rising/falling edges
 falling_r = cellfun(@(edge) find(edge==-1),edges_r,'UniformOutput',false);    %rising/falling edges
 spanWidth_r = cellfun(@(rise,fall) fall-rise,rising_r,falling_r,'UniformOutput',false);  %width of span of 1's (above threshold)
 wideEnough_r = cellfun(@(span) span >= 13,spanWidth_r,'UniformOutput',false);    
 startPos_r = cellfun(@(rise,wideenough) transpose(rise(wideenough)),rising_r,wideEnough_r,'UniformOutput',false);    %start of each span
 endPos_r = cellfun(@(fall,wideenough) transpose(fall(wideenough)-1),falling_r,wideEnough_r,'UniformOutput',false);  %end of each span
 allInSpan_r = cellfun(@(starts,ends) arrayfun(@(x,y) (x:1:y), starts, ends, 'uni', false),startPos_r,endPos_r,'uni',false);  
 catspans_r=cellfun(@(spans) [spans{:}], allInSpan_r,'uni',false);
 wing_ext_frames_13frames_r=cellfun(@(indiv,catspan) indiv(catspan,:),ind_data,catspans_r,'UniformOutput',false);
 
 %left wing extension
  wing_ext_frames_left=cellfun(@(indiv) indiv(indiv(:,14)<-pi/6,:),ind_data,'UniformOutput',false);
 aboveThreshold_l=cellfun(@(indiv) (indiv(:,6)>pi/6),ind_data,'UniformOutput',false);
 aboveThreshold_l=cellfun(@(above) [false;above;false],aboveThreshold_l,'uni',false);
 edges_l = cellfun(@(above) diff(above),aboveThreshold_l,'UniformOutput',false);
 rising_l = cellfun(@(edge) find(edge==1),edges_l,'UniformOutput',false);    %rising/falling edges
 falling_l = cellfun(@(edge) find(edge==-1),edges_l,'UniformOutput',false);    %rising/falling edges
 spanWidth_l = cellfun(@(rise,fall) fall-rise,rising_l,falling_l,'UniformOutput',false);  %width of span of 1's (above threshold)
 wideEnough_l = cellfun(@(span) span >= 13,spanWidth_l,'UniformOutput',false);    
 startPos_l = cellfun(@(rise,wideenough) transpose(rise(wideenough)),rising_l,wideEnough_l,'UniformOutput',false);    %start of each span
 endPos_l = cellfun(@(fall,wideenough) transpose(fall(wideenough)-1),falling_l,wideEnough_l,'UniformOutput',false);  %end of each span
 allInSpan_l = cellfun(@(starts,ends) arrayfun(@(x,y) (x:1:y), starts, ends, 'uni', false),startPos_l,endPos_l,'uni',false);  
 catspans_l=cellfun(@(spans) [spans{:}], allInSpan_l,'uni',false);
 wing_ext_frames_13frames_l=cellfun(@(indiv,catspan) indiv(catspan,:),ind_data,catspans_l,'UniformOutput',false);

 %copulation
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

%right wing extension frames with copulation removed
 catspans_no_cop_r=cellfun(@(catspan,startPos_c) catspan(catspan<startPos_c(1)),catspans_r,startPos_contact,'uni',false);
 removed_copulation_r=cellfun(@(indiv,catspan) indiv(catspan,:),ind_data,catspans_no_cop_r,'UniformOutput',false);
 right_wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, removed_copulation_r,num2cell(indices),'UniformOutput',false);
%left wing extension frames with copulation removed
 catspans_no_cop_l=cellfun(@(catspan,startPos_c) catspan(catspan<startPos_c(1)),catspans_l,startPos_contact,'uni',false);
 removed_copulation_l=cellfun(@(indiv,catspan) indiv(catspan,:),ind_data,catspans_no_cop_l,'UniformOutput',false);
left_wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, removed_copulation_l,num2cell(indices),'UniformOutput',false);