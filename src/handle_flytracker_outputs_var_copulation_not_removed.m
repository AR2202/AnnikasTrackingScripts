function [wing_ext_frames_indexed] = handle_flytracker_outputs_var_copulation_not_removed(filename, wingextdur, minwingangle)
% Annika Rings, April 2019
% modified version of handle_flytracker_outputs supporting variable
% wingextention duration
%
%HANDLE_FLYTRACKER_OUTPOUT_VAR is a function that extracts wing extension
%frames
%the input arguments are:
%filename: name of the file that contains tracking data (-feat.mat file)
%wingextdur: number of contiguous frames that need to show wing extention
%to be counted as wing extension bouts
%minwingangle: minimum angle of wing to body axis to be counted as wing
%extension (radients)

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
load(filename);
indices = transpose(1:size(feat.data, 1));
featnumber = size(feat.data, 3);
if featnumber < 4
    error('cannot filter by wingextension: feature does not exist; try setting wingextonly to false')
end
ind_data = arrayfun(@(x) concatenate_data(x, featnumber, feat), indices, 'UniformOutput', false);
wing_ext_frames_all = cellfun(@(indiv) indiv(indiv(:, 4) > minwingangle, :), ind_data, 'UniformOutput', false);
aboveThreshold = cellfun(@(indiv) (indiv(:, 4) > minwingangle), ind_data, 'UniformOutput', false);
aboveThreshold = cellfun(@(above) [false; above; false], aboveThreshold, 'uni', false);
edges = cellfun(@(above) diff(above), aboveThreshold, 'UniformOutput', false);
rising = cellfun(@(edge) find(edge == 1), edges, 'UniformOutput', false); %rising/falling edges
falling = cellfun(@(edge) find(edge == -1), edges, 'UniformOutput', false); %rising/falling edges
spanWidth = cellfun(@(rise, fall) fall-rise, rising, falling, 'UniformOutput', false); %width of span of 1's (above threshold)
wideEnough = cellfun(@(span) span >= wingextdur, spanWidth, 'UniformOutput', false);
startPos = cellfun(@(rise, wideenough) transpose(rise(wideenough)), rising, wideEnough, 'UniformOutput', false); %start of each span
endPos = cellfun(@(fall, wideenough) transpose(fall(wideenough) - 1), falling, wideEnough, 'UniformOutput', false); %end of each span
allInSpan = cellfun(@(starts, ends) arrayfun(@(x, y) (x:1:y), starts, ends, 'uni', false), startPos, endPos, 'uni', false);
catspans = cellfun(@(spans) [spans{:}], allInSpan, 'uni', false);
wing_ext_frames_13frames = cellfun(@(indiv, catspan) indiv(catspan, :), ind_data, catspans, 'UniformOutput', false);

wing_ext_frames_indexed = cellfun(@(cell1, cell2) {cell1, cell2}, wing_ext_frames_13frames, num2cell(indices), 'UniformOutput', false);


end
